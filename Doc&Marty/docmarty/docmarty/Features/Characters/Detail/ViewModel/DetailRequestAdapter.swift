//
//  DetailRequestAdapter.swift
//  docmarty
//
//  Created by Luís Vieira on 06/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import Foundation

protocol DetailRequestAdapterProtocol {
    func location(url: URL, completion: @escaping (Result<DetailData, ServiceError>) -> Void)
}

final class DetailRequestAdapter {
    
    // MARK: Properties
    private var service: DetailService
    
    // MARK: Lifecycle
    public init(service: DetailService) {
        self.service = service
    }
    
    // MARK: Methods
    private func transform(data: LocationModel) -> DetailData {
        return DetailData(locationType: data.type)
    }
}

// MARK: DetailRequestAdapterProtocol
extension DetailRequestAdapter: DetailRequestAdapterProtocol {
    
    func location(url: URL, completion: @escaping (Result<DetailData, ServiceError>) -> Void) {
        
        service.location(url: url) { [weak self] (result: Result<LocationModel, ServiceError>) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                completion(.success(self.transform(data: data)))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
