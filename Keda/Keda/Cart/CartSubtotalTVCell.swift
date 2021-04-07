//
//  CartSubtotalTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class CartSubtotalTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CartSubtotalTVCell"
    let containerView = UIView()
    let subtotalTitleLbl = UILabel()
    let shippingFeeTitleLbl = UILabel()
    let taxTitleLbl = UILabel()
    
    let subtotalLbl = UILabel()
    let shippingFeeLbl = UILabel()
    let taxLbl = UILabel()
    
    var shoppingCart: ShoppingCart! {
        didSet {
            subtotalLbl.text = shoppingCart.subtotal.formattedWithCurrency
            shippingFeeLbl.text = shoppingCart.fee.formattedWithCurrency
            taxLbl.text = shoppingCart.tax.formattedWithCurrency
        }
    }
    
    //MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension CartSubtotalTVCell {
    
    func configureCell() {
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.setupShadowForView(contentView)
        
        //TODO: - NameLbl
        let subtotalNameTxt = NSLocalizedString("SUBTOTAL", comment: "CartSubtotalTVCell.swift: SUBTOTAL")
        subtotalTitleLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 15.0, isTxt: subtotalNameTxt, fontN: fontNamedBold)
        
        let feeNameTxt = NSLocalizedString("SHIPPING FEE", comment: "CartSubtotalTVCell.swift: SHIPPING FEE")
        shippingFeeTitleLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 15.0, isTxt: feeNameTxt, fontN: fontNamedBold)
        
        let taxNameTxt = NSLocalizedString("TAX", comment: "CartSubtotalTVCell.swift: TAX")
        taxTitleLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 15.0, isTxt: taxNameTxt, fontN: fontNamedBold)
        
        //TODO: - NumberLbl
        subtotalLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 15.0, isTxt: Double(1800).formattedWithCurrency, fontN: fontNamedBold)
        shippingFeeLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 15.0, isTxt: Double(5).formattedWithCurrency, fontN: fontNamedBold)
        taxLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 15.0, isTxt: Double((1800+5)*0.1).formattedWithCurrency, fontN: fontNamedBold)
        
        subtotalLbl.textAlignment = .right
        shippingFeeLbl.textAlignment = .right
        taxLbl.textAlignment = .right
        
        //TODO: - UIStackView
        let views1 = [subtotalTitleLbl, shippingFeeTitleLbl, taxTitleLbl]
        let sv1 = createdStackView(views1, spacing: 10.0, axis: .vertical, distribution: .equalSpacing, alignment: .fill)
        
        let views2 = [subtotalLbl, shippingFeeLbl, taxLbl]
        let sv2 = createdStackView(views2, spacing: 10.0, axis: .vertical, distribution: .equalSpacing, alignment: .fill)
        
        let views3 = [sv1, sv2]
        let sv3 = createdStackView(views3, spacing: 10.0, axis: .horizontal, distribution: .fillProportionally, alignment: .fill)
        containerView.addSubview(sv3)
        sv3.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
            
            sv3.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            sv3.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            sv3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
            sv3.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension CartSubtotalTVCell {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    private func setupDarkMode() {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupDarkModeView()
            case .dark: setupDarkModeView(true)
            default: break
            }
        } else {
            setupDarkModeView()
        }
    }
    
    private func setupDarkModeView(_ isDarkMode: Bool = false) {
        let lightC = UIColor(hex: 0xE5E5E5, alpha: 0.7)
        let darkC = UIColor(hex: 0x3A3A3A, alpha: 0.5)
        let selectC: UIColor = isDarkMode ? darkC : lightC
        setupSelectedCell(selectC: selectC) { (selectedView) in
            self.selectedBackgroundView = selectedView
        }
        
        let conC: UIColor = isDarkMode ? .white : .black
        containerView.layer.shadowColor = conC.cgColor
        containerView.backgroundColor = isDarkMode ? darkColor : .white
        
        subtotalTitleLbl.textColor = isDarkMode ? .white : .darkGray
        subtotalLbl.textColor = isDarkMode ? .white : .darkGray
        
        shippingFeeTitleLbl.textColor = isDarkMode ? .white : .darkGray
        shippingFeeLbl.textColor = isDarkMode ? .white : .darkGray
        
        taxTitleLbl.textColor = isDarkMode ? .white : .darkGray
        taxLbl.textColor = isDarkMode ? .white : .darkGray
    }
}
