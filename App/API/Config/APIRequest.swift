//
//  APIRequest.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/15.
//

import Foundation

class APIRequest<Model: Decodable>: HTTPRequest<Model> {
    
    var provider: APIConfig { fatalError(APIError.EHR1005.description) }
    
    override var baseURL: URL {
        return provider.baseURL
    }
    
    override var headers: Headers {
        return provider.headers
    }
}
