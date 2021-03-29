//
//  SellersView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol SellersViewDelegate: class {
    func sellerDidTap(_ seller: Product)
}

class SellersView: UIView {
    
    //MARK: - Properties
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let bestSellerLayout = BestSellerLayout()
    weak var delegate: SellersViewDelegate?
    
    var homeVC: HomeVC!
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupSellers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension SellersView {
    
    func setupSellers() {
        collectionView.configureCVAddSub(ds: self, dl: self, view: self)
        collectionView.register(SellersCVCell.self, forCellWithReuseIdentifier: SellersCVCell.identifier)
        collectionView.isScrollEnabled = false
        
        collectionView.collectionViewLayout = bestSellerLayout
        bestSellerLayout.contentPadding = SpacingMode(horizontal: 2.0, vertical: 2.0)
        bestSellerLayout.cellPadding = 2.0
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

//MARK: - UICollectionViewDataSource

extension SellersView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if homeVC.sellers.count >= 7 { return 7 }
        return homeVC.sellers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SellersCVCell.identifier, for: indexPath) as! SellersCVCell
        cell.seller = homeVC.sellers[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension SellersView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SellersCVCell
        let seller = homeVC.sellers[indexPath.item]
        touchAnim(cell, frValue: 0.8) {
            self.delegate?.sellerDidTap(seller)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SellersView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = collectionView.contentInset
        let sizeItem = (collectionView.frame.size.width - (inset.left + inset.right + 10.0))/2.0
        
        return CGSize(width: sizeItem, height: sizeItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 30.0)
    }
}
