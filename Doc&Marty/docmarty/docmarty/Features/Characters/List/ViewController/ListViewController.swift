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
    
    private lazy var searchController: UISearchController = {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .fillPrimary
        
        return searchController
    }()
    
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
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.labelPrimary]
        navigationController?.navigationBar.barTintColor = .backgroundPrimary
        
        navigationItem.searchController = searchController
    }
    
    private func setUpCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = GenericCollectionViewLayout()
        
        collectionView.register(cell: ListCell.self)
    }
    
    private func setupBindings() {
        
        let onLoading = { [weak self] in
            
            guard let self = self else { return }
            self.toggleLoadingScreen(isLoading: true)
        }
        
        let onTitleLoaded = { [weak self] (title: String) in
            
            guard let self = self else { return }
            self.navigationItem.title = title
        }
        
        let onDataLoaded = { [weak self] in
            
            guard let self = self else { return }
            
            self.collectionView.reloadData()
            self.toggleLoadingScreen(isLoading: false)
        }
        
        let onError = { [weak self] (error: ServiceError) in
            
            guard let self = self else { return }
            self.displayError(title: error.title.localized, message: error.message.localized)
        }
        
        let onNetworkStatusDidChange = { [weak self] (isOnline: Bool) in
            
            guard let self = self else { return }
            self.toggleOfflineScreen(isOnline: isOnline)
        }
        
        viewModel.bindings = ListViewModel.Bindings(onLoading: onLoading,
                                                    onTitleLoaded: onTitleLoaded,
                                                    onDataLoaded: onDataLoaded,
                                                    onError: onError,
                                                    onNetworkStatusDidChange: onNetworkStatusDidChange)
    }
}
