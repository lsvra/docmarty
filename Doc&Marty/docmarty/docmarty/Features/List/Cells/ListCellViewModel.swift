//
//  ListCellViewModel.swift
//  docmarty
//
//  Created by Luís Vieira on 04/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import UIKit

final class ListCellViewModel: ConfigurableItem {

    let imageUrl: String
    let title: String
    
    init(imageUrl: String, title: String) {
        self.imageUrl = imageUrl
        self.title = title
    }
    
    lazy var configurator: CellConfigurator = {
        return Configurator<ListCell>(item: self)
    }()
}
