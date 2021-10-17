//
//  RequestType.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/15.
//

import Foundation

protocol RequestType {
    // API Base URL
    var baseURL: URL { get }
    // Path of API
    var path: String { get }
    // Method
    var method: HTTPMethod { get }
    // QueryItems
    var query: QueryItems? { get }
    // Parameters
    var parameters: Parameters? { get }
    // Headers
    var headers: Headers { get }
}

extension RequestType {
    
    // Create URL (BaseURL + Path + QueryItems)
    private var url: URL {
        var components = URLComponents()
        
        components.host     = baseURL.host
        components.scheme   = baseURL.scheme
        components.path     = baseURL.path + path
        
        // Check QueryItems
        guard let query = query else {
            // Has no query items
            return components.url!
        }
        // Has query items
        components.queryItems = query.map { URLQueryItem(name: $0, value: $1 as? String) }
        return components.url!
    }
    
    // Check whether request is JSON request or not
    private var isJSON: Bool {
        return headers["Content-Type"]?.lowercased().contains("application/json") ?? false
    }
    
    // Prepare URLRequest
    var urlRequest: URLRequest {
        
        var request = URLRequest(url: url)
        // Set Method
        request.httpMethod = method.rawValue
        // Set headers
        headers.forEach { value in
            let (k, v) = value
            request.addValue(v, forHTTPHeaderField: k)
        }
        // Set body if has
        guard isJSON else {
            return request
        }
        
        // Check Parameters
        guard let param = parameters else {
            return request
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: param, options: [.prettyPrinted])
        } catch {
            return request
        }
        
        return request
    }
}
