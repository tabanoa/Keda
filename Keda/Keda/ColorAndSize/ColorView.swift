//
//  ColorView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ColorView: UIView {
    
    //MARK: - Properties
    private let checkmarkImgView = UIImageView()
    
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

extension ColorView {
    
    func updateUI() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 3.0
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.5
        
        checkmarkImgView.clipsToBounds = true
        checkmarkImgView.contentMode = .scaleAspectFit
        checkmarkImgView.image = UIImage(named: "icon-border-checkmark")
        addSubview(checkmarkImgView)
        checkmarkImgView.translatesAutoresizingMaskIntoConstraints = false
        
        let imgW: CGFloat = 20.0
        NSLayoutConstraint.activate([
            checkmarkImgView.heightAnchor.constraint(equalToConstant: imgW),
            checkmarkImgView.widthAnchor.constraint(equalToConstant: imgW),
            checkmarkImgView.topAnchor.constraint(equalTo: topAnchor),
            checkmarkImgView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
