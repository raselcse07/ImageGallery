//
//  HTTPRequest.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/15.
//

import Foundation

class HTTPRequest<Model: Decodable>: RequestType {
    
    var baseURL: URL { fatalError(APIError.EHR1001.description) }
    var path: String { fatalError(APIError.EHR1002.description) }
    var method: HTTPMethod { fatalError(APIError.EHR1003.description) }
    var query: QueryItems? { return nil }
    var parameters: Parameters? { return nil }
    var headers: Headers { fatalError(APIError.EHR1004.description) }
    
}
