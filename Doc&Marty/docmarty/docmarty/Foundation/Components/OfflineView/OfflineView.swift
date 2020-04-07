//
//  OfflineView.swift
//  docmarty
//
//  Created by Luís Vieira on 07/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import UIKit

final class OfflineView: UIView {
    
    // MARK: Outlets
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
        setupView()
    }
    
    // MARK: Methods
    private func setupView() {
        
        backgroundColor = .backgroundPrimary
        
        imageView.image = .offlineIcon
        imageView.contentMode = .center
    }
}

