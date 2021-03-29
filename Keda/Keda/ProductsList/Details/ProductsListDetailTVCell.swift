//
//  ProductsListDetailTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ProductsListDetailTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "ProductsListDetailTVCell"
    let sizeLbl = UILabel()
    
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

extension ProductsListDetailTVCell {
    
    func configureCell() {
        accessoryType = .disclosureIndicator
        
        //TODO: - Size
        sizeLbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: "X", fontN: fontNamed)
        contentView.addSubview(sizeLbl)
        sizeLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sizeLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            sizeLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension ProductsListDetailTVCell {
    
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
        
        sizeLbl.textColor = isDarkMode ? .white : .black
    }
}
