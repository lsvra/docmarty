//
//  GenericCollectionViewLayout.swift
//  docmarty
//
//  Created by Luís Vieira on 04/04/2020.
//  Copyright © 2020 lsvra. All rights reserved.
//

import UIKit

final class GenericCollectionViewLayout: UICollectionViewLayout {
    
    // MARK: Properties
    private var sidePadding: CGFloat = 8.0
    private var topSpacing: CGFloat = 8.0
    private var bottomSpacing: CGFloat = 8.0
    private var margin: CGFloat = 16.0
    
    private let cellHeight: CGFloat = 300.0
    
    // For now we'll use just a single section
    private let section: Int = 0
    
    // The content height for the UICollectionView
    private var contentHeight: CGFloat = 0.0
    
    // The array of attributes for each one of the UI elements
    private var cache = [UICollectionViewLayoutAttributes]()
    
    // The offsets used for positioning one element after another, both horizontally and vertically
    private var xOffsets = [CGFloat]()
    private var yOffsets = [CGFloat]()
    
    // The current column being used
    private var currentColumn = 0
    
    // The total number of columns
    private var numberOfColumns: Int {
        return UIDevice.current.userInterfaceIdiom == .phone ? 1 : 2
    }
    
    // The available width for drawing the cells
    private var availableWidth: CGFloat {
        guard let collectionView = collectionView else { return .zero }
        
        let totalMargin = margin * 2
        let totalPadding = sidePadding * CGFloat(numberOfColumns - 1)
        return collectionView.bounds.width - totalMargin - totalPadding
    }
    
    // The available width for each column
    private var columnWidth: CGFloat {
        return availableWidth / CGFloat(numberOfColumns)
    }
    
    // The lowest point where there are things drawn (eg. the last element drawn)
    private var maxY: CGFloat {
        return cache.map({ $0.frame.maxY }).sorted().last ?? 0
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: availableWidth, height: contentHeight)
    }
    
    // MARK: Lifecycle
    override func invalidateLayout() {
        contentHeight = 0.0
        currentColumn = 0
        
        xOffsets.removeAll()
        yOffsets.removeAll()
        cache.removeAll()
        super.invalidateLayout()
    }
    
    override func prepare() {
        
        // Check if the cache is empty
        guard
            let collectionView = collectionView,
            cache.isEmpty
            else { return }
        
        // Setting the xOffset array
        for column in 0..<numberOfColumns {
            xOffsets.append(margin + CGFloat(column) * (columnWidth + sidePadding))
        }
        
        // Setting the yOffset array
        yOffsets = [CGFloat](repeating: maxY + topSpacing, count: numberOfColumns)
        
        //Iterate through each cell setting up the view for it
        for row in 0..<collectionView.numberOfItems(inSection: section) {
            setupAttributes(forRow: row)
        }
    }
    
    // Selects only the visible attributes by intersecting their frame with the provided one
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    // Selects the cell attribute for a given IndexPath
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache.first(where: { $0.indexPath.section == indexPath.section && $0.indexPath.row == indexPath.row })
    }
    
    // MARK: Methods
    private func setupAttributes(forRow row: Int) {
        
        // Create the frame for the cell
        let frame = createFrame(withHeight: cellHeight + topSpacing,
                                andWidth: columnWidth)
        
        let indexPath = IndexPath(row: row, section: section)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frame.insetBy(dx: 0, dy: topSpacing/2)
        
        // Insert the attribute into the array
        cache.append(attributes)
        
        // Update the content height with the lowest point of the UICollectionView, plus a given spacing
        contentHeight = max(contentHeight, attributes.frame.maxY) + bottomSpacing
        
        selectNextColumn()
    }
    
    private func createFrame(withHeight height: CGFloat,
                             andWidth width: CGFloat) -> CGRect {
        
        let frame = CGRect(x: xOffsets[currentColumn],
                           y: yOffsets[currentColumn],
                           width: width,
                           height: height)
        
        yOffsets[currentColumn] += height
        
        return frame
    }
    
    private func selectNextColumn() {
        
        currentColumn += 1
        if currentColumn == numberOfColumns {
            currentColumn = 0
        }
    }
}
