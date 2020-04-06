//
//  DetailService.swift
//  docmarty
//
//  Created by Luís Vieira on 06/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import Foundation

protocol DetailServiceProtocol {
    func location(url: URL, completion: @escaping (Result<LocationModel, ServiceError>) -> Void)
}

final class DetailService {
    
    // MARK: Properties
    private let client: RequestClient
    private let decoder: JSONDecoder
    
    // MARK: Lifecycle
    public init(client: RequestClient, decoder: JSONDecoder) {
        self.client = client
        self.decoder = decoder
    }
}

// MARK: DetailServiceProtocol
extension DetailService: DetailServiceProtocol {
    
    func location(url: URL, completion: @escaping (Result<LocationModel, ServiceError>) -> Void) {
        
        client.request(url: url) { [weak self] (result: Result<Data, Error>) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                
                guard
                    let model = try? self.decoder.decode(LocationModel.self, from: data)
                    else { return }
                
                completion(.success(model))
            
            case .failure:
                completion(.failure(ServiceError.unknownError))
                return
            }
        }
    }
}
