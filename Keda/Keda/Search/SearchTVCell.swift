//
//  SearchTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class SearchTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "SearchTVCell"
    
    var imgView = UIImageView()
    var nameLbl = UILabel()
    var originalPrLbl = UILabel()
    var ratingSmallSV = RatingSmallSV()
    var currentPrLbl = UILabel()
    
    var product: Product! {
        didSet {
            nameLbl.text = product.name
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
                currentPrLbl.text = price.formattedWithCurrency
            }
            
            Rating.fetchRatings(prUID: product.uid) { (rating) in
                guard let rating = rating else { self.ratingSmallSV.rating = 0; return }
                rating.calculateAverage { (_, _, _, _, _, _, average) in
                    self.ratingSmallSV.rating = Int(average)
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

extension SearchTVCell {
    
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
        
        let price = Double(1000)
        nameLbl.configureNameForCell(false, line: 2, txtColor: .darkGray, fontSize: 15.0, isTxt: "Designed By Keda Team", fontN: fontNamed)
        originalPrLbl.configureOriginPrForCell(price, txtColor: .darkGray, fontSize: 15.0)
        currentPrLbl.configureCurrentPrForCell(price, txtColor: .darkGray, fontSize: 15.0)
        
        let views1 = [originalPrLbl, currentPrLbl]
        let sv1 = createdStackView(views1, spacing: 8.0, axis: .horizontal, distribution: .fill, alignment: .leading)
        
        //StackView 1
        let views2 = [nameLbl, sv1]
        let sv2 = createdStackView(views2, spacing: 2.0, axis: .vertical, distribution: .fill, alignment: .leading)
        
        //StackView 2
        let views3 = [imgView, sv2]
        let sv3 = createdStackView(views3, spacing: 8.0, axis: .horizontal, distribution: .fill, alignment: .top)
        contentView.addSubview(sv3)
        sv3.translatesAutoresizingMaskIntoConstraints = false
        
        //Rating
        let height: CGFloat = ratingSmallSV.height
        contentView.addSubview(ratingSmallSV)
        ratingSmallSV.translatesAutoresizingMaskIntoConstraints = false
        
        let cons: CGFloat = 15*5 + 30
        NSLayoutConstraint.activate([
            sv3.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            sv3.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sv3.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -cons),
            
            ratingSmallSV.widthAnchor.constraint(equalToConstant: height*5),
            ratingSmallSV.heightAnchor.constraint(equalToConstant: height),
            ratingSmallSV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
            ratingSmallSV.topAnchor.constraint(equalTo: sv3.topAnchor),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension SearchTVCell {
    
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
        originalPrLbl.textColor = isDarkMode ? .lightGray : .darkGray
        currentPrLbl.textColor = isDarkMode ? .lightGray : .darkGray
        
        let lightC = UIColor(hex: 0xE5E5E5, alpha: 0.7)
        let darkC = UIColor(hex: 0x3A3A3A, alpha: 0.5)
        let selectC: UIColor = isDarkMode ? darkC : lightC
        setupSelectedCell(selectC: selectC) { (selectedView) in
            self.selectedBackgroundView = selectedView
        }
    }
}
