//
//  ItemTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ItemTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "ItemTVCell"
    let containerView = UIView()
    let imgView = UIImageView()
    let nameLbl = UILabel()
    let currentPrLbl = UILabel()
    
    let colorView = ColorView()
    let sizeView = SizeView()
    var widthConsSizeV: NSLayoutConstraint!
    
    let quantityTitleLbl = UILabel()
    let colorTitleLbl = UILabel()
    let sizeTitleLbl = UILabel()
    
    let quantityLbl = UILabel()
    
    var product: ProductCart! {
        didSet {
            nameLbl.text = product.name
            quantityLbl.text = "\(product.quantity)"
            calculatesaleOff(product.price, saleOff: product.saleOff) { (price) in
                self.currentPrLbl.text = price.formattedWithCurrency
            }
            
            Product.downloadImage(from: product.imageLink) { (image) in
                DispatchQueue.main.async {
                    self.imgView.image = image
                }
            }
            
            let width = estimatedText(product.selectSize).width+20
            widthConsSizeV.constant = max(width, 50.0)
            sizeView.sizeLbl.text = product.selectSize
            colorView.backgroundColor = product.selectColor.getHexColor()
        }
    }
    
    //MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension ItemTVCell {
    
    func configureCell() {
        backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.setupShadowForView(contentView)

        //TODO: - ProductImageView
        imgView.configureIMGViewForCell(containerView, imgName: "a1")
        imgView.layer.borderColor = UIColor(hex: 0x000000, alpha: 0.02).cgColor
        imgView.layer.borderWidth = 1.0
        imgView.layer.cornerRadius = 8.0
        containerView.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false

        //TODO: - NameLbl
        let fontSize: CGFloat
        if appDl.iPhone5 {
            fontSize = 14.0
            
        } else {
            fontSize = 16.0
        }
        
        nameLbl.configureNameForCell(false, line: 2, txtColor: .darkGray, fontSize: fontSize, fontN: fontNamedBold)
        nameLbl.text = "The amount or number of a material or immaterial thing not usually estimated by spatial measurement."
        containerView.addSubview(nameLbl)
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - PriceLbl
        let price = Double(1000)
        let fontSizePr: CGFloat
        if appDl.iPhone5 {
            fontSizePr = 15.0
            
        } else {
            fontSizePr = 20.0
        }
        
        currentPrLbl.configureCurrentPrForCell(price, txtColor: .darkGray, fontSize: fontSizePr)
        contentView.addSubview(currentPrLbl)
        currentPrLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
            
            imgView.widthAnchor.constraint(equalToConstant: screenWidth*0.2),
            imgView.heightAnchor.constraint(equalToConstant: screenWidth*0.2),
            imgView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10.0),
            imgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10.0),
            
            nameLbl.topAnchor.constraint(equalTo: imgView.topAnchor, constant: -3.0),
            nameLbl.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10.0),
            nameLbl.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -5.0),
            
            currentPrLbl.leadingAnchor.constraint(equalTo: nameLbl.leadingAnchor),
            currentPrLbl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10.0),
        ])
        
        //TODO: - QuantityView
        let quantityView = UIView()
        setupShortView(quantityView, topAnchor: nameLbl.bottomAnchor, trailingAnchor: containerView.trailingAnchor)
        
        //TODO: - ColorView
        containerView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - SizeView
        containerView.addSubview(sizeView)
        sizeView.translatesAutoresizingMaskIntoConstraints = false
        
        widthConsSizeV = sizeView.widthAnchor.constraint(equalToConstant: 50.0)
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 30.0),
            colorView.heightAnchor.constraint(equalToConstant: 30.0),
            colorView.topAnchor.constraint(equalTo: quantityView.bottomAnchor, constant: 5.0),
            colorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5.0),
            
            widthConsSizeV,
            sizeView.heightAnchor.constraint(equalToConstant: 30.0),
            sizeView.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 5.0),
            sizeView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5.0)
        ])
        
        //TODO: - Title
        let fontSTitle: CGFloat = 13.0
        let quantityTxt = NSLocalizedString("Quantity:", comment: "ItemTVCell.swift: Quantity:")
        quantityTitleLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: fontSTitle, isTxt: quantityTxt, fontN: fontNamedBold)
        containerView.addSubview(quantityTitleLbl)
        quantityTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ColorTitle
        let colorTxt = NSLocalizedString("Color:", comment: "ItemTVCell.swift: Color:")
        colorTitleLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: fontSTitle, isTxt: colorTxt, fontN: fontNamedBold)
        containerView.addSubview(colorTitleLbl)
        colorTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - SizeTitle
        let sizeTxt = NSLocalizedString("Size:", comment: "ItemTVCell.swift: Size:")
        sizeTitleLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: fontSTitle, isTxt: sizeTxt, fontN: fontNamedBold)
        containerView.addSubview(sizeTitleLbl)
        sizeTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - QuantityLbl
        quantityLbl.configureNameForCell(false, txtColor: .black, fontSize: 13.0, isTxt: "50", fontN: fontNamedBold)
        quantityView.addSubview(quantityLbl)
        quantityLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            quantityTitleLbl.leadingAnchor.constraint(equalTo: nameLbl.leadingAnchor),
            quantityTitleLbl.centerYAnchor.constraint(equalTo: quantityView.centerYAnchor),
            
            colorTitleLbl.leadingAnchor.constraint(equalTo: nameLbl.leadingAnchor),
            colorTitleLbl.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),

            sizeTitleLbl.leadingAnchor.constraint(equalTo: nameLbl.leadingAnchor),
            sizeTitleLbl.centerYAnchor.constraint(equalTo: sizeView.centerYAnchor),
            
            quantityLbl.centerXAnchor.constraint(equalTo: quantityView.centerXAnchor),
            quantityLbl.centerYAnchor.constraint(equalTo: quantityView.centerYAnchor),
        ])
        
        setupDarkMode()
    }
    
    func setupShortView(_ view: UIView, topAnchor: NSLayoutYAxisAnchor, trailingAnchor: NSLayoutXAxisAnchor) {
        view.backgroundColor = UIColor(hex: 0xF8FAFB)
        view.clipsToBounds = true
        view.layer.cornerRadius = 3.0
        view.layer.borderColor = UIColor(hex: 0xDCDCDC).cgColor
        view.layer.borderWidth = 0.5
        containerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 30.0),
            view.heightAnchor.constraint(equalToConstant: 30.0),
            view.topAnchor.constraint(equalTo: topAnchor, constant: 5.0),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5.0)
        ])
    }
}

