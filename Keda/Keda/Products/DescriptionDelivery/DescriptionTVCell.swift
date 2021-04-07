//
//  CaSDDoTVCellS0.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class DescriptionTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "DescriptionTVCell"
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

extension DescriptionTVCell {
    
    func configureCell() {
        //Name
        contentLbl.configureNameForCell(false, line: 0, txtColor: .gray, fontSize: 15.0, fontN: fontNamed)
        contentView.addSubview(contentLbl)
        contentLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            contentLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            contentLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
            contentLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension DescriptionTVCell {
    
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
        contentLbl.textColor = isDarkMode ? .lightGray : .gray
    }
}
