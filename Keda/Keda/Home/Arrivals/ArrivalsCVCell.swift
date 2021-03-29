//
//  ArrivalsCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ArrivalsCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "ArrivalsCVCell"
    let containerView = UIView()
    let imgView = UIImageView()
    let nameLbl = UILabel()
    let originalPrLbl = UILabel()
    let percentLbl = UILabel()
    let currentPrLbl = UILabel()
    
    var arrival: Product! {
        didSet {
            nameLbl.text = arrival.name
            percentLbl.isHidden = arrival.saleOff <= 0.0
            originalPrLbl.isHidden = arrival.saleOff <= 0.0
            
            Product.downloadImage(from: arrival.imageLink) { (image) in
                DispatchQueue.main.async {
                    self.imgView.image = image
                }
            }
            
            let price = arrival.price
            let saleOff = arrival.saleOff
            if arrival.saleOff > 0.0 {
                calculatesaleOff(price, saleOff: saleOff) { (sPrice) in
                    self.originalPrLbl.text = price.formattedWithCurrency
                    self.currentPrLbl.text = sPrice.formattedWithCurrency
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

extension ArrivalsCVCell {
    
    func configureCell() {
        configureBorderWidth(layer)
        imgView.configureIMGViewForCell(containerView, imgName: "")
        percentLbl.configurePercentForCell(containerView)
        let dimsBG = UIView().configureViewForCell(containerView, imgView)

        let price = Double(1000)
        originalPrLbl.configureOriginPrForCell(price)
        currentPrLbl.configureCurrentPrForCell(price)
        nameLbl.configureNameForCell()

        let views1: [UIView] = [originalPrLbl, currentPrLbl]
        let sv1 = createSVForCell(views1)

        let views2: [UIView] = [nameLbl, sv1]
        let sv2 = createSVForCell(views2, containerView)
        configureConstraintForCell(contentView, percentLbl, imgView, dimsBG, sv2, containerView)
    }
}

public func createSVForCell(_ views: [UIView]) -> UIStackView {
    let sv = createdStackView(views, spacing: 5.0, axis: .horizontal, distribution: .fill, alignment: .leading)
    return sv
}

public func createSVForCell(_ views: [UIView], _ contentView: UIView) -> UIStackView {
    let sv = createdStackView(views, spacing: 0.0, axis: .vertical, distribution: .fillProportionally, alignment: .leading)
    contentView.addSubview(sv)
    sv.translatesAutoresizingMaskIntoConstraints = false
    return sv
}

public func configureConstraintForCell(_ view: UIView,
                                       _ percentLbl: UILabel,
                                       _ imgView: UIImageView,
                                       _ dimsBG: UIView,
                                       _ sv: UIStackView,
                                       _ containerView: UIView) {
    containerView.backgroundColor = .clear
    view.addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    let percentW = estimatedText(percentLbl.text!).width + 8.0
    NSLayoutConstraint.activate([
        containerView.topAnchor.constraint(equalTo: view.topAnchor),
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
        imgView.topAnchor.constraint(equalTo: containerView.topAnchor),
        imgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        imgView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        imgView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        
        dimsBG.heightAnchor.constraint(equalToConstant: 30.0),
        dimsBG.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        dimsBG.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        dimsBG.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        
        percentLbl.widthAnchor.constraint(equalToConstant: percentW),
        percentLbl.heightAnchor.constraint(equalToConstant: 20.0),
        percentLbl.topAnchor.constraint(equalTo: containerView.topAnchor),
        percentLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        
        sv.trailingAnchor.constraint(lessThanOrEqualTo: dimsBG.trailingAnchor, constant: -8.0),
        sv.leadingAnchor.constraint(equalTo: dimsBG.leadingAnchor, constant: 5.0),
        sv.bottomAnchor.constraint(equalTo: dimsBG.bottomAnchor)
    ])
}

public func configureBorderWidth(_ layer: CALayer) {
    layer.borderWidth = 0.5
    layer.borderColor = UIColor(hex: 0x000000, alpha: 0.1).cgColor
}
