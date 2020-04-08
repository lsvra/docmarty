//
//  UICollectionView+Extension.swift
//  docmarty
//
//  Created by Luís Vieira on 04/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cell: T.Type) where T: NibCreator {
        register(cell.nib, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }
    
    func dequeue<T: UICollectionViewCell>(_ cell: T.Type, atIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: cell.reuseIdentifier, for: indexPath) as! T
    }
}


