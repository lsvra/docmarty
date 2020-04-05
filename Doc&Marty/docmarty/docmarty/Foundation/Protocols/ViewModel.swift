//
//  ViewModel.swift
//  docmarty
//
//  Created by Luís Vieira on 04/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

protocol ViewModel {
    associatedtype Dependencies
    associatedtype Bindings
    
    var dependencies: Dependencies { get set }
    var bindings: Bindings? { get set }
    
    init(dependencies: Dependencies)
}
