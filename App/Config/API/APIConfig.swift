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
    
    static var authKey: String {
        return "563492ad6f91700001000001eef89af6662c480d83814d43ebc2af7c"
    }
}

