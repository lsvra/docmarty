//
//  AppCoordinator.swift
//  docmarty
//
//  Created by Luís Vieira on 04/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    
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
    
    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        openList()
    }
}

// MARK: Navigation
extension AppCoordinator {
    
    private func openList(){
        let listCoordinator = ListCoordinator(navigation: rootViewController)
        children.append(listCoordinator)
        listCoordinator.start()
    }
}
