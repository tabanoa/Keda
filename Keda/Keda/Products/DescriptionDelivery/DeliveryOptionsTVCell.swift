//
//  DeliveryOptionsTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class DeliveryOptionsTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "DeliveryOptionsTVCell"
    let titleLbl = UILabel()
    let contentLbl = UILabel()
    
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

extension DeliveryOptionsTVCell {
    
    func configureCell() {
        titleLbl.configureNameForCell(false, txtColor: .gray, fontSize: 15.0, fontN: fontNamed)
        contentLbl.configureNameForCell(false, line: 0, txtColor: .black, fontSize: 15.0, fontN: fontNamed)
        
        let views = [titleLbl, contentLbl]
        let sv = createdStackView(views, spacing: 10.0, axis: .vertical, distribution: .fillEqually, alignment: .leading)
        contentView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            sv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            sv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
            sv.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension DeliveryOptionsTVCell {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    private func setupDarkMode() {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: darkModeView()
            case .dark: darkModeView(true)
            default: break
            }
        } else {
            darkModeView()
        }
    }
    
    private func darkModeView(_ isDarkMode: Bool = false) {
        titleLbl.textColor = isDarkMode ? .lightGray : .gray
        contentLbl.textColor = isDarkMode ? .white : .black
    }
}
