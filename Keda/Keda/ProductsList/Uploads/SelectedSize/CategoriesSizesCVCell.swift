//
//  CategoriesSizesCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class CategoriesSizesCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesSizesCVCell"
    let containerView = UIView()
    let sizeLbl = UILabel()
    
    var isSelect: Bool = false {
        didSet {
            if #available(iOS 12.0, *) {
                switch traitCollection.userInterfaceStyle {
                case .light, .unspecified: setupLight()
                case .dark: setupDark()
                default: break
                }
            } else {
                setupLight()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addContentForCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension CategoriesSizesCVCell {
    
    func addContentForCell() {
        //TODO: - ContainerView
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 3.0
        containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.layer.borderWidth = 1.0
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ColorName
        sizeLbl.configureNameForCell(false, txtColor: .black, fontSize: 15.0, isTxt: "X", fontN: fontNamedBold)
        sizeLbl.adjustsFontSizeToFitWidth = true
        sizeLbl.minimumScaleFactor = 0.1
        containerView.addSubview(sizeLbl)
        sizeLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            sizeLbl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            sizeLbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension CategoriesSizesCVCell {
    
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
        let borderC: UIColor = isDarkMode ? .lightGray : .gray
        containerView.layer.borderColor = borderC.cgColor
        sizeLbl.textColor = isDarkMode ? .white : .black
        
        if isDarkMode {
            setupDark()
            
        } else {
            setupLight()
        }
    }
    
    func setupDark() {
        containerView.backgroundColor = isSelect ? .white : .black
        sizeLbl.textColor = isSelect ? .black : .white
    }
    
    func setupLight() {
        containerView.backgroundColor = isSelect ? .black : .white
        sizeLbl.textColor = isSelect ? .white : .black
    }
}
