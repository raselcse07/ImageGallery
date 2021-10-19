//
//  APIError.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/15.
//

import Foundation

struct APIError: Error {
    
    // MARK: - Properties
    var code: String
    var description: String
    
    // MARK: - Errors
    
    ///- Tag: EHR → Errors of HTTP Request
    static var EHR1001    = APIError(code: "EHR1001", description: "Please override baseURL.")
    static var EHR1002    = APIError(code: "EHR1002", description: "Please override path.")
    static var EHR1003    = APIError(code: "EHR1003", description: "Please override method.")
    static var EHR1004    = APIError(code: "EHR1004", description: "Please override headers.")
    static var EHR1005    = APIError(code: "EHR1005", description: "Please override API provider type.")
    
    /// - Tag: EHC → Errors of HTTP Client
    static var EHC10001   = APIError(code: "EHC10001", description: "Invalid Response.")
    static var EHC10002   = APIError(code: "EHC10002", description: "Falied while decoding from JSON.")
    
    /// - Tag: - Add extra description to an existing error
    mutating func extend(with value: Any) -> APIError {
        description += "\n\(value)"
        return self
    }
}

extension APIError: LocalizedError, CustomStringConvertible {
    
    var errorDescription: String? {
        return description
    }
}
