//
//  CategoriesColorSizeCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class CategoriesColorSizeCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesColorSizeCVCell"
    let imgView = UIImageView()
    
    var link: String! {
        didSet {
            Product.downloadImage(from: link) { (image) in
                DispatchQueue.main.async {
                    self.imgView.image = image
                }
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
}

//MARK: - Configures

extension CategoriesColorSizeCVCell {
    
    func configureCell() {
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 3.0
        imgView.contentMode = .scaleAspectFit
        contentView.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
