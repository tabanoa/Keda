//
//  ProductRatingCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ProductRatingCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "ProductRatingCVCell"
    let activityIndicator = UIActivityIndicatorView()
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

extension ProductRatingCVCell {
    
    func configureCell() {
        clipsToBounds = true
        layer.cornerRadius = 5.0
        
        imgView.configureIMGViewForCell(contentView, imgName: "a1") //ImgageView
        
        activityIndicator.isHidden = true
        activityIndicator.style = .gray
        contentView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
