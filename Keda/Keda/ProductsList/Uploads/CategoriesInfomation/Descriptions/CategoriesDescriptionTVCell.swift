//
//  CategoriesDescriptionTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class CategoriesDescriptionTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesDescriptionTVCell"
    
    let descriptionLbl = UILabel()
    var heightConsDes: NSLayoutConstraint!
    
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

extension CategoriesDescriptionTVCell {
    
    func configureCell() {
        accessoryType = .disclosureIndicator
        
        //TODO: - Description
        let txt = """
● Ferragamo Studio Bag crafted in calfskin leather with gold-tone metal hardware.
● This shoulder bag features 1 main compartment, removable pouch, gold metal feet studs and crossbody straps.
● DiShorts'sions: H:9.8" x L:11.4" x W:5.7".
● Style: Shoulder Bag
"""
        descriptionLbl.configureNameForCell(false, line: 0, txtColor: .black, fontSize: 17.0, isTxt: txt, fontN: fontNamed)
        contentView.addSubview(descriptionLbl)
        descriptionLbl.translatesAutoresizingMaskIntoConstraints = false
        
        heightConsDes = descriptionLbl.heightAnchor.constraint(greaterThanOrEqualToConstant: 39.0)
        NSLayoutConstraint.activate([
            heightConsDes,
            descriptionLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            descriptionLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            descriptionLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            descriptionLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension CategoriesDescriptionTVCell {
    
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
        
        descriptionLbl.textColor = isDarkMode ? .white : .black
    }
}
