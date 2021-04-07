//
//  ProductsListTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol ProductsListTVCellDelegate: class {
    func handleActiveDidTap(_ cell: ProductsListTVCell)
}

class ProductsListTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "ProductsListTVCell"
    
    weak var delegate: ProductsListTVCellDelegate?
    var imgView = UIImageView()
    var nameLbl = UILabel()
    var activeBtn = UIButton()
    
    var product: Product! {
        didSet {
            nameLbl.text = product.name
            activeBtn.isHidden = product.active
            
            let notActTxt = NSLocalizedString("NOT ACTIVE", comment: "ProductsListTVCell.swift: NOT ACTIVE")
            let txt = product.active ? "" : notActTxt
            let attributed = setupTitleAttri(txt, size: 13.0)
            activeBtn.setAttributedTitle(attributed, for: .normal)
            
            Product.downloadImage(from: product.imageLink) { (image) in
                DispatchQueue.main.async {
                    self.imgView.image = image
                }
            }
        }
    }
    
    //MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let bgColor = activeBtn.backgroundColor
        super.setSelected(selected, animated: animated)
        activeBtn.backgroundColor = bgColor
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let bgColor = activeBtn.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        activeBtn.backgroundColor = bgColor
    }
}

//MARK: - Configures

extension ProductsListTVCell {
    
    func configureCell() {
        //ImageView
        let imgHeight: CGFloat = 50.0
        imgView.configureIMGViewForCell(contentView, imgName: "a1", ctMore: .scaleAspectFit)
        imgView.layer.cornerRadius = 3.0
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        imgView.layer.borderWidth = 0.5
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.widthAnchor.constraint(equalToConstant: imgHeight).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: imgHeight).isActive = true
        
        nameLbl.configureNameForCell(false, line: 2, txtColor: .darkGray, fontSize: 15.0, isTxt: "Designed By Keda Team", fontN: fontNamed)
        
        //StackView 2
        let views = [imgView, nameLbl]
        let sv = createdStackView(views, spacing: 8.0, axis: .horizontal, distribution: .fill, alignment: .center)
        contentView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ActiveBtn
        let attributed = setupTitleAttri("", size: 13.0)
        activeBtn.setAttributedTitle(attributed, for: .normal)
        activeBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        activeBtn.backgroundColor = UIColor(hex: 0xF33D30)
        activeBtn.clipsToBounds = true
        activeBtn.layer.cornerRadius = 3.0
        activeBtn.addTarget(self, action: #selector(activeDidTap), for: .touchUpInside)
        contentView.addSubview(activeBtn)
        activeBtn.translatesAutoresizingMaskIntoConstraints = false
        activeBtn.sizeToFit()
        
        let deleteW: CGFloat = activeBtn.frame.size.width
        let trailing: CGFloat = (screenWidth - deleteW)/2.0
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            sv.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sv.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -trailing),
            
            activeBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            activeBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
        ])
        
        setupDarkMode()
    }
    
    @objc func activeDidTap(_ sender: UIButton) {
        guard let delegate = delegate else { return }
        touchAnim(sender) {
            delegate.handleActiveDidTap(self)
        }
    }
}

//MARK: - DarkMode

extension ProductsListTVCell {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    private func setupDarkMode() {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupDMView()
            case .dark: setupDMView(true)
            default: break
            }
        } else {
            setupDMView()
        }
    }
    
    private func setupDMView(_ isDarkMode: Bool = false) {
        nameLbl.textColor = isDarkMode ? .lightGray : .darkGray
        
        let lightC = UIColor(hex: 0xE5E5E5, alpha: 0.7)
        let darkC = UIColor(hex: 0x3A3A3A, alpha: 0.5)
        let selectC: UIColor = isDarkMode ? darkC : lightC
        setupSelectedCell(selectC: selectC) { (selectedView) in
            self.selectedBackgroundView = selectedView
        }
    }
}
