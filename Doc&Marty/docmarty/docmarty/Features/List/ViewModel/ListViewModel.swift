//
//  ListViewModel.swift
//  docmarty
//
//  Created by Luís Vieira on 04/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import Foundation

final class ListViewModel: ViewModel {
    
    private weak var coordinator: ListCoordinatorDelegate?
    
    // MARK: Properties
    struct Dependencies {
        //TBD
    }
    
    struct Bindings {
        let onDataLoaded: () -> Void
    }
    
    private enum Constants {
        
        enum Section {
            static let numberOfSections = 1
        }
    }

    var dependencies: Dependencies
    var bindings: Bindings?
    
    private var items: [ConfigurableItem]
    
    // MARK: Lifecycle
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
        items = []
    }
}

// MARK: Public Methods
extension ListViewModel {
    
    func loadData() {
        bindings?.onDataLoaded()
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
    
    func didSelectItem(at indexPath: IndexPath) {
        //TBD
    }
}
