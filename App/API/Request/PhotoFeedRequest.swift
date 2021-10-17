//
//  PhotoFeedRequest.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/16.
//

import Foundation


class PhotoFeedRequest: APIRequest<PhotoFeed> {
    
    override var path: String {
        return "/search"
    }
    
    override var method: HTTPMethod {
        return .get
    }
    
    override var query: QueryItems? {
        return [
            "query"     : searchTerm,
            "per_page"  : String(describing: 20),
            "page"      : String(describing: page)
        ]
    }
    
    let searchTerm: String
    let page: Int
    
    // MARK: - Initializer
    init(searchTerm: String, page: Int) {
        self.searchTerm = searchTerm
        self.page = page
    }
}
