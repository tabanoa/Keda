//
//  UIImageView+Ext.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

extension UIImageView {
    
    func configureIMGViewForCell(_ contentView: UIView, imgName: String, ctMore: UIView.ContentMode = .scaleAspectFill) {
        contentMode = ctMore
        clipsToBounds = true
        image = UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate)
        tintColor = .black
        contentView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
