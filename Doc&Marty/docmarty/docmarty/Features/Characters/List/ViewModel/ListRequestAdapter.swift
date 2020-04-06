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

final class ListRequestAdapter {
    
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
        
        let detailItems = data.results.map { character -> DetailItemData in
          
            let imageURL = URL(string: character.image)
            
            var locationURL: URL?
            if let url = character.location?.url {
                locationURL = URL(string: url)
            }
            
            return DetailItemData(imageURL: imageURL,
                                  name: character.name,
                                  gender: character.gender,
                                  numberOfEpisodes: character.episode.count,
                                  locationURL: locationURL,
                                  locationName: character.location?.name,
                                  locationType: character.location?.type)
        }
        
        return ListData(items: items,
                        detailItems: detailItems,
                        totalPages: data.info.pages)
    }
}

// MARK: ListRequestAdapterProtocol
extension ListRequestAdapter: ListRequestAdapterProtocol {
    
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
