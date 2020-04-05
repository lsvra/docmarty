//
//  ListCoordinator.swift
//  docmarty
//
//  Created by Luís Vieira on 04/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import UIKit

protocol ListCoordinatorDelegate: class {
    //TBD
}

final class ListCoordinator: Coordinator {
    
    private let navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        
        let dependencies = ListViewModel.Dependencies()
        let viewModel = ListViewModel(dependencies: dependencies)
        let viewController = ListViewController(viewModel: viewModel)
        
        navigation.pushViewController(viewController, animated: true)
    }
}
