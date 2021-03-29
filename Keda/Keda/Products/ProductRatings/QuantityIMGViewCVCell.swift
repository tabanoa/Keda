//
//  QuantityIMGViewCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class QuantityIMGViewCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "QuantityIMGViewCVCell"
    let productImgView = UIImageView()
    
    var link: String! {
        didSet {
            Product.downloadImage(from: link) { (image) in
                DispatchQueue.main.async {
                    self.productImgView.image = image
                }
            }
        }
    }
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension QuantityIMGViewCVCell {
    
    func configureCell() {
        contentView.addSubview(productImgView)
        productImgView.clipsToBounds = true
        productImgView.contentMode = .scaleAspectFill
        productImgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productImgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
    }
}
