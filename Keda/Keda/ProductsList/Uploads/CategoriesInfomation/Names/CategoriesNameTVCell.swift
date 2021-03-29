//
//  CategoriesNameTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class CategoriesNameTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesNameTVCell"
    var heightConsName: NSLayoutConstraint!
    
    let nameLbl = UILabel()
    
    //MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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

extension CategoriesNameTVCell {
    
    func configureCell() {
        accessoryType = .disclosureIndicator
        
        //TODO: - Name
        let txt = "Salvatore Ferragamo"
        nameLbl.configureNameForCell(false, line: 0, txtColor: .black, fontSize: 17.0, isTxt: txt, fontN: fontNamed)
        nameLbl.lineBreakMode = .byWordWrapping
        contentView.addSubview(nameLbl)
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        
        heightConsName = nameLbl.heightAnchor.constraint(greaterThanOrEqualToConstant: 39.0)
        NSLayoutConstraint.activate([
            heightConsName,
            nameLbl.widthAnchor.constraint(equalToConstant: screenWidth*0.85),
            nameLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            nameLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            nameLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension CategoriesNameTVCell {
    
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
        
        nameLbl.textColor = isDarkMode ? .white : .black
    }
}
