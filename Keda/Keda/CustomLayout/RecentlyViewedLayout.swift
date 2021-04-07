//
//  RecentlyViewedLayout.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol RecentlyViewedLayoutDelegate: class {
    func cellSize(_ indexPath: IndexPath) -> CGSize
}

class RecentlyViewedLayout: CustomLayout {
    
    weak var delegate: RecentlyViewedLayoutDelegate?
    
    override func calculateCellFrame() {
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        let collectionViewWidth = collectionView.frame.size.width
        contentSize.width = collectionViewWidth
        
        let leftPadding = contentPadding.horizontal
        let rightPadding = collectionViewWidth - contentPadding.horizontal
        
        var xOffset = contentAlign == .left ? leftPadding : rightPadding
        var yOffset = contentPadding.vertical
        
        let sectionsCount = collectionView.numberOfSections
        for section in 0..<sectionsCount {
            let itemsCount = collectionView.numberOfItems(inSection: section)
            for item in 0..<itemsCount {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame.size = delegate!.cellSize(indexPath)
                
                let cellSize = attributes.frame.size
                
                if contentAlign == .left {
                    if xOffset + cellSize.width + cellPadding > collectionViewWidth {
                        xOffset = contentPadding.horizontal
                        yOffset += (cellSize.height + cellPadding)
                    }
                    
                    attributes.frame.origin.x = xOffset
                    attributes.frame.origin.y = yOffset
                    xOffset += (cellSize.width + cellPadding)
                }
                
                if contentAlign == .right {}
                
                cache.append(attributes)
                contentSize.height = yOffset + cellSize.height + cellPadding
            }
        }
    }
}
