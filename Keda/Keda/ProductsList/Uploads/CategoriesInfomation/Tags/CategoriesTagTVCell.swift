//
//  CategoriesTagTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class CategoriesTagTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesTagTVCell"
    let tagLbl = UILabel()
    
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

extension CategoriesTagTVCell {
    
    func configureCell() {
        accessoryType = .disclosureIndicator
        
        //TODO: - Tag
        let txt = "bags woment, bags, belts, salvatore ferragamo"
        tagLbl.configureNameForCell(false, line: 0, txtColor: .black, fontSize: 17.0, isTxt: txt, fontN: fontNamed)
        contentView.addSubview(tagLbl)
        tagLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tagLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            tagLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            tagLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            tagLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension CategoriesTagTVCell {
    
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
        
        tagLbl.textColor = isDarkMode ? .white : .black
    }
}
