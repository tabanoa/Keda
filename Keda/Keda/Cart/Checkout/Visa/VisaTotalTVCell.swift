//
//  VisaTotalTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import UIKit

class VisaTotalTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "VisaTotalTVCell"
    let containerView = UIView()
    let titleLbl = UILabel()
    let totalLbl = UILabel()
    
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

extension VisaTotalTVCell {
    
    func configureCell() {
        backgroundColor = .clear
        containerView.setupShadowForView(contentView)
        
        let txt = NSLocalizedString("Total", comment: "VisaTotalTVCell.swift: Total")
        titleLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 17.0, isTxt: txt, fontN: fontNamedBold)
        containerView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let totalTxt = Double(1985.5).formattedWithCurrency
        totalLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 17.0, isTxt: totalTxt, fontN: fontNamedBold)
        containerView.addSubview(totalLbl)
        totalLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
            
            titleLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10.0),
            titleLbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            totalLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10.0),
            totalLbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension VisaTotalTVCell {
    
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
        let shadowC: UIColor = isDarkMode ? .white : .black
        containerView.layer.shadowColor = shadowC.cgColor
        containerView.backgroundColor = isDarkMode ? darkColor : .white
        
        titleLbl.textColor = isDarkMode ? .white : .darkGray
        totalLbl.textColor = isDarkMode ? .white : .darkGray
    }
}
