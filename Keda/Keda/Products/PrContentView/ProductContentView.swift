//
//  ProductContentView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol ProductContentViewDelegate: class {
    func handleViewAllDidTap()
}

class ProductContentView: UIView {
    
    //MARK: - Properties
    weak var delegate: ProductContentViewDelegate?
    let nameLbl = UILabel()
    let originPriceLbl = UILabel()
    let currentPriceLbl = UILabel()
    let ratingSmallSV = RatingSmallSV()
    let viewAllBtn = ShowMoreBtn()
    let ratingsCountLbl = UILabel()
    
    private let viewAllTxt = NSLocalizedString("View All", comment: "ProductContentView.swift: View All")
    
    private var heightConstraint: NSLayoutConstraint!
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = groupColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension ProductContentView {
    
    func setupContentView(_ view: UIView, sizeView: UIView, dl: ProductContentViewDelegate) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Name
        let price: Double = 1000.0
        let fontSize: CGFloat = 19.0
        nameLbl.configureNameForCell(false, line: 2, txtColor: .gray, fontSize: 15.0)
        addSubview(nameLbl)
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        
        originPriceLbl.configureOriginPrForCell(price, hidden: false, txtColor: .darkGray, fontSize: fontSize)
        currentPriceLbl.configureCurrentPrForCell(price, txtColor: .darkGray, fontSize: fontSize)
        ratingsCountLbl.configureNameForCell(false, txtColor: defaultColor, fontSize: 15.0)
        handleText(0) { (rating) in
            self.ratingsCountLbl.text = "(\(rating))"
        }
        
        let height: CGFloat = ratingSmallSV.height
        ratingSmallSV.translatesAutoresizingMaskIntoConstraints = false
        ratingSmallSV.widthAnchor.constraint(equalToConstant: height*5).isActive = true
        ratingSmallSV.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        let views1: [UIView] = [originPriceLbl, currentPriceLbl]
        let sv1 = createdStackView(views1, spacing: 8.0, axis: .horizontal, distribution: .fill, alignment: .leading)
        
        let views2: [UIView] = [ratingSmallSV, ratingsCountLbl]
        let sv2 = createdStackView(views2, spacing: 8.0, axis: .horizontal, distribution: .fill, alignment: .center)
        
        let views3: [UIView] = [sv1, sv2]
        let sv3 = createdStackView(views3, spacing: 8, axis: .vertical, distribution: .fill, alignment: .leading)
        addSubview(sv3)
        sv3.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ShowMore
        let attributed = setupTitleAttri(viewAllTxt, txtColor: UIColor(hex: 0x2AB5EC), size: 14.0)
        viewAllBtn.setAttributedTitle(attributed, for: .normal)
        viewAllBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 0.0)
        viewAllBtn.contentVerticalAlignment = .bottom
        viewAllBtn.addTarget(self, action: #selector(viewAllDidTap), for: .touchUpInside)
        delegate = dl
        addSubview(viewAllBtn)
        viewAllBtn.translatesAutoresizingMaskIntoConstraints = false
        
        let showMoreW = estimatedText(viewAllBtn.titleLabel!.text!).width + 10.0
        heightConstraint = heightAnchor.constraint(equalToConstant: 95.0)
        heightConstraint.priority = UILayoutPriority.defaultLow
        NSLayoutConstraint.activate([
            heightConstraint,
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: sizeView.bottomAnchor),
            
            nameLbl.topAnchor.constraint(equalTo: topAnchor, constant: 5.0),
            nameLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            nameLbl.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10),
            
            sv3.topAnchor.constraint(equalTo: nameLbl.bottomAnchor, constant: 5.0),
            sv3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            sv3.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -showMoreW),
            sv3.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -5.0),
            
            viewAllBtn.bottomAnchor.constraint(equalTo: sv3.bottomAnchor, constant: 5.0),
            viewAllBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
        ])
    }
    
    @objc func viewAllDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleViewAllDidTap()
        }
    }
    
    func setupTextForLbl(_ pr: Product) {
        nameLbl.text = pr.name
        originPriceLbl.isHidden = pr.saleOff <= 0.0
        
        if pr.saleOff <= 0.0 {
            currentPriceLbl.text = pr.price.formattedWithCurrency
            
        } else {
            originPriceLbl.text = pr.price.formattedWithCurrency
            calculatesaleOff(pr.price, saleOff: pr.saleOff) { (currentPr) in
                self.currentPriceLbl.text = currentPr.formattedWithCurrency
            }
        }
    }
    
    func setupDarkMode(_ isDarkMode: Bool) {
        backgroundColor = isDarkMode ? .black : groupColor
        nameLbl.textColor = isDarkMode ? .lightGray : .gray
        originPriceLbl.textColor = isDarkMode ? .lightGray : .darkGray
        currentPriceLbl.textColor = isDarkMode ? .lightGray : .darkGray
        
        let attriC: UIColor = isDarkMode ? UIColor(hex: 0x2687FB) : UIColor(hex: 0x2AB5EC)
        let attributed = setupTitleAttri(viewAllTxt, txtColor: attriC, size: 14.0)
        viewAllBtn.setAttributedTitle(attributed, for: .normal)
    }
}
