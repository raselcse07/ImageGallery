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
    
    let url: String
    let photographer: String
    let src: Src
    
    enum CodingKeys: String, CodingKey {
        case url
        case photographer
        case src
    }
}

// MARK: - Src
struct Src: Decodable {
    let medium: String
    
    enum CodingKeys: String, CodingKey {
        case medium
    }
}

