//
//  WishlistCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol WishlistCVCellDelegate: class {
    func handleRemoveItem(_ cell: WishlistCVCell)
}

class WishlistCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "WishlistCVCell"
    weak var delegate: WishlistCVCellDelegate?
    
    let imgView = UIImageView()
    let nameLbl = UILabel()
    let originalPrLbl = UILabel()
    let favoriteBtn = UIButton()
    let containerView = UIView()
    
    var wishlist: Product! {
        didSet {
            let price = wishlist.price
            nameLbl.text = wishlist.name
            originalPrLbl.text = price.formattedWithCurrency
            
            Product.downloadImage(from: wishlist.imageLink) { (image) in
                DispatchQueue.main.async {
                    fadeImage(imgView: self.imgView, toImg: image, effect: true)
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

extension WishlistCVCell {
    
    func configureCell() {
        backgroundColor = .clear
        containerView.setupShadowForView(contentView, cornerR: 10.0)
        
        imgView.configureIMGViewForCell(containerView, imgName: "")
        imgView.layer.cornerRadius = 10.0
        
        //TODO: - FavoriteBtn
        let imgWidth: CGFloat = 30.0
        favoriteBtn.clipsToBounds = true
        favoriteBtn.layer.cornerRadius = imgWidth/2
        favoriteBtn.backgroundColor = UIColor(hex: 0xBABABA, alpha: 0.3)
        favoriteBtn.setImage(UIImage(named: "icon-favorite-filled"), for: .normal)
        favoriteBtn.addTarget(self, action: #selector(favoriteDidTap), for: .touchUpInside)
        containerView.insertSubview(favoriteBtn, aboveSubview: imgView)
        favoriteBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - BottomView
        let bottomView = UIView()
        bottomView.backgroundColor = .clear
        contentView.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false

        //TODO: - OriginalPrice
        let price = Double(1000)
        originalPrLbl.configureCurrentPrForCell(price, txtColor: .darkGray, fontSize: 15.0)
        nameLbl.configureNameForCell(false, line: 2, txtColor: .gray, fontSize: 13.0, fontN: fontNamedBold)
        
        let views: [UIView] = [originalPrLbl, nameLbl]
        let sv = createdStackView(views, spacing: 0.0, axis: .vertical, distribution: .fill, alignment: .leading)
        bottomView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        let contentW = contentView.frame.width
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
            containerView.heightAnchor.constraint(equalToConstant: contentW*1.4),
            
            imgView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imgView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            favoriteBtn.widthAnchor.constraint(equalToConstant: imgWidth),
            favoriteBtn.heightAnchor.constraint(equalToConstant: imgWidth),
            favoriteBtn.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5.0),
            favoriteBtn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5.0),
            
            bottomView.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 8.0),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            bottomView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8.0),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            sv.topAnchor.constraint(equalTo: bottomView.topAnchor),
            sv.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            sv.trailingAnchor.constraint(lessThanOrEqualTo: bottomView.trailingAnchor),
            sv.bottomAnchor.constraint(lessThanOrEqualTo: bottomView.bottomAnchor),
        ])
        
        setupDarkMode()
    }
    
    @objc func favoriteDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleRemoveItem(self)
        }
    }
}

//MARK: - DarkMode

extension WishlistCVCell {
    
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
        let conC: UIColor = isDarkMode ? .white : .black
        containerView.layer.shadowColor = conC.cgColor
        containerView.backgroundColor = isDarkMode ? darkColor : .white
        
        originalPrLbl.textColor = isDarkMode ? .white : .darkGray
        nameLbl.textColor = isDarkMode ? .lightGray : .gray
    }
}
