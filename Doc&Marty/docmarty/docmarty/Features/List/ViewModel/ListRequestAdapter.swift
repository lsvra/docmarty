//
//  ListRequestAdapter.swift
//  docmarty
//
//  Created by Luís Vieira on 05/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import Foundation

protocol ListRequestAdapterProtocol {
    func allCharacters(page: Int, completion: @escaping (Result<ListData, ServiceError>) -> Void)
}

final class ListRequestAdapter: ListRequestAdapterProtocol {
    
    // MARK: Properties
    private var service: ListService
    
    // MARK: Lifecycle
    public init(service: ListService) {
        self.service = service
    }
    
    // MARK: Methods
    private func transform(data: ListModel) -> ListData {
        
        let items = data.results.map { character -> ConfigurableItem in
            return ListCellViewModel(title: character.name,
                                     imageURL: URL(string: character.image))
        }
        
        return ListData(items: items, totalPages: data.info.pages)
    }
}

// MARK: Public Methods
extension ListRequestAdapter {
    
    func allCharacters(page: Int, completion: @escaping (Result<ListData, ServiceError>) -> Void) {
        
        service.allCharacters(page: page) { [weak self] (result: Result<ListModel, ServiceError>) in
            
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
