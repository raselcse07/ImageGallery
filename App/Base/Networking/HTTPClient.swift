//
//  HTTPClient.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/15.
//

import Foundation
import RxSwift

class HTTPClient {
    
    // MARK: - Singleton
    public static let shared: HTTPClient = .init()
    private init() {}
    
    // MARK: - Properties
    
    private var config: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        return config
    }
    
    private var session: URLSession {
        return URLSession(configuration: config)
    }
    
    // MARK: - Send Request
    func send<Model: Decodable>(_ request: HTTPRequest<Model>) -> Observable<Model> {
        return session.rx.response(request: request.urlRequest)
            .map { result -> Data in
                // Check Error
                guard result.response.statusCode == 200 else {
                    throw APIError.EHC10001.extent(with: result.response)
                }
                return result.data
            }
            .map { data -> Model in
                // Covert JSON to Model
                do {
                    let decoder = JSONDecoder()
                    return try decoder.decode(Model.self, from: data)
                } catch let error {
                    throw APIError.EHC10002.extent(with: error)
                }
            }
            .asSingle()
            .observe(on: MainScheduler.asyncInstance)
            .asObservable()
    }
}
