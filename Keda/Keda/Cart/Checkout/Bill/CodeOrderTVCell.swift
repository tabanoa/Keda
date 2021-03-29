//
//  CodeOrderTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class CodeOrderTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CodeOrderTVCell"
    
    let containerView = UIView()
    let codeOrdersLbl = UILabel()
    let dateOrderedLbl = UILabel()
    let stateLbl = UILabel()
    
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

extension CodeOrderTVCell {
    
    func configureCell() {
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.setupShadowForView(contentView)
        
        //TODO: - NameLbl
        codeOrdersLbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: "", fontN: fontNamedBold)
        dateOrderedLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 16.0, isTxt: "", fontN: fontNamed)
        stateLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 16.0, isTxt: "", fontN: fontNamed)
        
        let views1: [UIView] = [dateOrderedLbl, stateLbl]
        let sv1 = createdStackView(views1, spacing: 5.0, axis: .vertical, distribution: .fill, alignment: .leading)
        
        let views2: [UIView] = [codeOrdersLbl, sv1]
        let sv2 = createdStackView(views2, spacing: 12.0, axis: .vertical, distribution: .fill, alignment: .leading)
        containerView.addSubview(sv2)
        sv2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
            
            sv2.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            sv2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            sv2.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10.0),
            
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension CodeOrderTVCell {
    
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
        codeOrdersLbl.textColor = isDarkMode ? .white : .black
        dateOrderedLbl.textColor = isDarkMode ? .lightGray : .darkGray
        stateLbl.textColor = isDarkMode ? .lightGray : .darkGray
    }
}
