//
//  VisaTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class VisaTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "VisaTVCell"
    let containerView = UIView()
    let iconImgV = UIImageView()
    let titleLbl = UILabel()
    let checkmarkLbl = UILabel()
    
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

extension VisaTVCell {
    
    func configureCell() {
        backgroundColor = .clear
        
        containerView.setupShadowForView(contentView)
        
        iconImgV.clipsToBounds = true
        iconImgV.image = nil
        iconImgV.contentMode = .scaleAspectFit
        iconImgV.translatesAutoresizingMaskIntoConstraints = false
        iconImgV.widthAnchor.constraint(equalToConstant: 36.0).isActive = true
        iconImgV.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        titleLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 17.0, isTxt: "", fontN: fontNamedBold)
        checkmarkLbl.configureNameForCell(true, txtColor: .black, fontSize: 22.0, isTxt: "✓", fontN: fontNamedBold)
        containerView.addSubview(checkmarkLbl)
        checkmarkLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [iconImgV, titleLbl]
        let sv = createdStackView(views, spacing: 10, axis: .horizontal, distribution: .fill, alignment: .center)
        containerView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
            
            sv.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10.0),
            sv.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            checkmarkLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10.0),
            checkmarkLbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension VisaTVCell {
    
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
        checkmarkLbl.textColor = isDarkMode ? .white : .black
    }
}
