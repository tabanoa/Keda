//
//  CategoriesTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class CategoriesTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesTVCell"
    let nameLbl = UILabel()
    let iconImgView = UIImageView()
    
    var category: Category! {
        didSet {
            nameLbl.text = category.name
            iconImgView.image = UIImage(named: category.imageName)?.withRenderingMode(.alwaysTemplate)
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

extension CategoriesTVCell {
    
    func configureCell() {
        accessoryType = .disclosureIndicator
        
        nameLbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: "", fontN: fontNamed)
        
        let width: CGFloat = 30.0
        iconImgView.tintColor = .lightGray
        iconImgView.clipsToBounds = true
        iconImgView.layer.cornerRadius = width/2
        iconImgView.translatesAutoresizingMaskIntoConstraints = false
        iconImgView.heightAnchor.constraint(equalToConstant: width).isActive = true
        iconImgView.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        let views = [iconImgView, nameLbl]
        let sv = createdStackView(views, spacing: 10.0, axis: .horizontal, distribution: .fill, alignment: .center)
        contentView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            sv.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension CategoriesTVCell {
    
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
        nameLbl.textColor = isDarkMode ? .white : .black
        tintColor = isDarkMode ? .white : .black
    }
}
