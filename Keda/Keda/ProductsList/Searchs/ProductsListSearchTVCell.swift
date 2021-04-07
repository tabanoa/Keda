//
//  ProductsListSearchTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ProductsListSearchTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "ProductsListSearchTVCell"
    
    var imgView = UIImageView()
    var nameLbl = UILabel()
    
    var product: Product! {
        didSet {
            nameLbl.text = product.name
            
            Product.downloadImage(from: product.imageLink) { (image) in
                DispatchQueue.main.async {
                    self.imgView.image = image
                }
            }
        }
    }
    
    //MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension ProductsListSearchTVCell {
    
    func configureCell() {
        //ImageView
        let imgHeight: CGFloat = 50.0
        imgView.configureIMGViewForCell(contentView, imgName: "a1", ctMore: .scaleAspectFit)
        imgView.layer.cornerRadius = 3.0
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        imgView.layer.borderWidth = 0.5
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.widthAnchor.constraint(equalToConstant: imgHeight).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: imgHeight).isActive = true
        
        nameLbl.configureNameForCell(false, line: 2, txtColor: .darkGray, fontSize: 15.0, isTxt: "Designed By Keda Team", fontN: fontNamed)
        
        //StackView 2
        let views = [imgView, nameLbl]
        let sv = createdStackView(views, spacing: 8.0, axis: .horizontal, distribution: .fill, alignment: .center)
        contentView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            sv.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sv.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -15),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension ProductsListSearchTVCell {
    
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
        nameLbl.textColor = isDarkMode ? .lightGray : .darkGray
        
        let lightC = UIColor(hex: 0xE5E5E5, alpha: 0.7)
        let darkC = UIColor(hex: 0x3A3A3A, alpha: 0.5)
        let selectC: UIColor = isDarkMode ? darkC : lightC
        setupSelectedCell(selectC: selectC) { (selectedView) in
            self.selectedBackgroundView = selectedView
        }
    }
}
