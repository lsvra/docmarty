//
//  UIView+Extension.swift
//  docmarty
//
//  Created by Luís Vieira on 07/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import UIKit

extension UIView {
    
    public func loadView() {
        
        let nibName = String(describing: type(of: self))
        
        let objects = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        
        guard let view = objects?.first as? UIView else { return }
        
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }
}
