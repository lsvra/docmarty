//
//  ListViewController.swift
//  docmarty
//
//  Created by Luís Vieira on 04/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: Properties
    var viewModel: ListViewModel
    
    // MARK: Lifecycle
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil,
                   bundle: Bundle(for: ListViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setUpCollectionView()
        setupBindings()
        
        viewModel.loadData()
    }
    
    // MARK: Methods
    
    private func setupView() {
        view.backgroundColor = .backgroundPrimary
    }
    
    private func setUpCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = GenericCollectionViewLayout()
        
        collectionView.register(cell: ListCell.self)
    }

    private func setupBindings() {
        
        let onDataLoaded = { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
        
        viewModel.bindings = ListViewModel.Bindings(onDataLoaded: onDataLoaded)
    }
}
