//
//  CategoriesCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class CategoriesCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesCVCell"
    let imgView = UIImageView()
    let titleLbl = UILabel()
    let dimsBG = UIView()
    
    var category: Category! {
        didSet {
            titleLbl.text = category.name.uppercased()
            imgView.image = UIImage(named: category.imageName)
        }
    }
    
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

extension CategoriesCVCell {
    
    func configureCell() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 8.0
        
        //TODO: - ImgageView
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: "belts")
        contentView.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - BGView
        dimsBG.backgroundColor = UIColor(hex: 0x000000, alpha: 0.7)
        dimsBG.clipsToBounds = true
        dimsBG.layer.cornerRadius = 8.0
        contentView.insertSubview(dimsBG, aboveSubview: imgView)
        dimsBG.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleLbl
        titleLbl.configureNameForCell(false, txtColor: .white, fontSize: 17.0, isTxt: "CATEGORIES", fontN: fontNamed)
        titleLbl.textAlignment = .center
        contentView.insertSubview(titleLbl, aboveSubview: dimsBG)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            dimsBG.topAnchor.constraint(equalTo: contentView.topAnchor),
            dimsBG.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dimsBG.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dimsBG.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLbl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLbl.leadingAnchor.constraint(lessThanOrEqualTo: contentView.leadingAnchor, constant: 5.0),
            titleLbl.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: 5.0),
        ])
    }
}

//MARK: - DarkMode

extension CategoriesCVCell {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupDarkMode()
            case .dark: setupDarkMode(true)
            default: break
            }
            
        } else {
            setupDarkMode()
        }
    }
    
    private func setupDarkMode(_ isDarkMode: Bool = false) {
        dimsBG.backgroundColor = UIColor(hex: 0x000000, alpha: isDarkMode ? 0.4 : 0.7)
    }
}
