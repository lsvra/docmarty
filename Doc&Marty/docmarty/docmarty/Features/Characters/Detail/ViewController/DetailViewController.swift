//
//  DetailViewController.swift
//  docmarty
//
//  Created by Luís Vieira on 06/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var numberOfEpisodesLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    
    
    // MARK: Properties
    var viewModel: DetailViewModel
    
    private enum Constants {
        enum Layout {
            static var cornerRadius: CGFloat = 8.0
            static var fontSize: CGFloat = 24.0
        }
        
        enum Animation {
            static var fadeInTime: Double = 0.3
        }
    }
    
    // MARK: Lifecycle
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil,
                   bundle: Bundle(for: DetailViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBindings()
        
        viewModel.loadData()
    }
    
    // MARK: Methods
    private func setupView() {
        view.backgroundColor = .backgroundPrimary
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.labelPrimary]
        navigationController?.navigationBar.barTintColor = .backgroundPrimary
        navigationController?.navigationBar.tintColor = .labelPrimary
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.Layout.cornerRadius
        imageView.layer.masksToBounds = true
        
        nameLabel.font = .boldSystemFont(ofSize: Constants.Layout.fontSize)
        genderLabel.font = .boldSystemFont(ofSize: Constants.Layout.fontSize)
        numberOfEpisodesLabel.font = .boldSystemFont(ofSize: Constants.Layout.fontSize)
        locationLabel.font = .boldSystemFont(ofSize: Constants.Layout.fontSize)
        
        locationLabel.isHidden = true
    }
    
    private func setupBindings() {
        
        let onTitleLoaded = { [weak self] (title: String) in
            guard let self = self else { return }
            self.navigationItem.title = title
        }
        
        let onDataLoaded = { [weak self] (details: Details) in
            guard let self = self else { return }
            
            self.imageView.kf.setImage(with: details.imageURL,
                                       placeholder: UIImage.placeholder,
                                       options: [.transition(.fade(Constants.Animation.fadeInTime))])
            
            self.nameLabel.text = details.name
            self.genderLabel.text = details.gender
            self.numberOfEpisodesLabel.text = details.numberOfEpisodes
            
            if let location = details.location {
                self.locationLabel.text = location
                self.locationLabel.isHidden = false
            }
        }
        
        let onError = { [weak self] (error: ServiceError) in
            guard let self = self else { return }
            self.displayError(title: error.title, message: error.message)
        }
        
        viewModel.bindings = DetailViewModel.Bindings(onTitleLoaded: onTitleLoaded,
                                                      onDataLoaded: onDataLoaded,
                                                      onError: onError)
    }
}
