//
//  FilterDetailRatingTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class FilterDetailRatingTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "FilterDetailRatingTVCell"
    let titleLbl = UILabel()
    
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

extension FilterDetailRatingTVCell {
    
    func configureCell() {
        //TODO: - Title
        titleLbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: "", fontN: fontNamed)
        contentView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            titleLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        setupDarkMode()
    }
}

//MARK: - Configures

extension FilterDetailRatingTVCell {
    
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
        titleLbl.textColor = isDarkMode ? .white : .black
        tintColor = isDarkMode ? .white : .black
        
        let lightC = UIColor(hex: 0xE5E5E5, alpha: 0.7)
        let darkC = UIColor(hex: 0x3A3A3A, alpha: 0.5)
        let selectC: UIColor = isDarkMode ? darkC : lightC
        setupSelectedCell(selectC: selectC) { (selectedView) in
            self.selectedBackgroundView = selectedView
        }
    }
}
