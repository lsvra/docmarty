//
//  ListViewController+DataSource.swift
//  docmarty
//
//  Created by Luís Vieira on 04/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import UIKit

// MARK: UICollectionViewDataSource
extension ListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard
            let configurator = viewModel.configuratorForItem(at: indexPath)
            else { return UICollectionViewCell() }
        
        return configurator.cell(in: collectionView, indexPath: indexPath)
    }
}
