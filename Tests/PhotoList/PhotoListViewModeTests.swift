//
//  PhotoListViewModeTests.swift
//  ImageGallery-Test
//
//  Created by Rasel on 2021/10/18.
//

import XCTest
import RxSwift
import RxTest
import RxCocoa

@testable import ImageGallery_PROD

class PhotoListViewModeTests: XCTestCase {
    
    typealias dataProvider = PhotoListTestDataProvider
    
    private var dependency: Dependency!
    private var disposeBag: DisposeBag!
    
    private struct Dependency {
        
        let searchRequest: Observable<PhotoFeedRequest>
        let searchResponse: PublishRelay<PhotoFeed>
        
        let viewModel: PhotoListViewModel
        let scheduler = TestScheduler(initialClock: 0)
    
        init() {
            let _searchRequest = PublishRelay<PhotoFeedRequest>()
            self.searchRequest = _searchRequest.asObservable()
            
            let _searchResponse = PublishRelay<PhotoFeed>()
            self.searchResponse = _searchResponse
            
            self.viewModel = PhotoListViewModel(service: { request in
                _searchRequest.accept(request)
                return _searchResponse.asObservable()
            }, scheduler: self.scheduler)
        }
        
        func start(_ time: Int = 10) {
            scheduler.advanceTo(scheduler.clock + time)
        }
    }
    
    override func setUp() {
        dependency = Dependency()
        disposeBag = DisposeBag()
    }
    
    func testDoNotSendRequestIfSearchKeyIsLessThanThree() {
        
        let request = BehaviorRelay<PhotoFeedRequest?>(value: nil)
        
        dependency
            .searchRequest
            .bind(to: request)
            .disposed(by: disposeBag)
        
        dependency
            .viewModel
            .input
            .searchText
            .onNext(dataProvider.searchTermLessThanThree)
        
        dependency.start()
        
        XCTAssertNil(request.value)
    }
    
    func testSendRequestIfSearchKeyIsGreaterThanOrEqualThree() {
        
        let request = BehaviorRelay<PhotoFeedRequest?>(value: nil)
        
        dependency
            .searchRequest
            .bind(to: request)
            .disposed(by: disposeBag)
        
        dependency
            .viewModel
            .input
            .searchText
            .onNext(dataProvider.searchTermEqualToThree)
        
        dependency.start()
        
        XCTAssertNotNil(request.value)
        XCTAssertEqual(request.value?.searchTerm, dataProvider.searchTermEqualToThree)
    }
    
    func testFetchPhotos() {
        
        let photos = BehaviorRelay<[Photo]>(value: [])
        
        dependency
            .viewModel
            .output
            .photos
            .bind(to: photos)
            .disposed(by: disposeBag)
        
        dependency
            .viewModel
            .input
            .searchText
            .onNext(dataProvider.searchTermValidWord)
        
        dependency.start()
        
        let expectedPhotoFeed = dataProvider.getFirstPageFeed()
        dependency.searchResponse.accept(expectedPhotoFeed)
        
        XCTAssertFalse(photos.value.isEmpty)
        XCTAssertEqual(photos.value.count, expectedPhotoFeed.photos.count)
        XCTAssertEqual(photos.value, expectedPhotoFeed.photos)
    }
    
    func testFetchNextPagePhoto() {
        
        let photos = BehaviorRelay<[Photo]>(value: [])
        
        let firstPage = dataProvider.getFirstPageFeed()
        let secondPage = dataProvider.getSecondPageFeed()
        
        dependency
            .viewModel
            .output
            .photos
            .bind(to: photos)
            .disposed(by: disposeBag)
        
        // request for first page
        dependency
            .viewModel
            .input
            .searchText
            .onNext(dataProvider.searchTermValidWord)
        
        dependency.start()
        
        dependency.searchResponse.accept(firstPage)
        
        // request for next page
        dependency
            .viewModel
            .input
            .fetchNextPage
            .onNext(true)
        
        dependency.start()
        
        dependency.searchResponse.accept(secondPage)
        
        let totalPhotos = firstPage.photos + secondPage.photos
        
        XCTAssertFalse(photos.value.isEmpty)
        XCTAssertEqual(photos.value.count, totalPhotos.count)
        XCTAssertEqual(firstPage.page, 1)
        XCTAssertEqual(secondPage.page, 2)
    }
    
    func testDoNoTriggerAPIIfNextPageNotAvailable() {
        
        let photos = BehaviorRelay<[Photo]>(value: [])
    
        let firstPage = dataProvider.getFirstPageFeed()
        let secondPage = dataProvider.getSecondPageFeed()
        let thirdPage = dataProvider.getThirdPageFeed()
        
        dependency
            .viewModel
            .output
            .photos
            .bind(to: photos)
            .disposed(by: disposeBag)
        
        // request for first page
        dependency
            .viewModel
            .input
            .searchText
            .onNext(dataProvider.searchTermValidWord)
        
        dependency.start()
        dependency.searchResponse.accept(firstPage)
        
        // request for 2nd page
        dependency
            .viewModel
            .input
            .fetchNextPage
            .onNext(true)
        
        dependency.start()
        dependency.searchResponse.accept(secondPage)
        
        // request for 3rd page
        dependency
            .viewModel
            .input
            .fetchNextPage
            .onNext(true)
        
        dependency.start()
        dependency.searchResponse.accept(thirdPage)
        
        // request for forth
        let request = BehaviorRelay<PhotoFeedRequest?>(value: nil)
        
        dependency
            .searchRequest
            .bind(to: request)
            .disposed(by: disposeBag)
        
        dependency
            .viewModel
            .input
            .fetchNextPage
            .onNext(true)
        
        dependency.start()
        
        let totalPhotos = firstPage.photos + secondPage.photos + thirdPage.photos
        
        XCTAssertFalse(photos.value.isEmpty)
        XCTAssertEqual(photos.value.count, totalPhotos.count)
        XCTAssertEqual(firstPage.page, 1)
        XCTAssertEqual(secondPage.page, 2)
        XCTAssertEqual(thirdPage.page, 3)
        XCTAssertNil(thirdPage.nextPage)
        XCTAssertNil(request.value)
    }
}

