//
//  ListCell.swift
//  docmarty
//
//  Created by Luís Vieira on 04/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import UIKit

final class ListCell: UICollectionViewCell {
    
    // MARK: Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: Properties
    private enum Constants {
        enum Layout {
            static var cornerRadius: CGFloat = 8.0
            static var fontSize: CGFloat = 26.0
        }
        
        enum Animation {
            static var fadeInTime: Double = 0.3
        }
    }
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        imageView.image = nil
        imageView.kf.cancelDownloadTask()
    }
}

// MARK: Setup
private extension ListCell {
    
    func setupCell() {
        
        let gradient = CAGradientLayer()
        gradient.frame = contentView.frame
        gradient.colors = [UIColor.clear.cgColor,
                           UIColor.clear.cgColor,
                           UIColor.black.withAlphaComponent(0.2).cgColor,
                           UIColor.black.withAlphaComponent(0.4).cgColor]
        
        contentView.layer.insertSublayer(gradient, at: 1)
        
        contentView.layer.cornerRadius = Constants.Layout.cornerRadius
        contentView.layer.masksToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: Constants.Layout.fontSize)
        titleLabel.textColor = .labelSecondary
        
        imageView.contentMode = .scaleAspectFill
    }
    
    private func updateLayerBounds() {
        
        let gradient = contentView.layer.sublayers?.first(where: {$0 is CAGradientLayer })
        gradient?.frame = contentView.frame
    }
}

// MARK: - NibCreator
extension ListCell: NibCreator {}

// MARK: - ConfigurableCell
extension ListCell: ConfigurableCell {
    
    func configure(viewModel: ListCellViewModel) {
        
        titleLabel.text = viewModel.title
        
        imageView.kf.setImage(with: viewModel.imageURL,
                              placeholder: UIImage.placeholder,
                              options: [.transition(.fade(Constants.Animation.fadeInTime))])
        
        layoutIfNeeded()
        updateLayerBounds()
    }
}
