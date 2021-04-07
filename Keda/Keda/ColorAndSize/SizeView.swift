//
//  SizeView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class SizeView: UIView {
    
    //MARK: - Properties
    let sizeLbl = UILabel()
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension SizeView {
    
    func updateUI() {
        backgroundColor = .black
        clipsToBounds = true
        layer.cornerRadius = 3.0
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.5
        
        sizeLbl.configureNameForCell(false, txtColor: .white, fontSize: 13.0, isTxt: "XS", fontN: fontNamedBold)
        sizeLbl.textAlignment = .center
        addSubview(sizeLbl)
        sizeLbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sizeLbl.centerXAnchor.constraint(equalTo: centerXAnchor),
            sizeLbl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
