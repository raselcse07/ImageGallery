//
//  PhotoFeed.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/16.
//

import Foundation

// MARK: - PhotoFeed
struct PhotoFeed: Decodable {
    let page: Int
    let perPage: Int
    let photos: [Photo]
    let totalResults: Int
    let nextPage: String?
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case photos
        case totalResults = "total_results"
        case nextPage = "next_page"
    }
}

// MARK: - Photo
struct Photo: Decodable {
    let id: Int
    let url: String
    let photographer: String
    let src: Src
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case photographer
        case src
    }
}

// MARK: - Src
struct Src: Decodable {
    let medium: String
    let large2x: String
    
    enum CodingKeys: String, CodingKey {
        case medium
        case large2x
    }
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}
