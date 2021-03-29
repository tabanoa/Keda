//
//  RecentlyViewedTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol RecentlyViewedTVCellDelegate: class {
    func handlePresent(_ pr: Product)
}

class RecentlyViewedTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "RecentlyViewedTVCell"
    weak var delegate: RecentlyViewedTVCellDelegate?
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    //MARK: - Intialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension RecentlyViewedTVCell {
    
    func configureCell() {
        collectionView.configureCVAddSub(ds: self, dl: self, view: self)
        collectionView.register(RecentlyViewedCVCell.self, forCellWithReuseIdentifier: RecentlyViewedCVCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        setupDarkMode()
    }
}

//MARK: - UICollectionViewDataSource

extension RecentlyViewedTVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Product.recentlyViewed.count <= 4 { return Product.recentlyViewed.count }
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyViewedCVCell.identifier, for: indexPath) as! RecentlyViewedCVCell
        cell.product = Product.recentlyViewed[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension RecentlyViewedTVCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RecentlyViewedCVCell
        let pr = Product.recentlyViewed[indexPath.row]
        touchAnim(cell, frValue: 0.8) {
            self.delegate?.handlePresent(pr)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension RecentlyViewedTVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.height-4
        return CGSize(width: width, height: width)
    }
}

//MARK: - DarkMode

extension RecentlyViewedTVCell {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    private func setupDarkMode() {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupDMView()
            case .dark: setupDMView(true)
            default: break
            }
        } else {
            setupDMView()
        }
    }
    
    private func setupDMView(_ isDarkMode: Bool = false) {
        collectionView.backgroundColor = isDarkMode ? darkColor : .white
    }
}
