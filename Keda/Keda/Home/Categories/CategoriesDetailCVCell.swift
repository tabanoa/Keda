//
//  CategoriesDetailCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class CategoriesDetailCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesDetailCVCell"
    let imgView = UIImageView()
    let nameLbl = UILabel()
    let originalPrLbl = UILabel()
    let percentLbl = UILabel()
    let currentPrLbl = UILabel()
    var containerView = UIView()
    
    var category: Product! {
        didSet {
            nameLbl.text = category.name
            percentLbl.isHidden = category.saleOff <= 0.0
            originalPrLbl.isHidden = category.saleOff <= 0.0
            
            Product.downloadImage(from: category.imageLink) { (image) in
                DispatchQueue.main.async {
                    self.imgView.image = image
                }
            }
            
            let price = category.price
            let saleOff = category.saleOff
            if category.saleOff > 0.0 {
                calculatesaleOff(price, saleOff: saleOff) { (sPrice) in //Dollar
                    self.originalPrLbl.text = price.formattedWithCurrency
                    self.currentPrLbl.text = "\(sPrice.formattedWithCurrency)"
                    self.percentLbl.text = "-\(saleOff.formattedWithDecimal)%"
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

extension CategoriesDetailCVCell {
    
    func configureCell() {
        containerView.setupShadowForView(contentView, cornerR: 10.0)
        
        imgView.configureIMGViewForCell(containerView, imgName: "a1") //ImgageView
        imgView.layer.cornerRadius = 10.0
        
        //TODO: - BottomView
        let bottomView = UIView()
        bottomView.backgroundColor = .clear
        contentView.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        percentLbl.configurePercentForCell(containerView) //Percent
        percentLbl.clipsToBounds = true
        percentLbl.layer.cornerRadius = 3.0

        //TODO: - OriginalPrice
        let price = Double(1000)
        originalPrLbl.configureOriginPrForCell(price, hidden: false, txtColor: .darkGray, fontSize: 15.0)
        currentPrLbl.configureCurrentPrForCell(price, txtColor: .darkGray, fontSize: 15.0)
        nameLbl.configureNameForCell(false, txtColor: .gray, fontSize: 13.0, fontN: fontNamedBold)
        
        let views1: [UIView] = [originalPrLbl, currentPrLbl]
        let sv1 = createdStackView(views1, spacing: 8.0, axis: .horizontal, distribution: .fill, alignment: .leading)
        
        let views2: [UIView] = [sv1, nameLbl]
        let sv2 = createdStackView(views2, spacing: 0.0, axis: .vertical, distribution: .fill, alignment: .leading)
        bottomView.addSubview(sv2)
        sv2.translatesAutoresizingMaskIntoConstraints = false
        
        let percentW = estimatedText(percentLbl.text!).width + 8.0
        let contentW = contentView.frame.width
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
            containerView.heightAnchor.constraint(equalToConstant: contentW*1.4),
            
            imgView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imgView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            bottomView.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 8.0),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            bottomView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8.0),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            sv2.topAnchor.constraint(equalTo: bottomView.topAnchor),
            sv2.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            sv2.trailingAnchor.constraint(lessThanOrEqualTo: bottomView.trailingAnchor),
            sv2.bottomAnchor.constraint(lessThanOrEqualTo: bottomView.bottomAnchor),
            
            percentLbl.widthAnchor.constraint(equalToConstant: percentW),
            percentLbl.heightAnchor.constraint(equalToConstant: 20.0),
            percentLbl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5.0),
            percentLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5.0),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension CategoriesDetailCVCell {
    
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
        originalPrLbl.textColor = isDarkMode ? .lightGray : .darkGray
        currentPrLbl.textColor = isDarkMode ? .lightGray : .darkGray
        nameLbl.textColor = isDarkMode ? .white : .gray
        containerView.layer.shadowColor = isDarkMode ? UIColor.white.cgColor : UIColor.black.cgColor
    }
}
