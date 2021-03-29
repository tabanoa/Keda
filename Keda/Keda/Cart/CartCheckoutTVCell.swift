//
//  CartCheckoutTVCell.swift
// Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol CartCheckoutTVCellDelegate: class {
    func handleCheckout()
}

class CartCheckoutTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CartCheckoutTVCell"
    weak var delegate: CartCheckoutTVCellDelegate?
    
    let checkoutBtn = ShowMoreBtn()
    var txt = NSLocalizedString("RENT NOW", comment: "CartCheckoutTVCell.swift: RENT NOW")
    
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

extension CartCheckoutTVCell {
    
    func configureCell() {
        backgroundColor = .clear
        
        let attributed = setupTitleAttri(txt, size: 17.0)
        checkoutBtn.setAttributedTitle(attributed, for: .normal)
        checkoutBtn.backgroundColor = .black
        checkoutBtn.clipsToBounds = true
        checkoutBtn.layer.cornerRadius = 8.0
        
        checkoutBtn.layer.masksToBounds = false
        checkoutBtn.layer.shadowColor = UIColor.black.cgColor
        checkoutBtn.layer.shadowOffset = CGSize(width: -1.0, height: 1.0)
        checkoutBtn.layer.shadowRadius = 3.0
        checkoutBtn.layer.shadowOpacity = 0.3
        checkoutBtn.layer.shouldRasterize = true
        checkoutBtn.layer.rasterizationScale = UIScreen.main.scale
        
        checkoutBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        checkoutBtn.addTarget(self, action: #selector(checkoutDidTap), for: .touchUpInside)
        contentView.addSubview(checkoutBtn)
        checkoutBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkoutBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            checkoutBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            checkoutBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
            checkoutBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
        ])
        
        setupDarkMode()
    }
    
    @objc func checkoutDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleCheckout()
        }
    }
}

//MARK: - DarkMode

extension CartCheckoutTVCell {
    
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
        let attC: UIColor = isDarkMode ? .black : .white
        let attributed = setupTitleAttri(txt, txtColor: attC, size: 17.0)
        checkoutBtn.setAttributedTitle(attributed, for: .normal)
        checkoutBtn.backgroundColor = isDarkMode ? .white : .black
    }
}
