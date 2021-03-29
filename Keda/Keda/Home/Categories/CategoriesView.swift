//
//  CategoriesView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol CategoriesViewDelegate: class {
    func categoriesDidTap(_ corverImgName: String, title: String, categories: [Product])
}

class CategoriesView: UIView {
    
    //MARK: - Properties
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let infiniteLayout = InfiniteLayout()
    weak var delegate: CategoriesViewDelegate?
    
    var homeVC: HomeVC!
    
    lazy var kCategories: [Category] = {
        return Category.fetchDataC()
    }()
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupCategories()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impleshortsted")
    }
}

//MARK: - Configures

extension CategoriesView {
    
    func setupCategories() {
        collectionView.configureCVAddSub(ds: self, dl: self, view: self)
        collectionView.register(CategoriesCVCell.self, forCellWithReuseIdentifier: CategoriesCVCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        
        collectionView.collectionViewLayout = infiniteLayout
        infiniteLayout.scrollDirection = .horizontal
        infiniteLayout.isScale = false
        infiniteLayout.minimumLineSpacing = 10.0
        infiniteLayout.minimumInteritemSpacing = 10.0
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

//MARK: - UICollectionViewDataSource

extension CategoriesView: UICollectionViewDataSource {
    
    private var isMultiplier: Int {
        return InfiniteDataSource.multiplier(estimatedItemSize: collectionView.bounds.size, enabled: infiniteLayout.isEnabled)
    }
    
    private func kIndexPath(_ indexPath: IndexPath) -> IndexPath {
        return InfiniteDataSource.indexPath(from: indexPath, numberOfSections: 1, numberOfItems: kCategories.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InfiniteDataSource.numberOfItemsInSection(numberOfItemsInSection: kCategories.count,
                                                         numberOfSection: section,
                                                         multiplier: isMultiplier)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCVCell.identifier, for: indexPath) as! CategoriesCVCell
        cell.category = kCategories[kIndexPath(indexPath).item]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension CategoriesView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoriesCVCell
        let category = kCategories[kIndexPath(indexPath).item]
        touchAnim(cell, frValue: 0.8) {
            let products: [Product]
            switch category.name {
            case categories[0]: products = Product.hoodies(self.homeVC.allProducts); break
            case categories[1]: products = Product.belts(self.homeVC.allProducts); break
            case categories[2]: products = Product.shoes(self.homeVC.allProducts); break
            case categories[3]: products = Product.watches(self.homeVC.allProducts); break
            case categories[4]: products = Product.bags(self.homeVC.allProducts); break
            case categories[5]: products = Product.jackets(self.homeVC.allProducts); break
            case categories[6]: products = Product.shirts(self.homeVC.allProducts); break
            case categories[7]: products = Product.shorts(self.homeVC.allProducts); break
            case categories[8]: products = Product.pants(self.homeVC.allProducts); break
            case categories[9]: products = Product.slides(self.homeVC.allProducts); break
            case categories[10]: products = Product.lounge(self.homeVC.allProducts); break
            default: products = Product.collectables(self.homeVC.allProducts); break
            }
            
            self.delegate?.categoriesDidTap(category.imageName, title: category.name, categories: products)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CategoriesView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        return CGSize(width: height*2.0 + 30.0, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 10.0)
    }
}

//MARK: - UIScrollView

extension CategoriesView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        infiniteLayout.loopCollectionViewIfNeeded()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        infiniteLayout.centerCollectionView(withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
