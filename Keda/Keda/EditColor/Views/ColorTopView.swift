//
//  ColorTopView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ColorTopView: UIView {
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension ColorTopView {
    
    func setupColorView(_ view: UIView) {
        let height: CGFloat = screenHeight*0.1
        clipsToBounds = true
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = height/2
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: screenWidth*0.9),
            heightAnchor.constraint(equalToConstant: height),
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topAnchor.constraint(equalTo: view.topAnchor, constant: 10.0)
        ])
    }
}
