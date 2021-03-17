//
//  ShopLayout.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ShopLayout: CustomLayout {
    
    fileprivate var numberOfSections = 2
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
//                let item = indexPath.item
                
                if kSection % numberOfSections == 0 {
                    calculateLeftFrame(attributes,
                                       &xOffset,
                                       &yOffset,
                                       &kSection,
                                       columnWidth,
                                       collectionView,
                                       section,
                                       indexPath)
                    
                } else if kSection % numberOfSections == 1 {
                    calculateRightFrame(attributes,
                                        &xOffset,
                                        &yOffset,
                                        &kSection,
                                        columnWidth,
                                        collectionView,
                                        section,
                                        indexPath)
                }
                
                cache.append(attributes)
            }
        }
        
        contentSize.height = yOffset + contentPadding.vertical + columnWidth
    }
    
    private func calculateLeftFrame(_ attributes: UICollectionViewLayoutAttributes,
                                    _ xOffset: inout CGFloat,
                                    _ yOffset: inout CGFloat,
                                    _ kSection: inout Int,
                                    _ columnWidth: CGFloat,
                                    _ cv: UICollectionView,
                                    _ section: Int,
                                    _ indexPath: IndexPath) {
        let itemsCount = cv.numberOfItems(inSection: section)
        let item = indexPath.item
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
            yOffset = (item+1 == itemsCount) ? yOffset + columnWidth : yOffset
            
        } else if item % numberOfColumns == 2 {
            yOffset += (columnWidth + cellPadding)
            let frame = CGRect(x: xOffset,
                               y: yOffset,
                               width: columnWidth,
                               height: columnWidth)
            attributes.frame = frame
            yOffset = (item+1 == itemsCount) ? yOffset + columnWidth : yOffset
            xOffset = contentPadding.horizontal
            kSection += 1
        }
    }
    
    private func calculateRightFrame(_ attributes: UICollectionViewLayoutAttributes,
                                     _ xOffset: inout CGFloat,
                                     _ yOffset: inout CGFloat,
                                     _ kSection: inout Int,
                                     _ columnWidth: CGFloat,
                                     _ cv: UICollectionView,
                                     _ section: Int,
                                     _ indexPath: IndexPath) {
        let itemsCount = cv.numberOfItems(inSection: section)
        let item = indexPath.item
        if item % numberOfColumns == 0 {
            yOffset += (cellPadding + columnWidth)
            let frame = CGRect(x: xOffset,
                               y: yOffset,
                               width: columnWidth,
                               height: columnWidth)
            attributes.frame = frame
            yOffset = (item+1 == itemsCount) ? yOffset + columnWidth : yOffset
            
        } else if item % numberOfColumns == 1 {
            let bottomFrame = CGRect(x: xOffset,
                                     y: yOffset + columnWidth + cellPadding,
                                     width: columnWidth,
                                     height: columnWidth)
            let rightFrame = CGRect(x: xOffset + cellPadding + columnWidth,
                                    y: yOffset,
                                    width: columnWidth,
                                    height: columnWidth)
            attributes.frame = (item+1 == itemsCount) ? rightFrame : bottomFrame
            yOffset = (item+1 == itemsCount) ? yOffset + columnWidth : yOffset
            xOffset += (columnWidth + cellPadding)
            
        } else if item % numberOfColumns == 2 {
            let width = columnWidth*2 + cellPadding
            let frame = CGRect(x: xOffset,
                               y: yOffset,
                               width: width,
                               height: width)
            attributes.frame = frame
            yOffset += (width + cellPadding)
            xOffset = contentPadding.horizontal
            kSection += 1
        }
    }
}
