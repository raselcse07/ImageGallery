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
        // preapare search query
        let searchQuery = prepareSearchQuery()
        // fetch photos with the query
        prepareSearchResult(with: searchQuery)
        // load photos of next page (if any)
        prepareNextPageResult()
        // observe selected item
        observeSelectedItem()
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
    
    /// Prepare `Observable` string with the text of search bar
    /// - Returns: `Observable`
    private func prepareSearchQuery() -> Observable<String> {
        let searchQuery = _searchText
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
        return searchQuery
    }
    
    /// Prepare search result with search query
    /// - Parameter query: `Observable<String>`
    private func prepareSearchResult(with query: Observable<String>) {
        let searchResult = query
            .flatMap { [weak self] text -> Observable<Event<[Photo]>> in
                guard let self = self else { return .empty() }
                let page = self.currentPage > 1 ? self.currentPage : 1
                return self.fetchFeed(query: text, page: page)
                    .do(onNext: {
                        if $0.nextPage == nil {
                            self._loadMore.onCompleted()
                        } else {
                            // set current page & search query
                            self.currentPage = $0.page
                            self.currentQuery = text
                        }
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
    }
    
    /// Fetch the data of next page
    private func prepareNextPageResult() {
        _loadMore
            .bind { [weak self] in
                guard let self = self else { return }
                self.currentPage += 1
                self._searchText.onNext(self.currentQuery)
            }
            .disposed(by: disposeBag)
    }
    
    /// Get Selected Photo Information
    private func observeSelectedItem() {
        _itemSelected
            .map { [unowned self] indexPath ->  Photo in
                return self._photos.value[indexPath.row]
            }
            .bind(to: _detail)
            .disposed(by: disposeBag)
    }
    
    /// Request for `PhotoFeed`
    /// - Parameter query: Any String.
    /// - Parameter page: Desired page
    /// - Returns: `Observable<PhotoFeed>`
    private func fetchFeed(query: String, page: Int) -> Observable<PhotoFeed> {
        let request = PhotoFeedRequest(searchTerm: query, page: page)
        let task = APIClient.shared.send(request)
            .asObservable()
            .share()
        task.subscribe().disposed(by: disposeBag)
        return task
    }
}
