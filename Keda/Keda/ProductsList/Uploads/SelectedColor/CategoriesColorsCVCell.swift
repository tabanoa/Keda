//
//  CategoriesColorsCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class CategoriesColorsCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesColorsCVCell"
    let colorView = UIView()
    let checkmarkImgView = UIImageView()
    
    var color: UIColor! {
        didSet {
            colorView.backgroundColor = color
        }
    }
    
    var isSelect: Bool = false {
        didSet {
            checkmarkImgView.isHidden = !isSelect
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

extension CategoriesColorsCVCell {
    
    func configureCell() {
        colorView.clipsToBounds = true
        colorView.layer.cornerRadius = 5.0
        colorView.layer.borderColor = UIColor.darkGray.cgColor
        colorView.layer.borderWidth = 0.5
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        checkmarkImgView.isHidden = true
        checkmarkImgView.clipsToBounds = true
        checkmarkImgView.contentMode = .scaleAspectFit
        checkmarkImgView.image = UIImage(named: "icon-border-checkmark")
        contentView.addSubview(checkmarkImgView)
        checkmarkImgView.translatesAutoresizingMaskIntoConstraints = false
        
        let imgW: CGFloat = 20.0
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1.0),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1.0),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 1.0),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 1.0),
            
            checkmarkImgView.heightAnchor.constraint(equalToConstant: imgW),
            checkmarkImgView.widthAnchor.constraint(equalToConstant: imgW),
            checkmarkImgView.topAnchor.constraint(equalTo: colorView.topAnchor),
            checkmarkImgView.trailingAnchor.constraint(equalTo: colorView.trailingAnchor),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension CategoriesColorsCVCell {
    
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
        let borderC: UIColor = isDarkMode ? .lightGray : .darkGray
        colorView.layer.borderColor = borderC.cgColor
    }
}
