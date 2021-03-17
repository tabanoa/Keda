//
//  ScrollCenterLayout.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ScrollCenterLayout: UICollectionViewFlowLayout {
    
    private var previousOffset: CGFloat = 0.0
    private var currentPage: Int = 0
    
    override func prepare() {
        super.prepare()
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView,
            let itemsCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        if previousOffset > collectionView.contentOffset.x && velocity.x < 0 {
            currentPage = max(currentPage - 1, 0)
            
        } else if previousOffset < collectionView.contentOffset.x && velocity.x > 0 {
            currentPage = min(currentPage + 1, itemsCount - 1)
        }
        
        let itemEdgeOffset: CGFloat = (collectionView.frame.size.width - itemSize.width - minimumLineSpacing * 2.0) / 2.0
        let updateOffset = (itemSize.width + minimumLineSpacing) * CGFloat(currentPage) - (itemEdgeOffset + minimumLineSpacing)
        previousOffset = updateOffset
        
        return CGPoint(x: updateOffset, y: proposedContentOffset.y)
    }
}
