//
//  PhotoListViewModel.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/16.
//

import Foundation
import RxSwift
import RxCocoa

class PhotoListViewModel: ViewModelType {
    
    // MARK: - Input
    struct Input {
        let searchText: AnyObserver<String>
        let itemSelected: AnyObserver<IndexPath>
        let loadMore: AnyObserver<Void>
    }
    
    // MARK:- Output
    struct Output {
        let photos: Observable<[Photo]>
        let detail: Observable<Photo>
    }
    
    // MARK: - Properties
    var input: Input!
    var output: Output!
    
    private var disposeBag = DisposeBag()
    private var currentPage: Int = 0
    private var currentQuery: String = ""
    private var isPaginated: Bool = false
    private let _searchText = ReplaySubject<String>.create(bufferSize: 1)
    private let _itemSelected = PublishSubject<IndexPath>()
    private let _loadMore = PublishSubject<Void>()
    private let _photos = BehaviorRelay<[Photo]>(value: [])
    private let _detail = PublishSubject<Photo>()
    
    init() {
        bind()
    }
    
    func bind() {
        
        let searchWithText = _searchText
            .debounce(.milliseconds(500), scheduler: ConcurrentMainScheduler.instance)
            .do(onNext: { [weak self] text in
                guard let self = self else { return }
                // check weater the request is paginated or not
                self.isPaginated = (text == self.currentQuery)
                if !self.isPaginated {
                    // reset current page
                    self.currentPage = 0
                }
            })
            .flatMap { text -> Observable<String> in
                if text.isEmpty {
                    return .just(Const.SEARCH_INITIAL)
                } else {
                    return .just(text)
                }
            }
            .share()
    
        // Fetch Photos
        let searchResult = searchWithText
            .flatMap { [weak self] text -> Observable<Event<[Photo]>> in
                guard let self = self else { return .empty() }
                let page = self.currentPage > 1 ? self.currentPage : 1
                return self.fetchFeed(query: text, page: page)
                    .do(onNext: {
                        self.currentPage = $0.page
                        self.currentQuery = text
                    })
                    .map { feed -> [Photo] in
                        if self.isPaginated {
                            return self._photos.value + feed.photos
                        } else {
                            return feed.photos
                        }
                    }
                    .materialize()
            }
            .share()
            
            searchResult
                .flatMap { $0.element.map(Observable.just) ?? .empty() }
                .bind(to: _photos)
                .disposed(by: disposeBag)
        
        // Load photos from next page
        _loadMore
            .bind { [weak self] in
                guard let self = self else { return }
                self.currentPage += 1
                self._searchText.onNext(self.currentQuery)
            }
            .disposed(by: disposeBag)
        
        // Item Selected
        _itemSelected
            .map { indexPath ->  Photo in
                return self._photos.value[indexPath.row]
            }
            .bind(to: _detail)
            .disposed(by: disposeBag)
        
        // Input & Output
        input = Input(
            searchText: _searchText.asObserver(),
            itemSelected: _itemSelected.asObserver(),
            loadMore: _loadMore.asObserver()
        )
        output = Output(
            photos: _photos.asObservable(),
            detail: _detail.asObservable()
        )
    }
    
    private func fetchFeed(query: String, page: Int) -> Observable<PhotoFeed> {
        let request = PhotoFeedRequest(searchTerm: query, page: page)
        let task = APIClient.shared.send(request)
            .asObservable()
            .share()
        task.subscribe().disposed(by: disposeBag)
        return task
    }
}
