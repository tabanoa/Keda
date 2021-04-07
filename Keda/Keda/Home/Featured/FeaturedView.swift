//
//  FeaturedView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol FeaturedViewDelegate: class {
    func featuredDidTap(_ featured: Product)
}

class FeaturedView: UIView {
    
    //MARK: - Properties
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let featuredLayout = FeaturedLayout()
    weak var delegate: FeaturedViewDelegate?
    
    var homeVC: HomeVC!
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupFeatured()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension FeaturedView {
    
    func setupFeatured() {
        collectionView.configureCVAddSub(ds: self, dl: self, view: self)
        collectionView.register(FeaturedCVCell.self, forCellWithReuseIdentifier: FeaturedCVCell.identifier)
        collectionView.isScrollEnabled = false
        
        collectionView.collectionViewLayout = featuredLayout
        featuredLayout.contentPadding = SpacingMode(horizontal: 2.0, vertical: 2.0)
        featuredLayout.cellPadding = 2.0
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

//MARK: - UICollectionViewDataSource

extension FeaturedView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if homeVC.featured.count >= 6 { return 6 }
        return homeVC.featured.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCVCell.identifier, for: indexPath) as! FeaturedCVCell
        cell.featured = homeVC.featured[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension FeaturedView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FeaturedCVCell
        let featured = homeVC.featured[indexPath.item]
        touchAnim(cell, frValue: 0.8) {
            self.delegate?.featuredDidTap(featured)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FeaturedView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = collectionView.contentInset
        let sizeItem = (collectionView.frame.size.width - (inset.left + inset.right + 10.0))/2.0
        
        return CGSize(width: sizeItem, height: sizeItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 30.0)
    }
}
