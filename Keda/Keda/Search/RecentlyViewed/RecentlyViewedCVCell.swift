//
//  RecentlyViewedCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class RecentlyViewedCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "RecentlyViewedCVCell"
    let imgView = UIImageView()
    let originalPrLbl = UILabel()
    let currentPrLbl = UILabel()
    
    var product: Product! {
        didSet {
            originalPrLbl.isHidden = product.saleOff <= 0.0
            
            Product.downloadImage(from: product.imageLink) { (image) in
                DispatchQueue.main.async {
                    self.imgView.image = image
                }
            }
            
            let price = product.price
            let saleOff = product.saleOff
            if product.saleOff > 0.0 {
                calculatesaleOff(price, saleOff: saleOff) { (sPrice) in
                    self.originalPrLbl.text = price.formattedWithCurrency
                    self.currentPrLbl.text = sPrice.formattedWithCurrency
                }

            } else {
                currentPrLbl.text = "\(price.formattedWithCurrency)"
                
            }
        }
    }
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 0.8
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 1.0
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 1.0
        super.touchesCancelled(touches, with: event)
    }
}

//MARK: - Configures

extension RecentlyViewedCVCell {
    
    func configureCell() {
        clipsToBounds = true
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.5
        
        imgView.configureIMGViewForCell(contentView, imgName: "a1") //ImgageView
        
        //TODO: - BGView
        let dimsBG = UIView()
        dimsBG.backgroundColor = UIColor(hex: 0x000000, alpha: 0.7)
        dimsBG.clipsToBounds = true
        dimsBG.layer.cornerRadius = 5.0
        contentView.insertSubview(dimsBG, aboveSubview: imgView)
        dimsBG.translatesAutoresizingMaskIntoConstraints = false
        
        let price = Double(1000)
        originalPrLbl.configureOriginPrForCell(price, fontSize: 15.0) //OriginalPrice
        currentPrLbl.configureCurrentPrForCell(price, fontSize: 15.0) //CurrentPrice
        
        let views: [UIView] = [originalPrLbl, currentPrLbl]
        let sv = createdStackView(views, spacing: 5.0, axis: .horizontal, distribution: .fill, alignment: .leading)
        contentView.insertSubview(sv, aboveSubview: dimsBG)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            dimsBG.heightAnchor.constraint(equalToConstant: 30.0),
            dimsBG.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dimsBG.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dimsBG.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            sv.centerYAnchor.constraint(equalTo: dimsBG.centerYAnchor),
            sv.leadingAnchor.constraint(equalTo: dimsBG.leadingAnchor, constant: 5.0),
            sv.trailingAnchor.constraint(lessThanOrEqualTo: dimsBG.trailingAnchor, constant: -5.0),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension RecentlyViewedCVCell {
    
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
        layer.borderColor = isDarkMode ? UIColor.darkGray.cgColor : UIColor.gray.cgColor
    }
}
