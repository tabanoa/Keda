//
//  TotalTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class TotalTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "TotalTVCell"
    let containerView = UIView()
    let totalTitleLbl = UILabel()
    let totalLbl = UILabel()
    
    var shoppingCart: ShoppingCart! {
        didSet {
            totalLbl.text = shoppingCart.total.formattedWithCurrency
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

extension TotalTVCell {
    
    func configureCell() {
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.setupShadowForView(contentView)
        
        //TODO: - NameLbl
        let totalNameTxt = NSLocalizedString("TOTAL", comment: "TotalTVCell.swift: TOTAL")
        totalTitleLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 15.0, isTxt: totalNameTxt, fontN: fontNamedBold)
        totalLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 15.0, isTxt: Double(1800+5+180.5).formattedWithCurrency, fontN: fontNamedBold)
        totalLbl.textAlignment = .right
        
        let views = [totalTitleLbl, totalLbl]
        let sv = createdStackView(views, spacing: 10.0, axis: .horizontal, distribution: .fillProportionally, alignment: .fill)
        containerView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
            
            sv.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            sv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            sv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
            sv.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension TotalTVCell {
    
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
        let conC: UIColor = isDarkMode ? .white : .black
        containerView.layer.shadowColor = conC.cgColor
        containerView.backgroundColor = isDarkMode ? darkColor : .white
        
        totalTitleLbl.textColor = isDarkMode ? .lightGray : .darkGray
        totalLbl.textColor = isDarkMode ? .lightGray : .darkGray
    }
}
