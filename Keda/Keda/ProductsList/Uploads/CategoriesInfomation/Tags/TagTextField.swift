//
//  TagTextField.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class TagTextField: UITextField {
    
    let edgeInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edgeInset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edgeInset)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edgeInset)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupTraitColection()
            case .dark: setupTraitColection(true)
            default: break
            }
        } else {
            setupTraitColection()
        }
        
        font = UIFont(name: fontNamed, size: 14.0)
        becomeFirstResponder()
        clipsToBounds = true
        layer.masksToBounds = false
        layer.cornerRadius = 5.0
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(hex: 0xEFEFF4, alpha: 0.8).cgColor
        layer.shadowOffset = CGSize(width: -1.0, height: 1.0)
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 0.2
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setupTraitColection(_ isDarkMode: Bool = false) {
        backgroundColor = isDarkMode ? darkColor : groupColor
        layer.shadowColor = isDarkMode ? UIColor.white.cgColor : UIColor.black.cgColor
    }
}
