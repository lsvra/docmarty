//
//  CellConfigurator.swift
//  docmarty
//
//  Created by Luís Vieira on 05/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import UIKit

protocol CellConfigurator {
    func cell(in collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}

struct Configurator<T: ConfigurableCell>: CellConfigurator where T: UICollectionViewCell {
    
    let item: T.ViewModel
    
    init(item: T.ViewModel) {
        self.item = item
    }
    
    func cell(in collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: T = collectionView.dequeue(T.self, atIndexPath: indexPath)
        cell.configure(viewModel: item)
        return cell
    }
}
