//
//  ArrivalsView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol ArrivalsViewDelegate: class {
    func arrivalsDidTap(_ arrival: Product)
}

class ArrivalsView: UIView {
    
    //MARK: - Properties
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let arrivalsLayout = ArrivalsLayout()
    weak var delegate: ArrivalsViewDelegate?
    
    var homeVC: HomeVC!
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupArrivals()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension ArrivalsView {
    
    func setupArrivals() {
        collectionView.configureCVAddSub(ds: self, dl: self, view: self)
        collectionView.register(ArrivalsCVCell.self, forCellWithReuseIdentifier: ArrivalsCVCell.identifier)
        collectionView.isScrollEnabled = false
        
        collectionView.collectionViewLayout = arrivalsLayout
        arrivalsLayout.contentPadding = SpacingMode(horizontal: 2.0, vertical: 2.0)
        arrivalsLayout.cellPadding = 2.0
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

//MARK: - UICollectionViewDataSource

extension ArrivalsView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if homeVC.arrivals.count >= 6 { return 6 }
        return homeVC.arrivals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArrivalsCVCell.identifier, for: indexPath) as! ArrivalsCVCell
        cell.arrival = homeVC.arrivals[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ArrivalsView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ArrivalsCVCell
        let arrival = homeVC.arrivals[indexPath.item]
        touchAnim(cell, frValue: 0.8) {
            self.delegate?.arrivalsDidTap(arrival)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ArrivalsView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = collectionView.contentInset
        let sizeItem = (collectionView.frame.size.width - (inset.left + inset.right + 10.0))/2.0
        return CGSize(width: sizeItem, height: sizeItem)
    }
}
