//
//  LogoutTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class LogoutTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "LogoutTVCell"
    let titleLbl = UILabel()
    
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

extension LogoutTVCell {
    
    func configureCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        let txt = NSLocalizedString("Logout", comment: "LogoutTVCell.swift: Logout")
        titleLbl.configureNameForCell(false, txtColor: .white, fontSize: 17.0, isTxt: txt, fontN: fontNamedBold)
        titleLbl.backgroundColor = .black
        titleLbl.clipsToBounds = true
        titleLbl.layer.cornerRadius = 5.0
        titleLbl.textAlignment = .center
        contentView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let cons1: CGFloat = 10.0
        let cons2: CGFloat = 20.0
        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: cons1),
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cons2),
            titleLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -cons2),
            titleLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -cons1),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension LogoutTVCell {
    
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
        
        titleLbl.textColor = isDarkMode ? .black : .white
        titleLbl.backgroundColor = isDarkMode ? .white : .black
    }
}
