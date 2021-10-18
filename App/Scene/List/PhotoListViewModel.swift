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
        let loadMore: AnyObserver<Bool>
    }
    
    // MARK:- Output
    struct Output {
        let photos: Driver<[Photo]>
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
    private let _loadMore = PublishSubject<Bool>()
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
            photos: _photos.asDriver(onErrorJustReturn: []),
            detail: _detail.asObservable()
        )
    }
    
    /// Prepare `Observable` string with the text of search bar
    /// - Returns: `Observable`
    private func prepareSearchQuery() -> Observable<String> {
        let searchQuery = _searchText
            .debounce(.milliseconds(500), scheduler: ConcurrentMainScheduler.instance)
            .flatMap { text -> Observable<String> in
                if text.isEmpty {
                    return .just(Const.SEARCH_INITIAL)
                } else if text.count < 2 {
                    return .empty()
                }
                else {
                    return .just(text)
                }
            }
            .filter { $0 != self.currentQuery }
            .share()
        return searchQuery
    }
    
    /// Prepare search result with search query
    /// - Parameter query: `Observable<String>`
    private func prepareSearchResult(with query: Observable<String>) {
        let searchResult = query
            .flatMap { [weak self] text -> Observable<Event<[Photo]>> in
                guard let self = self else { return .empty() }
                return self.fetchFeed(query: text, page: 1)
                    .do(onNext: {
                        self.currentPage = $0.page
                        self.currentQuery = text
                    })
                    .map { $0.photos }
                    .materialize()
            }
            .share()
        
        searchResult
            .flatMap { $0.element.map(Observable.just) ?? .empty() }
            .subscribe(onNext: { photos in
                self._photos.accept(photos)
            })
            .disposed(by: disposeBag)
    }
    
    /// Fetch the data of next page
    private func prepareNextPageResult() {
        _loadMore
            .throttle(.milliseconds(500), scheduler: ConcurrentMainScheduler.instance)
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] next in
                guard let self = self else { return }
                if next {
                    self.loadNext(query: self.currentQuery, page: self.currentPage + 1)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func loadNext(query: String, page: Int) {
        fetchFeed(query: query, page: page)
            .subscribe(onNext: { [weak self] feed in
                guard let self = self else { return }
                guard feed.photos.count > 0 else {
                    return
                }
                let current = self._photos.value
                self._photos.accept(current + feed.photos)
                self.currentPage = feed.page
            })
            .disposed(by: disposeBag)
    }
    
    /// Get Selected Photo Information
    private func observeSelectedItem() {
        _itemSelected
            .withLatestFrom(_photos) { ($0.row, $1)}
            .flatMap { (index, photo) -> Observable<Photo> in
                guard index < photo.count else {
                    return .empty()
                }
                return .just(photo[index])
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
