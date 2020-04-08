//
//  AppCoordinator.swift
//  docmarty
//
//  Created by Luís Vieira on 04/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import UIKit

final class AppCoordinator {
    
    // MARK: Properties
    private let window: UIWindow
    private let rootViewController: UINavigationController
    private var children: [Coordinator]
    
    // MARK: Lifecycle
    init(window: UIWindow) {
        
        self.window = window
        self.rootViewController = UINavigationController()
        self.children = []
    }
}

// MARK: Coordinator
extension AppCoordinator: Coordinator {
    
    func start() {
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        openList()
    }
    
    private func openList() {
        
        let charactersCoordinator = CharactersCoordinator(navigation: rootViewController)
        children.append(charactersCoordinator)
        charactersCoordinator.start()
    }
}
