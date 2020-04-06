//
//  ListService.swift
//  docmarty
//
//  Created by Luís Vieira on 05/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import Foundation

protocol ListServiceProtocol {
    func allCharacters(page: Int, completion: @escaping (Result<ListModel, ServiceError>) -> Void)
}

final class ListService: ListServiceProtocol {
    
    // MARK: Properties
    private let client: RequestClient
    private let decoder: JSONDecoder
    
    // MARK: Lifecycle
    public init(client: RequestClient, decoder: JSONDecoder) {
        self.client = client
        self.decoder = decoder
    }
}

// MARK: Public Methods
extension ListService {
    
    func allCharacters(page: Int, completion: @escaping (Result<ListModel, ServiceError>) -> Void) {
        
        client.request(endpoint: .listCharacters(page: page)) { [weak self] (result: Result<Data, Error>) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                
                guard
                    let model = try? self.decoder.decode(ListModel.self, from: data)
                    else { return }
                
                completion(.success(model))
            
            case .failure:
                completion(.failure(ServiceError.unknownError))
                return
            }
        }
    }
}
