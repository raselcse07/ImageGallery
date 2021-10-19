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
        let fetchNextPage: AnyObserver<Bool>
    }
    
    // MARK:- Output
    struct Output {
        let photos: BehaviorRelay<[Photo]>
        let detail: Observable<Photo>
        let currentStartIndex: BehaviorRelay<Int>
        let currentEndIndex: BehaviorRelay<Int>
    }
        
    // MARK: - Properties
    var input: Input!
    var output: Output!
    
    private var disposeBag = DisposeBag()
    private var currentPage: Int = 0
    private var currentQuery: String = ""
    private var hasNext: Bool = false
    
    private let searchTextSubject = ReplaySubject<String>.create(bufferSize: 1)
    private let itemSelectedSubject = PublishSubject<IndexPath>()
    private let fetchNextSubject = PublishSubject<Bool>()
    private let photosBehaviorRelay = BehaviorRelay<[Photo]>(value: [])
    private let detailSubject = PublishSubject<Photo>()
    private let currentStartIndexSubject = BehaviorRelay<Int>(value: 0)
    private let currentEndIndexSubject = BehaviorRelay<Int>(value: 0)
    
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
            searchText: searchTextSubject.asObserver(),
            itemSelected: itemSelectedSubject.asObserver(),
            fetchNextPage: fetchNextSubject.asObserver()
        )
        output = Output(
            photos: photosBehaviorRelay,
            detail: detailSubject.asObservable(),
            currentStartIndex: currentStartIndexSubject,
            currentEndIndex: currentEndIndexSubject
        )
    }
    
    func createIndexPathToReload(start: Int, end: Int) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        for i in start...end {
            indexPaths.append(IndexPath(item: i, section: 0))
        }
        return indexPaths
    }
    
    /// Prepare `Observable` string with the text of search bar
    /// - Returns: `Observable`
    private func prepareSearchQuery() -> Observable<String> {
        let searchQuery = searchTextSubject
            .debounce(.milliseconds(500), scheduler: ConcurrentMainScheduler.instance)
            .flatMap { text -> Observable<String> in
                if text.isEmpty {
                    return .just(Const.SEARCH_INITIAL)
                } else if text.count < 3 {
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
                        self.hasNext = $0.nextPage != nil
                        self.currentStartIndexSubject.accept(0)
                        self.currentEndIndexSubject.accept(0)
                    })
                    .map { $0.photos }
                    .materialize()
            }
            .share()
        
        searchResult
            .flatMap { $0.element.map(Observable.just) ?? .empty() }
            .subscribe(onNext: { photos in
                // update photos
                self.photosBehaviorRelay.accept(photos)
            })
            .disposed(by: disposeBag)
    }
    
    /// Fetch the data of next page
    private func prepareNextPageResult() {
        fetchNextSubject
            .throttle(.milliseconds(500), scheduler: ConcurrentMainScheduler.instance)
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] shouldFetchNext in
                guard let self = self else { return }
                if shouldFetchNext && self.hasNext {
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
                // current photos
                let current = self.photosBehaviorRelay.value
                // update current page
                self.currentPage = feed.page
                // update next page flag
                self.hasNext = feed.nextPage != nil
                // update current start & end index
                self.setCurrentStartEndIndex(start: current.count, end: feed.photos.count - 1)
                // update photos
                self.photosBehaviorRelay.accept(current + feed.photos)
            })
            .disposed(by: disposeBag)
    }
    
    
    /// Get Selected Photo Information
    private func observeSelectedItem() {
        itemSelectedSubject
            .withLatestFrom(photosBehaviorRelay) { ($0.row, $1)}
            .flatMap { (index, photo) -> Observable<Photo> in
                guard index < photo.count else {
                    return .empty()
                }
                return .just(photo[index])
            }
            .bind(to: detailSubject)
            .disposed(by: disposeBag)
    }
    
    /// - Update current start & end index
    private func setCurrentStartEndIndex(start: Int, end: Int) {
        // update current start index
        currentStartIndexSubject.accept(start)
        // update current end index
        currentEndIndexSubject.accept(currentStartIndexSubject.value + end)
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
