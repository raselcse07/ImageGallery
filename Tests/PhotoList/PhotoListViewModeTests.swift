//
//  PhotoListViewModeTests.swift
//  ImageGallery-Test
//
//  Created by Rasel on 2021/10/18.
//

import XCTest
import RxSwift
import RxTest

@testable import ImageGallery_PROD

class PhotoListViewModeTests: XCTestCase {
    
    private var dependency: Dependency!
    private var disposeBag: DisposeBag!
    
    private struct Dependency {
        let viewModel: PhotoListViewModel
        let scheduler = TestScheduler(initialClock: 0)
        
        init() {
            viewModel = PhotoListViewModel()
        }
    }
    
    override func setUp() {
        dependency = Dependency()
        disposeBag = DisposeBag()
    }
    
    func test_DoNotPrepareQueryIfTextIsLessThanThree() {
        
        let photos = dependency.scheduler.createObserver([Photo].self)
        
        dependency
            .viewModel
            .output
            .photos
            .drive(photos)
            .disposed(by: disposeBag)
        
        dependency
            .scheduler
            .createColdObservable([
                .next(10, "nature")
            ])
            .bind(to: dependency.viewModel.input.searchText)
            .disposed(by: disposeBag)
        
        dependency.scheduler.start()
        XCTAssert(1 != 1, "\(photos.events)")
//        XCTAssertEqual(photos.events, [
//            .next(0, []),
//            .next(10, []),
//            .next(20, [])
//        ])
    }
}

