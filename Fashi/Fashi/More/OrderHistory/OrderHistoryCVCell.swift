//
//  OrderHistoryCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class OrderHistoryCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "OrderHistoryCVCell"
    
    var orderHistoryTVCell: OrderHistoryTVCell!
    let imgView = UIImageView()
    let nameLbl = UILabel()
    
    var prCart: ProductCart! {
        didSet {
            nameLbl.text = prCart.name
            Product.downloadImage(from: prCart.imageLink) { (image) in
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
        orderHistoryTVCell.layer.opacity = 0.8
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        orderHistoryTVCell.layer.opacity = 1.0
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        orderHistoryTVCell.layer.opacity = 1.0
        super.touchesCancelled(touches, with: event)
    }
}

//MARK: - Configures

extension OrderHistoryCVCell {
    
    func configureCell() {
        //TODO: - ImageView
        let imgHeight: CGFloat = 80.0
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        imgView.layer.cornerRadius = 10.0
        imgView.layer.borderWidth = 1.0
        imgView.layer.borderColor = UIColor(hex: 0x000000, alpha: 0.05).cgColor
        imgView.image = nil
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.widthAnchor.constraint(equalToConstant: imgHeight).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: imgHeight).isActive = true
        
        //TODO: - TitleLbl
        nameLbl.configureNameForCell(false, line: 3, txtColor: .darkText, fontSize: 16.0, fontN: fontNamedBold)
        nameLbl.textAlignment = .left
        
        let views = [imgView, nameLbl]
        let sv = createdStackView(views, spacing: 8.0, axis: .horizontal, distribution: .fill, alignment: .center)
        contentView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sv.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sv.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -5.0),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension OrderHistoryCVCell {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    private func setupDarkMode() {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupDarkModeView()
            case .dark: setupDarkModeView(true)
            default: break
            }
        } else {
            setupDarkModeView()
        }
    }
    
    private func setupDarkModeView(_ isDarkMode: Bool = false) {
        nameLbl.textColor = isDarkMode ? .lightText : .darkText
        
        let borderC: UIColor = isDarkMode ? .darkGray : UIColor(hex: 0x000000, alpha: 0.05)
        imgView.layer.borderColor = borderC.cgColor
    }
}
