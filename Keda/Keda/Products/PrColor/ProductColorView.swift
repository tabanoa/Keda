//
//  ProductColorView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol ProductColorViewDelegate: class {
    func didSelectColor(_ selectedColor: String, isSelectColor: Bool)
}

class ProductColorView: UIView {
    
    //MARK: - Properties
    weak var delegate: ProductColorViewDelegate?
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var selectedColor: String?
    var isSelectColor = false
    
    private let shape = CAShapeLayer()
    private let colorLbl = UILabel()
    
    private let colorW = screenWidth*0.20
    private let colorH = screenWidth*0.75
    
    var product: Product!
    
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

extension ProductColorView {
    
    func setupColorView(_ view: UIView, headerV: UIView, dl: ProductColorViewDelegate) {
        view.insertSubview(self, aboveSubview: headerV)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: colorW),
            heightAnchor.constraint(equalToConstant: colorH),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomAnchor.constraint(equalTo: headerV.bottomAnchor),
        ])
        
        let bezierPath = UIBezierPath()
        let addW: CGFloat = 20.0
        let value: CGFloat = 8.0
        bezierPath.move(to: .zero)
        bezierPath.addLine(to: CGPoint(x: 0.0, y: colorH))
        bezierPath.addLine(to: CGPoint(x: addW, y: colorH))
        bezierPath.addLine(to: CGPoint(x: colorW, y: colorH))
        bezierPath.addLine(to: CGPoint(x: colorW+addW, y: colorH))
        bezierPath.addCurve(to: CGPoint(x: colorW, y: colorH-addW),
                            controlPoint1: CGPoint(x: colorW+value, y: colorH),
                            controlPoint2: CGPoint(x: colorW, y: colorH-value))
        bezierPath.addLine(to: CGPoint(x: colorW, y: colorH-addW))
        bezierPath.addLine(to: CGPoint(x: colorW, y: addW))
        bezierPath.addCurve(to: CGPoint(x: colorW-addW, y: 0.0),
                            controlPoint1: CGPoint(x: colorW, y: value),
                            controlPoint2: CGPoint(x: colorW-value, y: 0.0))
        bezierPath.close()
        
        shape.path = bezierPath.cgPath
        shape.strokeColor = UIColor.clear.cgColor
        shape.fillColor = groupColor.cgColor
        shape.lineWidth = 1.0
        layer.addSublayer(shape)
        
        setupCV()
        delegate = dl
    }
    
    func setupCV() {
        let txt = NSLocalizedString("Colors", comment: "ProductColorView.swift: Colors")
        colorLbl.configureNameForCell(false, txtColor: .black, fontSize: 13.0, isTxt: txt, fontN: fontNamedBold)
        addSubview(colorLbl)
        colorLbl.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.configureCVAddSub(ds: self, dl: self, view: self)
        collectionView.register(ProductColorCVCell.self, forCellWithReuseIdentifier: ProductColorCVCell.identifier)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        
        NSLayoutConstraint.activate([
            colorLbl.topAnchor.constraint(equalTo: topAnchor, constant: 20.0),
            colorLbl.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            collectionView.widthAnchor.constraint(equalToConstant: colorW*0.6),
            collectionView.topAnchor.constraint(equalTo: colorLbl.bottomAnchor, constant: 10.0),
            collectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: appDl.iPhone5 ? 5.0 : 10.0),
        ])
    }
    
    func setupDarkMode(_ isDarkMode: Bool) {
        shape.fillColor = isDarkMode ? UIColor.black.cgColor : groupColor.cgColor
        colorLbl.textColor = isDarkMode ? .white : .black
    }
}

//MARK: - UICollectionViewDataSource

extension ProductColorView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductColorCVCell.identifier, for: indexPath) as! ProductColorCVCell
        let color = product.colors[indexPath.item]
        cell.backgroundColor = color.getHexColor()
        setupCell(color, cell: cell)
        return cell
    }
    
    func setupCell(_ color: String, cell: ProductColorCVCell) {
        cell.isSelect = selectedColor == color
        isSelectColor = selectedColor != nil
    }
}

//MARK: - UICollectionViewDelegate

extension ProductColorView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProductColorCVCell
        touchAnim(cell, frValue: 0.8) {
            self.selectedColor = nil
            
            let color = self.product.colors[indexPath.item]
            self.selectedColor = color
            self.isSelectColor = self.selectedColor != nil
            self.delegate?.didSelectColor(self.selectedColor!, isSelectColor: self.isSelectColor)
            self.collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProductColorView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 30.0
        return CGSize(width: height, height: height)
    }
}
