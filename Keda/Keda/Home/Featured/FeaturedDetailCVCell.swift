//
//  FeaturedDetailCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class FeaturedDetailCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "FeaturedDetailCVCell"
    let containerView = UIView()
    let imgView = UIImageView()
    let nameLbl = UILabel()
    let originalPrLbl = UILabel()
    let percentLbl = UILabel()
    let currentPrLbl = UILabel()
    
    var featured: Product! {
        didSet {
            nameLbl.text = featured.name
            percentLbl.isHidden = featured.saleOff <= 0.0
            originalPrLbl.isHidden = featured.saleOff <= 0.0
            
            Product.downloadImage(from: featured.imageLink) { (image) in
                DispatchQueue.main.async {
                    self.imgView.image = image
                }
            }
            
            let price = featured.price
            let saleOff = featured.saleOff
            if featured.saleOff > 0.0 {
                calculatesaleOff(price, saleOff: saleOff) { (sPrice) in //Dollar
                    self.originalPrLbl.text = price.formattedWithCurrency
                    self.currentPrLbl.text = "\(sPrice.formattedWithCurrency)"
                    self.percentLbl.text = "-\(saleOff.formattedWithDecimal)%"
                }

            } else {
                currentPrLbl.text = "\(price.formattedWithCurrency)"
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

extension FeaturedDetailCVCell {
    
    func configureCell() {
        configureBorderWidth(layer)
        
        imgView.configureIMGViewForCell(containerView, imgName: "a1") //ImgageView
        percentLbl.configurePercentForCell(containerView) //Percent
        let dimsBG = UIView().configureViewForCell(containerView, imgView) //BGView

        //TODO: - OriginalPrice
        let price = Double(1000)
        originalPrLbl.configureOriginPrForCell(price) //OriginalPrice
        currentPrLbl.configureCurrentPrForCell(price) //CurrentPrice
        nameLbl.configureNameForCell() //Name
        
        let views1: [UIView] = [originalPrLbl, currentPrLbl]
        let sv1 = createSVForCell(views1)
        
        let views2: [UIView] = [nameLbl, sv1]
        let sv2 = createSVForCell(views2, containerView)
        configureConstraintForCell(contentView, percentLbl, imgView, dimsBG, sv2, containerView)
    }
}
