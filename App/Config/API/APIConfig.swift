//
//  APIConfig.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/17.
//

import Foundation

protocol APIConfigProtocol {
    var baseURL: URL { get }
}

enum APIConfig: APIConfigProtocol {
    
    case pexels
    
    var baseURL: URL {
        switch self {
            case .pexels:
                return  URL(string: baseURLString)!
        }
    }
    
    var authKey: String {
        switch self {
            case .pexels:
                return "563492ad6f91700001000001479b02c753ef4400a179c035e516a474"
        }
    }
    
    var headers: Headers {
        switch self {
            case .pexels:
                return [
                    "Authorization" : "Bearer \(authKey)"
                ]
        }
    }
}

