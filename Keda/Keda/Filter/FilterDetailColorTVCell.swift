//
//  FilterDetailColorTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class FilterDetailColorTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "FilterDetailColorTVCell"
    let colorView = UIView()
    
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

extension FilterDetailColorTVCell {
    
    func configureCell() {
        //TODO: - ColorView
        colorView.backgroundColor = .clear
        colorView.clipsToBounds = true
        colorView.layer.cornerRadius = 3.0
        colorView.layer.borderColor = UIColor.lightGray.cgColor
        colorView.layer.borderWidth = 0.5
        colorView.isHidden = isHidden
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        let width: CGFloat = 30.0
        NSLayoutConstraint.activate([
            colorView.heightAnchor.constraint(equalToConstant: width),
            colorView.widthAnchor.constraint(equalToConstant: width),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
        ])
        
        setupDarkMode()
    }
}

//MARK: - Configures

extension FilterDetailColorTVCell {
    
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
        tintColor = isDarkMode ? .white : .black
        
        let lightC = UIColor(hex: 0xE5E5E5, alpha: 0.7)
        let darkC = UIColor(hex: 0x3A3A3A, alpha: 0.5)
        let selectC: UIColor = isDarkMode ? darkC : lightC
        setupSelectedCell(selectC: selectC) { (selectedView) in
            self.selectedBackgroundView = selectedView
        }
    }
}
