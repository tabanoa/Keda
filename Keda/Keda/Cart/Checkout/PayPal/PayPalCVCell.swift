//
//  PayPalCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class PayPalCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "PayPalCVCell"
    
    let containerView = UIView()
    let titleLbl = UILabel()
    let contentLbl = UILabel()
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
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

extension PayPalCVCell {
    
    func configureCell() {
        backgroundColor = .clear
        
        containerView.setupShadowForView(contentView)
        
        titleLbl.configureNameForCell(false, txtColor: .black, fontSize: 20.0, isTxt: "PayPal", fontN: fontNamedBold)
        
        let txt = NSLocalizedString("Pay using PayPal's worldwide secure system.", comment: "PayPalCVCell.swift: Pay using PayPal's worldwide secure system.")
        contentLbl.configureNameForCell(false, line: 2, txtColor: .black, fontSize: 17.0, isTxt: txt, fontN: fontNamed)
        
        let views = [titleLbl, contentLbl]
        let sv = createdStackView(views, spacing: 10.0, axis: .vertical, distribution: .fill, alignment: .leading)
        containerView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 100.0),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
            
            sv.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10.0),
            sv.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15.0),
            sv.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -15.0)
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension PayPalCVCell {
    
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
        titleLbl.textColor = isDarkMode ? .white : .black
        contentLbl.textColor = isDarkMode ? .white : .black
    }
}
