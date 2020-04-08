//
//  APIClient.swift
//  docmarty
//
//  Created by Luís Vieira on 05/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import Foundation

protocol RequestClient {
    func request(endpoint: Endpoint, completion: @escaping (Result<Data, Error>) -> Void)
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

final class APIClient {
    
    // MARK: Properties
    private let session: URLSession
    
    // MARK: Lifecycle
    init(withSession session: URLSession) {
        self.session = session
    }
}

// MARK: RequestClient
extension APIClient: RequestClient {
    
    func request(endpoint: Endpoint, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = endpoint.url else { return }
        request(url: url, completion: completion)
    }
    
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(ServiceError.unknownError))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}

