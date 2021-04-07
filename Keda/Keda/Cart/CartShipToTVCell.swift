//
//  CartShipToTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class CartShipToTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CartShipToTVCell"
    let containerView = UIView()
    let leftLbl = UILabel()
    let rightLbl = UILabel()
    let rightImgV = UIImageView()
    
    var addr: Address! {
        didSet {
            if addr.defaults { rightLbl.text = addr.addrLine1 }
        }
    }
    
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

extension CartShipToTVCell {
    
    func configureCell() {
        backgroundColor = .clear
        
        //TODO: - ContainerView
        
        containerView.frame = CGRect(x: 5.0, y: 5.0, width: screenWidth-10, height: 50.0)
        containerView.setupContainerView(containerView)
        contentView.addSubview(containerView)
        
        let leftTxt = NSLocalizedString("Ship to", comment: "CartShipToTVCell.swift: Ship to")
        leftLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 15.0, isTxt: leftTxt, fontN: fontNamedBold)
        rightLbl.configureNameForCell(false, txtColor: UIColor(hex: 0x2AB5EC), fontSize: 15.0, isTxt: "123 Street", fontN: fontNamedBold)
        containerView.addSubview(leftLbl)
        leftLbl.translatesAutoresizingMaskIntoConstraints = false
        
        rightImgV.clipsToBounds = true
        rightImgV.image = UIImage(named: "icon-back")?.withRenderingMode(.alwaysTemplate)
        rightImgV.tintColor = UIColor(hex: 0x2AB5EC)
        rightImgV.contentMode = .scaleAspectFit
        rightImgV.transform = CGAffineTransform(rotationAngle: CGFloat(-180).degreesToRadians())
        rightImgV.translatesAutoresizingMaskIntoConstraints = false
        rightImgV.widthAnchor.constraint(equalToConstant: 12.0).isActive = true
        rightImgV.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
        
        let views = [rightLbl, rightImgV]
        let sv = createdStackView(views, spacing: 8, axis: .horizontal, distribution: .fill, alignment: .center)
        containerView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        rightLbl.sizeToFit()
        
        NSLayoutConstraint.activate([
            leftLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10.0),
            leftLbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            sv.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10.0),
            sv.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension CartShipToTVCell {
    
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
        
        let conC: UIColor = isDarkMode ? .white : .black
        containerView.layer.shadowColor = conC.cgColor
        containerView.backgroundColor = isDarkMode ? darkColor : .white
        leftLbl.textColor = isDarkMode ? .white : .darkGray
        rightLbl.textColor = isDarkMode ? UIColor(hex: 0x2687FB) : UIColor(hex: 0x2AB5EC)
        rightImgV.tintColor = isDarkMode ? UIColor(hex: 0x2687FB) : UIColor(hex: 0x2AB5EC)
    }
}
