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
                return "563492ad6f917000010000014f53a76779ff4cde882b473e1d65a330"
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

