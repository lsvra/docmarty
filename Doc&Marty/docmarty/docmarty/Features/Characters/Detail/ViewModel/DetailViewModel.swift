//
//  DetailViewModel.swift
//  docmarty
//
//  Created by Luís Vieira on 06/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import Foundation

final class DetailViewModel: ViewModel {
    
    // MARK: Properties
    struct Dependencies {
        let data: DetailItemData
        let adapter: DetailRequestAdapterProtocol
        weak var coordinator: CharactersCoordinatorDelegate?
    }
    
    struct Bindings {
        let onTitleLoaded: (String) -> Void
        let onDataLoaded: (Details) -> Void
        let onError: (ServiceError) -> Void
    }
    
    private enum Constants {
        
        enum Localization {
            static var nameDescription: String = "character_detail_description_name".localized
            static var genderDescription: String = "character_detail_description_gender".localized
            static var numberOfEpisodesDescription: String = "character_detail_description_number_of_episodes".localized
            static var locationDescription: String = "character_detail_description_location_name".localized
        }
    }
    
    var dependencies: Dependencies
    var bindings: Bindings?
    
    private var data: DetailItemData
    
    // MARK: Lifecycle
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.data = dependencies.data
    }
    
    // MARK: Methods
    private func loadLocation(url: URL) {
        
        dependencies.adapter.location(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data): self.handleSuccess(data)
            case let .failure(error): self.handleError(error)
            }
        }
    }
    
    private func handleSuccess(_ data: DetailData) {
        
        self.data.locationType = data.locationType
        
        let detail = details(withData: self.data)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.bindings?.onDataLoaded(detail)
        }
    }
    
    private func handleError(_ error: ServiceError) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.bindings?.onError(error)
        }
    }
    
    private func details(withData data: DetailItemData) -> Details {
        
        let imageURL = data.imageURL
        let name = "\(Constants.Localization.nameDescription) \(data.name)"
        let gender = "\(Constants.Localization.genderDescription) \(data.gender)"
        let numberOfEpisodes = "\(Constants.Localization.numberOfEpisodesDescription) \(data.numberOfEpisodes.description)"
        
        var location: String?
        if
            let locationType = data.locationType,
            let locationName = data.locationName {
            location = "\(Constants.Localization.locationDescription) \(locationName) (\(locationType))"
        }
        
        return Details(imageURL: imageURL,
                       name: name,
                       gender: gender,
                       numberOfEpisodes: numberOfEpisodes,
                       location: location)
    }
}

// MARK: Public Methods
extension DetailViewModel {
    
    func loadData() {
        
        bindings?.onTitleLoaded(data.name)
        
        guard let url = data.locationURL else { return }
        loadLocation(url: url)
    }
}