//MARK: - DarkMode

extension ItemTVCell {
    
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
        let lightC = UIColor(hex: 0xE5E5E5, alpha: 0.7)
        let darkC = UIColor(hex: 0x3A3A3A, alpha: 0.5)
        let selectC: UIColor = isDarkMode ? darkC : lightC
        setupSelectedCell(selectC: selectC) { (selectedView) in
            self.selectedBackgroundView = selectedView
        }
        
        let conC: UIColor = isDarkMode ? .white : .black
        containerView.layer.shadowColor = conC.cgColor
        containerView.backgroundColor = isDarkMode ? darkColor : .white
        
        nameLbl.textColor = isDarkMode ? .white : .darkGray
        currentPrLbl.textColor = isDarkMode ? .lightGray : .darkGray
        quantityTitleLbl.textColor = isDarkMode ? .lightGray : .darkGray
        colorTitleLbl.textColor = isDarkMode ? .lightGray : .darkGray
        sizeTitleLbl.textColor = isDarkMode ? .lightGray : .darkGray
        colorView.layer.borderColor = isDarkMode ? UIColor.lightGray.cgColor : UIColor.gray.cgColor
        sizeView.layer.borderColor = isDarkMode ? UIColor.lightGray.cgColor : UIColor.gray.cgColor
        sizeView.backgroundColor = isDarkMode ? .white : .black
        sizeView.sizeLbl.textColor = isDarkMode ? .black : .white
    }
}
