//
//  WishlistTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class WishlistTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "WishlistTVCell"
    let containerView = UIView()
    let imgView = UIImageView()
    let titleLbl = UILabel()
    let dimsBG = UIView()
    
    var imgViewTopConst: NSLayoutConstraint!
    
    var categoryW: Category! {
        didSet {
            titleLbl.text = categoryW.name.uppercased()
            imgView.image = UIImage(named: categoryW.imageName)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        containerView.layer.opacity = 0.8
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        containerView.layer.opacity = 1.0
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        containerView.layer.opacity = 1.0
        super.touchesCancelled(touches, with: event)
    }
}

//MARK: - Configures

extension WishlistTVCell {
    
    func configureCell() {
        backgroundColor = .clear
        clipsToBounds = true
        layer.cornerRadius = 8.0
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8.0
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ImgageView
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: "belts")
        containerView.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - BGView
        dimsBG.backgroundColor = UIColor(hex: 0x000000, alpha: 0.7)
        dimsBG.clipsToBounds = true
        dimsBG.layer.cornerRadius = 8.0
        containerView.insertSubview(dimsBG, aboveSubview: imgView)
        dimsBG.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleLbl
        titleLbl.configureNameForCell(false, txtColor: .white, fontSize: 17.0, isTxt: "CATEGORIES", fontN: fontNamedBold)
        titleLbl.textAlignment = .center
        containerView.insertSubview(titleLbl, aboveSubview: dimsBG)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
        ])
        
        imgViewTopConst = imgView.topAnchor.constraint(equalTo: containerView.topAnchor)
        NSLayoutConstraint.activate([
            imgViewTopConst,
            imgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imgView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            dimsBG.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimsBG.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimsBG.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dimsBG.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            titleLbl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLbl.leadingAnchor.constraint(lessThanOrEqualTo: containerView.leadingAnchor, constant: 5.0),
            titleLbl.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: 5.0),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension WishlistTVCell {
    
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
        dimsBG.backgroundColor = UIColor(hex: 0x000000, alpha: isDarkMode ? 0.4 : 0.7)
    }
}
