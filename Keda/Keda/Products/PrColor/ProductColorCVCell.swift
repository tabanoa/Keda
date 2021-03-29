//
//  ProductColorCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ProductColorCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "ProductColorCVCell"
    let checkmarkImgView = UIImageView()
    
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

extension ProductColorCVCell {
    
    func configureCell() {
        clipsToBounds = true
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.5
        
        checkmarkImgView.clipsToBounds = true
        checkmarkImgView.contentMode = .scaleAspectFit
        checkmarkImgView.image = UIImage(named: "icon-border-checkmark")
        contentView.addSubview(checkmarkImgView)
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
