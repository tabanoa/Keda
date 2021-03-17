//
//  ProductSizeCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import UIKit

class ProductSizeCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "ProductSizeCVCell"
    let sizeLbl = UILabel()
    
    var isSelect: Bool = false {
        didSet {
            if #available(iOS 12.0, *) {
                switch traitCollection.userInterfaceStyle {
                case .light, .unspecified:
                    backgroundColor = isSelect ? .black : .white
                    sizeLbl.textColor = isSelect ? .white : .gray
                case .dark:
                    backgroundColor = isSelect ? .white : .black
                    sizeLbl.textColor = isSelect ? .black : .lightGray
                default: break
                }
            } else {
                backgroundColor = isSelect ? .black : .white
                sizeLbl.textColor = isSelect ? .white : .gray
            }
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

extension ProductSizeCVCell {
    
    func configureCell() {
        clipsToBounds = true
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.5
        
        //TODO: - Title
        sizeLbl.configureNameForCell(false, txtColor: .gray, fontSize: 13.0, isTxt: "XS", fontN: fontNamedBold)
        contentView.addSubview(sizeLbl)
        sizeLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sizeLbl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sizeLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

//MARK: - DarkMode

extension ProductSizeCVCell {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    private func setupDarkMode() {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: darkModeView()
            case .dark: darkModeView(true)
            default: break
            }
        } else {
            darkModeView()
        }
    }
    
    private func darkModeView(_ isDarkMode: Bool = false) {
        let borderC: UIColor = isDarkMode ? .lightGray : .gray
        layer.borderColor = borderC.cgColor
        
        if isDarkMode {
            backgroundColor = isSelect ? .white : .black
            sizeLbl.textColor = isSelect ? .black : .lightGray
            
        } else {
            backgroundColor = isSelect ? .black : .white
            sizeLbl.textColor = isSelect ? .white : .gray
        }
    }
}
