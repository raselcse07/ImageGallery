//
//  APIConfig.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/17.
//

import Foundation

protocol APIConfigProtocol {
    static var baseURL: URL { get }
}

struct APIConfig: APIConfigProtocol {
    
    static var baseURL: URL {
        return URL(string: baseURLString)!
    }
}

