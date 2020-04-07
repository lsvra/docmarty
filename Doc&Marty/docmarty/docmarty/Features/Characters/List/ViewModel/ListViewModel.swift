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
    
    private struct ListResults {
        
        var items: [ConfigurableItem] = []
        var detailItems: [DetailItemData] = []
        var currentPage: Int = 1
        var totalPages: Int = 0
        var param: String? = nil
    }
    
    var dependencies: Dependencies
    var bindings: Bindings?
    
    private var results = ListResults()
    private var filteredResults = ListResults()
    
    private var isFiltering: Bool = false
    
    // MARK: Lifecycle
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: Methods
    private func loadCharaters(page: Int? = nil, name: String? = nil) {
        
        dependencies.adapter.characters(page: page, name: name) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data): self.handleSuccess(data)
            case let .failure(error): self.handleError(error)
            }
        }
    }
    
    private func handleSuccess(_ data: ListData) {
        
        if isFiltering {
            append(data, toPreviousResults: &filteredResults)
        } else {
            append(data, toPreviousResults: &results)
        }
        
        prefetch(items: data.items)
        
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
    
    private func append(_ data: ListData, toPreviousResults results: inout ListResults) {
        
        results.totalPages = data.totalPages
        results.items.append(contentsOf: data.items)
        results.detailItems.append(contentsOf: data.detailItems)
    }
    
    private func clean(results: inout ListResults) {
        results.items = []
        results.detailItems = []
        results.currentPage = 1
        results.totalPages = 0
        results.param = nil
    }
    
    private func shouldLoadMoreResults(currentIndexPath indexPath: IndexPath,
                                       items: [ConfigurableItem],
                                       currentPage: Int,
                                       totalPages: Int) -> Bool {
        
        return !items.isEmpty &&
            indexPath.row == items.count - Constants.Loader.newItemsThreshold &&
            currentPage < totalPages
    }
}

// MARK: Public Methods
extension ListViewModel {
    
    func loadData() {
        
        bindings?.onTitleLoaded(Constants.Localization.title.localized)
        loadCharaters()
    }
    
    func searchForCharacter(withName name: String) {
        
        clean(results: &filteredResults)
        
        isFiltering = true
        filteredResults.currentPage = 1
        filteredResults.param = name
        
        loadCharaters(name: name)
    }
    
    func resetFilterStatus() {
        
        guard isFiltering else { return }
        
        isFiltering = false
        
        clean(results: &filteredResults)
        
        bindings?.onDataLoaded()
    }
    
    func numberOfSections() -> Int {
        return Constants.Section.numberOfSections
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        
        //Let's use just a single section for now
        return isFiltering ? filteredResults.items.count : results.items.count
    }
    
    func configuratorForItem(at indexPath: IndexPath) -> CellConfigurator? {
        return isFiltering ? filteredResults.items[indexPath.row].configurator : results.items[indexPath.row].configurator
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        
        let items = isFiltering ? filteredResults.items : results.items
        let page = isFiltering ? filteredResults.currentPage : results.currentPage
        let totalPages = isFiltering ? filteredResults.totalPages : results.totalPages
        
        guard shouldLoadMoreResults(currentIndexPath: indexPath,
                                    items: items,
                                    currentPage: page,
                                    totalPages: totalPages) else { return }
        
        if isFiltering {
            
            filteredResults.currentPage += 1
            loadCharaters(page: filteredResults.currentPage, name: filteredResults.param)
            
        } else {
            
            results.currentPage += 1
            loadCharaters(page: results.currentPage)
        }
        
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        
        let data = isFiltering ? filteredResults.detailItems[indexPath.row] : results.detailItems[indexPath.row]
        
        dependencies.coordinator?.openDetail(withData: data)
    }
}
