//
//  APIRequest.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/15.
//

import Foundation

class APIRequest<Model: Decodable>: HTTPRequest<Model> {
    
    override var baseURL: URL {
        return APIConfig.baseURL
    }
    
    override var headers: Headers {
        return [
            "Authorization" : "Bearer \(Const.API_KEY)"
        ]
    }
}
