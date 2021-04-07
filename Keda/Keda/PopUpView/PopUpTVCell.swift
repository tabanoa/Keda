//
//  PopUpTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class PopUpTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "PopUpTVCell"
    let label = UILabel()
    
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

extension PopUpTVCell {
    
    func configureCell() {
        label.configureNameForCell(false, txtColor: .black, fontSize: 15.0, isTxt: "Missing Data", fontN: fontNamed)
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension PopUpTVCell {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    func setupDarkMode() {
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
        
        label.textColor = isDarkMode ? .white : .black
    }
}
