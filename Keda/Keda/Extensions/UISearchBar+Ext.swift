//
//  UISearchBar+Ext.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import UIKit

extension UISearchBar {
    
    func customFontSearchBar(_ isDarkMode: Bool = false) {
        let bgColor: UIColor = isDarkMode ? darkColor : .white
        
        if #available(iOS 13, *) {
            self[keyPath: \.searchTextField].font = UIFont(name: fontNamed, size: 17.0)
            self[keyPath: \.searchTextField].backgroundColor = bgColor
            self[keyPath: \.searchTextField].placeholder = NSLocalizedString("Search", comment: "UISearchBar+Ext.swift: Search")
            
        } else {
            let subviews = self.subviews.flatMap({ $0.subviews })
            guard let tf = subviews.filter({ $0 is UITextField }).first as? UITextField else { return }
            tf.font = UIFont(name: fontNamed, size: 17.0)
            tf.backgroundColor = bgColor
            tf.placeholder = NSLocalizedString("Search", comment: "UISearchBar+Ext.swift: Search")
        }
    }
}
