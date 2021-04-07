//
//  ColorAndSizeLayout.swift
//  Keda

//  Created by Matthew Mukherjee on 03/03/2021.
//

import UIKit

class ColorAndSizeLayout: CustomLayout {
    
    private var numberOfColumns: Int = 4
    private var numberOfSections: Int = 2
    
    override func calculateCellFrame() {
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        let collectionViewWidth = collectionView.frame.size.width
        contentSize.width = collectionViewWidth
        
        let columnWidth: CGFloat = 35.0// = (collectionViewWidth - cellPadding*3 - contentPadding.horizontal*2)/4
        let columnHeight: CGFloat = 35.0
        var xOffset = contentPadding.horizontal
        var yOffset = contentPadding.vertical
        
        //Section 0
        let sectionsCount = collectionView.numberOfSections
        for section in 0..<sectionsCount {
            let itemsCount = collectionView.numberOfItems(inSection: section)
            for item in 0..<itemsCount {
                let indexPath = IndexPath(item: item, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let item = indexPath.item
                
                let other = CGFloat(item % numberOfColumns) * (cellPadding + columnWidth) + contentPadding.horizontal
                xOffset = other
                let frame = CGRect(x: xOffset, y: yOffset, width: columnWidth, height: columnHeight)
                attributes.frame = frame
                
                if item % numberOfColumns == 3 {
                    xOffset = contentPadding.horizontal
                    yOffset += (columnHeight + cellPadding)
                }
                
                cache.append(attributes)
                contentSize.height = yOffset + contentPadding.vertical
                collectionView.frame.size.height = contentSize.height + 50.0
            }
        }
    }
}
