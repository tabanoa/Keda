//
//  TurnPageLayout.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class TurnPageLayout: UICollectionViewFlowLayout {
    
    fileprivate var contentSize: CGSize = .zero
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        let size = collectionView.bounds.size
        contentSize.width = size.width
        contentSize.height = size.height
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect),
            let collectionView = collectionView else { return [] }
        
        for attributes in layoutAttributes {
            let cvWidth = collectionView.bounds.size.width
            let center = cvWidth/2.0
            let xOffset = collectionView.contentOffset.x
            let normalizedCenter = attributes.center.x - xOffset
            let distanceCenter = min(center - normalizedCenter, cvWidth)
            let ratio = (cvWidth - abs(distanceCenter))/cvWidth
            
            let alpha = ratio * (1 - 0.5) + 0.5
            let scale = ratio * (1 - 0.5) + 0.5
            attributes.alpha = alpha
            
            let angle = distanceCenter/cvWidth
            let identity = CATransform3DIdentity
            var transform = CATransform3DScale(identity, scale, scale, 1.0)
            transform.m34 = 1/400
            transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0)
            attributes.transform3D = transform
        }
        
        return layoutAttributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }
        let center = collectionView.bounds.size.width/2.0
        let offset = proposedContentOffset.x + center
        let layoutAttributes = layoutAttributesForElements(in: collectionView.bounds)
        let attributes = layoutAttributes!
            .sorted(by: { abs($0.center.x - offset) < abs($1.center.x - offset) })
            .first ?? UICollectionViewLayoutAttributes()
        
        return CGPoint(x: attributes.center.x - center, y: 0.0)
    }
}
