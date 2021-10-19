//
//  PhotoListTestDataProvider.swift
//  ImageGallery-Test
//
//  Created by Rasel on 2021/10/19.
//

import Foundation

@testable import ImageGallery_PROD

struct PhotoListTestDataProvider {
    
    static let searchTermLessThanThree = "na"
    static let searchTermEqualToThree = "nat"
    static let searchTermValidWord = "nature"
    
    static func getFirstPageFeed() -> PhotoFeed {
        return PhotoFeed(
            page: 1,
            perPage: 5,
            photos: getTestPhotos(),
            totalResults: 50,
            nextPage: "https://test.com/photos?page=2")
    }
    
    static func getSecondPageFeed() -> PhotoFeed {
        return PhotoFeed(
            page: 2,
            perPage: 5,
            photos: getTestPhotos(),
            totalResults: 50,
            nextPage: "https://test.com/photos?page=2")
    }
    
    static func getThirdPageFeed() -> PhotoFeed {
        return PhotoFeed(
            page: 3,
            perPage: 5,
            photos: getTestPhotos(),
            totalResults: 50,
            nextPage: nil)
    }
    
    
    static func getTestPhotos() -> [Photo] {
        return (1...5).map {
            Photo(
                id: $0,
                url: "https://test.com/photos/photo_\($0).jpg",
                photographer: "Photographer - \($0)",
                src: Src(
                    medium: "https://test.com/photos/photo_\($0)_medium.jpg",
                    large2x: "https://test.com/photos/photo_\($0)_large2x.jpg"
                ))
        }
    }
}
