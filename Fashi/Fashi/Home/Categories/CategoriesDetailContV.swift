//
//  CategoriesDetailContV.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol CategoriesDetailContVDelegate: class {
    func handleCVDidTap(_ product: Product)
    func handleScrollDown()
    func handleScrollUp()
}

class CategoriesDetailContV: UIView {
    
    //MARK: - Properties
    weak var delegate: CategoriesDetailContVDelegate?
    private let shape = CAShapeLayer()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var categoriesDetailVC: CategoriesDetailVC!
    var contVTopCons = NSLayoutConstraint()
    
    private var lastContentOffset: CGFloat = 0.0
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension CategoriesDetailContV {
    
    func setupContentView(_ view: UIView, headerV: UIView, refresh: UIRefreshControl, dl: CategoriesDetailContVDelegate) {
        clipsToBounds = true
        view.insertSubview(self, aboveSubview: headerV)
        translatesAutoresizingMaskIntoConstraints = false
        
        let constant = screenWidth*0.6
        contVTopCons = topAnchor.constraint(equalTo: headerV.bottomAnchor, constant: -constant)
        NSLayoutConstraint.activate([
            contVTopCons,
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        let rect = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight-screenWidth+constant)
        let corner: UIRectCorner = [.topLeft, .topRight]
        let radii = CGSize(width: 30.0, height: 30.0)
        shape.path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: radii).cgPath
        shape.strokeColor = UIColor.clear.cgColor
        shape.fillColor = UIColor.white.cgColor
        shape.lineWidth = 1.0
        layer.addSublayer(shape)
        
        setupCV(refresh)
        delegate = dl
    }
    
    func setupCV(_ refresh: UIRefreshControl) {
        //TODO: - CollectionView
        collectionView.configureCVAddSub(ds: self, dl: self, view: self)
        collectionView.refreshControl = refresh
        collectionView.register(CategoriesDetailCVCell.self, forCellWithReuseIdentifier: CategoriesDetailCVCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 15.0, left: 10.0, bottom: 15.0, right: 10.0)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 20.0
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5.0),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5.0),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setupDarkMode(_ isDarkMode: Bool = false) {
        shape.fillColor = isDarkMode ? UIColor.black.cgColor : UIColor.white.cgColor
    }
}

//MARK: - UICollectionViewDataSource

extension CategoriesDetailContV: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categoriesDetailVC.categories.count <= 0 { return categoriesDetailVC.products.count }
        return categoriesDetailVC.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesDetailCVCell.identifier, for: indexPath) as! CategoriesDetailCVCell
        if categoriesDetailVC.categories.count <= 0 {
            cell.category = categoriesDetailVC.products[indexPath.item]
            
        } else {
            cell.category = categoriesDetailVC.categories[indexPath.item]
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension CategoriesDetailContV: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoriesDetailCVCell
        let product: Product
        if categoriesDetailVC.categories.count <= 0 {
            product = categoriesDetailVC.products[indexPath.item]
            
        } else {
            product = categoriesDetailVC.categories[indexPath.item]
        }
        
        touchAnim(cell, frValue: 0.8) {
            self.delegate?.handleCVDidTap(product)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CategoriesDetailContV: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeItem = (collectionView.frame.size.width - 40.0)/2.0
        return CGSize(width: sizeItem, height: (sizeItem*1.4)+(sizeItem*0.40))
    }
}

//MARK: - UIScrollDelegate

extension CategoriesDetailContV {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffset > scrollView.contentOffset.y,
        lastContentOffset < scrollView.contentSize.height - scrollView.frame.height {
            delegate?.handleScrollUp()
            
        } else if lastContentOffset < scrollView.contentOffset.y, scrollView.contentOffset.y > 0 {
            delegate?.handleScrollDown()
        }
        
        lastContentOffset = scrollView.contentOffset.y
    }
}
