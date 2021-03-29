//
//  PaymentViewCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class PaymentViewCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "PaymentViewCVCell"
    
    let imgView = UIImageView()
    
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

extension PaymentViewCVCell {
    
    func configureCell() {
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        contentView.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalToConstant: screenWidth/2 - 40),
            imgView.heightAnchor.constraint(equalToConstant: bounds.height),
            imgView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
