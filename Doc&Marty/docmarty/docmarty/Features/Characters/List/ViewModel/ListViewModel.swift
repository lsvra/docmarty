//
//  ListViewModel.swift
//  docmarty
//
//  Created by Luís Vieira on 04/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import Foundation
import Kingfisher

final class ListViewModel: ViewModel {
    
    // MARK: Properties    
    struct Dependencies {
        let adapter: ListRequestAdapterProtocol
        weak var coordinator: CharactersCoordinatorDelegate?
    }
    
    struct Bindings {
        let onTitleLoaded: (String) -> Void
        let onDataLoaded: () -> Void
        let onError: (ServiceError) -> Void?
    }
    
    private enum Constants {
        
        enum Section {
            static let numberOfSections: Int = 1
        }
        
        enum Loader {
            static let newItemsThreshold: Int = 4
        }
        
        enum Localization {
            static var title: String = "character_list_title"
        }
    }
    
    var dependencies: Dependencies
    var bindings: Bindings?
    
    private var items: [ConfigurableItem] = []
    private var detailItems: [DetailItemData] = []
    private var currentPage: Int = 1
    private var totalPages: Int = 0
    
    // MARK: Lifecycle
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: Methods
    private func loadCharaters(page: Int) {
        
        dependencies.adapter.allCharacters(page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data): self.handleSuccess(data)
            case let .failure(error): self.handleError(error)
            }
        }
    }
    
    private func handleSuccess(_ data: ListData) {
        
        totalPages = data.totalPages
    
        prefetch(items: data.items)
        
        items.append(contentsOf: data.items)
        detailItems.append(contentsOf: data.detailItems)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.bindings?.onDataLoaded()
        }
    }
    
    private func handleError(_ error: ServiceError) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.bindings?.onError(error)
        }
    }
    
    private func prefetch(items: [ConfigurableItem]) {
        
        let urlsToPrefetch = items.reduce([]) { (urls, item) -> [URL?] in
            guard let item = item as? Prefetchable else { return [] }
            return item.urlsToPrefetch
        }.compactMap { $0 }
        
        ImagePrefetcher(urls: urlsToPrefetch).start()
    }
}

// MARK: Public Methods
extension ListViewModel {
    
    func loadData() {
        bindings?.onTitleLoaded(Constants.Localization.title.localized)
        loadCharaters(page: currentPage)
    }
    
    func numberOfSections() -> Int {
        return Constants.Section.numberOfSections
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        //Let's use just a single section for now
        return items.count
    }
    
    func configuratorForItem(at indexPath: IndexPath) -> CellConfigurator? {
        return items[indexPath.row].configurator
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        
        guard
            !items.isEmpty,
            indexPath.row == items.count - Constants.Loader.newItemsThreshold,
            currentPage < totalPages
            else { return }

        currentPage += 1
        loadCharaters(page: currentPage)
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        
        let data = detailItems[indexPath.row]
        dependencies.coordinator?.openDetail(withData: data)
    }
}
