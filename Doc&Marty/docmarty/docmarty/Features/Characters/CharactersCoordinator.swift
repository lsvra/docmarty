//
//  CharactersCoordinator.swift
//  docmarty
//
//  Created by Luís Vieira on 04/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import UIKit

protocol CharactersCoordinatorDelegate: class {
     func openDetail(withData data: DetailItemData)
}

final class CharactersCoordinator {
    
    // MARK: Properties
    private let navigation: UINavigationController
    
    lazy var listViewController: UIViewController = {
        let client = APIClient(withSession: .shared)
        let decoder = JSONDecoder()
        
        let service = ListService(client: client, decoder: decoder)
        let adapter = ListRequestAdapter(service: service)
        
        let reachability = try? Reachability()
        
        let dependencies = ListViewModel.Dependencies(adapter: adapter,
                                                      reachability: reachability,
                                                      coordinator: self)
        
        let viewModel = ListViewModel(dependencies: dependencies)
        let viewController = ListViewController(viewModel: viewModel)
        
        return viewController
    }()
    
    // MARK: Lifecycle
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    // MARK: Methods
    private func detailViewController(withData data: DetailItemData) -> UIViewController{
        let client = APIClient(withSession: .shared)
        let decoder = JSONDecoder()
        
        let service = DetailService(client: client, decoder: decoder)
        let adapter = DetailRequestAdapter(service: service)
        
        let reachability = try? Reachability()
        
        let dependencies = DetailViewModel.Dependencies(data: data,
                                                        adapter: adapter,
                                                        reachability: reachability,
                                                        coordinator: self)
        
        let viewModel = DetailViewModel(dependencies: dependencies)
        let viewController = DetailViewController(viewModel: viewModel)
        
        return viewController
    }
}

// MARK: Coordinator
extension CharactersCoordinator: Coordinator {
    
    func start() {
        navigation.pushViewController(listViewController, animated: true)
    }
}

// MARK: CharactersCoordinatorDelegate
extension CharactersCoordinator: CharactersCoordinatorDelegate {
   
    func openDetail(withData data: DetailItemData) {
        
        let viewController = detailViewController(withData: data)
        navigation.pushViewController(viewController, animated: true)
    }
}
