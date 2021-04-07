//
//  FeaturedLayout.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class FeaturedLayout: CustomLayout {
    
    fileprivate var numberOfSections = 2
    fileprivate var numberOfRows = 2
    fileprivate var numberOfColumns = 3
    
    public override func calculateCellFrame() {
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        let collectionViewWidth = collectionView.frame.size.width
        contentSize.width = collectionViewWidth
        
        let columnWidth = (collectionViewWidth - contentPadding.horizontal*2 - cellPadding*2)/CGFloat(numberOfColumns)
        var xOffset = contentPadding.horizontal
        var yOffset = contentPadding.vertical
        var kSection = 0
        
        let sectionsCount = collectionView.numberOfSections
        for section in 0..<sectionsCount {
            let itemsCount = collectionView.numberOfItems(inSection: section)
            for item in 0..<itemsCount {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let item = indexPath.item
                
                if kSection % numberOfSections == 0 {
                    calculateLeftFrame(attributes,
                                       &xOffset,
                                       &yOffset,
                                       &kSection,
                                       columnWidth,
                                       item,
                                       itemsCount)
                    
                } else if kSection % numberOfSections == 1 {
                    calculateDefaultFrame(attributes,
                                          &xOffset,
                                          &yOffset,
                                          columnWidth,
                                          item,
                                          itemsCount)
                }
                
                cache.append(attributes)
            }
        }
        
        contentSize.height = yOffset + contentPadding.vertical
    }
    
    private func calculateDefaultFrame(_ attributes: UICollectionViewLayoutAttributes,
                                       _ xOffset: inout CGFloat,
                                       _ yOffset: inout CGFloat,
                                       _ columnWidth: CGFloat,
                                       _ item: Int,
                                       _ itemsCount: Int) {
        xOffset = CGFloat(item % numberOfColumns) * (columnWidth + cellPadding) + contentPadding.horizontal
        let frame = CGRect(x: xOffset, y: yOffset, width: columnWidth, height: columnWidth)
        attributes.frame = frame
        yOffset = (item+1 == itemsCount && item % numberOfColumns != 2) ? yOffset + columnWidth : yOffset
    }
    
    private func calculateLeftFrame(_ attributes: UICollectionViewLayoutAttributes,
                                    _ xOffset: inout CGFloat,
                                    _ yOffset: inout CGFloat,
                                    _ kSection: inout Int,
                                    _ columnWidth: CGFloat,
                                    _ item: Int,
                                    _ itemsCount: Int) {
        if item % numberOfColumns == 0 {
            let width = columnWidth*2 + cellPadding
            let largeFrame = CGRect(x: xOffset,
                                    y: yOffset,
                                    width: width,
                                    height: width)
            let smallFrame = CGRect(x: xOffset,
                                    y: yOffset,
                                    width: columnWidth,
                                    height: columnWidth)
            attributes.frame = (item+1 == itemsCount || item+1 == itemsCount-1) ? smallFrame : largeFrame
            yOffset = (item+1 == itemsCount) ? yOffset + columnWidth : yOffset
            xOffset += (cellPadding + columnWidth)*2.0
            
        } else if item % numberOfColumns == 1 {
            let rightFrame = CGRect(x: xOffset,
                                    y: yOffset,
                                    width: columnWidth,
                                    height: columnWidth)
            let centralFrame = CGRect(x: xOffset - columnWidth - cellPadding,
                                      y: yOffset,
                                      width: columnWidth,
                                      height: columnWidth)
            attributes.frame = (item+1 == itemsCount) ? centralFrame : rightFrame
            yOffset += (columnWidth + cellPadding)
            
        } else if item % numberOfColumns == 2 {
            let frame = CGRect(x: xOffset,
                               y: yOffset,
                               width: columnWidth,
                               height: columnWidth)
            attributes.frame = frame
            yOffset += (columnWidth + cellPadding)
            kSection += 1
        }
    }
}
