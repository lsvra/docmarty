//
//  Configurable.swift
//  docmarty
//
//  Created by Luís Vieira on 04/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

protocol ConfigurableCell {
    
    associatedtype ViewModel
    func configure(viewModel: ViewModel)
}

protocol ConfigurableItem {
    var configurator: CellConfigurator { get }
}
