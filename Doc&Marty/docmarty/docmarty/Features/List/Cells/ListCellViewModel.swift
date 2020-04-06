//
//  ListCellViewModel.swift
//  docmarty
//
//  Created by Luís Vieira on 04/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import UIKit
import Kingfisher

final class ListCellViewModel: ConfigurableItem{

    let title: String
    let imageURL: URL?
    
    init(title: String, imageURL: URL?) {
        self.title = title
        self.imageURL = imageURL
    }
    
    lazy var configurator: CellConfigurator = {
        return Configurator<ListCell>(item: self)
    }()
}

// MARK: - Prefetchable
extension ListCellViewModel: Prefetchable {
    
    var urlsToPrefetch: [URL?] {
        return [imageURL]
    }
}
