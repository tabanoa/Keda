//
//  ProductSizeView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol ProductSizeViewDelegate: class {
    func didSelectSize(_ selectedSize: String, isSelectSize: Bool)
}

class ProductSizeView: UIView {
    
    //MARK: - Properties
    weak var delegate: ProductSizeViewDelegate?
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var selectedSize: String?
    private var isSelectSize = false
    
    private let sizeLbl = UILabel()
    
    private let colorW = screenWidth
    private let colorH = screenWidth*0.15
    
    var product: Product!
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = groupColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension ProductSizeView {
    
    func setupSizeView(_ view: UIView, headerV: UIView, dl: ProductSizeViewDelegate) {
        view.insertSubview(self, aboveSubview: headerV)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: colorW),
            heightAnchor.constraint(equalToConstant: colorH),
            topAnchor.constraint(equalTo: headerV.bottomAnchor),
            leadingAnchor.constraint(equalTo: headerV.leadingAnchor),
        ])
        
        setupCV()
        delegate = dl
    }
    
    func setupCV() {
        let txt = NSLocalizedString("Sizes", comment: "ProductSizeView.swift: Sizes")
        sizeLbl.configureNameForCell(false, txtColor: .black, fontSize: 13.0, isTxt: txt, fontN: fontNamedBold)
        addSubview(sizeLbl)
        sizeLbl.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.configureCVAddSub(ds: self, dl: self, view: self)
        collectionView.register(ProductSizeCVCell.self, forCellWithReuseIdentifier: ProductSizeCVCell.identifier)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        
        NSLayoutConstraint.activate([
            sizeLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            sizeLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.heightAnchor.constraint(equalToConstant: colorH*0.8),
            collectionView.leadingAnchor.constraint(equalTo: sizeLbl.trailingAnchor, constant: 10.0),
            collectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
        ])
    }
    
    func setupDarkMode(_ isDarkMode: Bool) {
        backgroundColor = isDarkMode ? .black : groupColor
        sizeLbl.textColor = isDarkMode ? .white : .black
    }
}

//MARK: - UICollectionViewDataSource

extension ProductSizeView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.sizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductSizeCVCell.identifier, for: indexPath) as! ProductSizeCVCell
        let size = product.sizes[indexPath.item].uppercased()
        cell.sizeLbl.text = size
        setupCell(size, cell: cell)
        return cell
    }
    
    func setupCell(_ size: String, cell: ProductSizeCVCell) {
        cell.isSelect = selectedSize == size
        isSelectSize = selectedSize != nil
    }
}

//MARK: - UICollectionViewDelegate

extension ProductSizeView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProductSizeCVCell
        touchAnim(cell, frValue: 0.8) {
            self.selectedSize = nil
            
            let size = self.product.sizes[indexPath.item].uppercased()
            self.selectedSize = size
            self.isSelectSize = self.selectedSize != nil
            self.delegate?.didSelectSize(self.selectedSize!, isSelectSize: self.isSelectSize)
            self.collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProductSizeView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 30.0
        let width = estimatedText(product.sizes[indexPath.item]).width + 20
        
        let h: CGFloat
        if width > height*2 {
            h = width
            
        } else {
            h = height*2
        }
        
        return CGSize(width: h, height: height)
    }
}
