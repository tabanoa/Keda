//
//  CheckoutTopView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class CheckoutTopView: UIView {
    
    //MARK: - Properties
    private let titleLbl = UILabel()
    private let title = NSLocalizedString("CHECK OUT", comment: "CheckoutTopView.swift: CHECK OUT")
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension CheckoutTopView {
    
    func setupTopView(_ view: UIView, paymentV: PaymentView, vc: CheckoutVC) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleLbl
        titleLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 25.0, isTxt: title, fontN: fontNamedBold)
        titleLbl.sizeToFit()
        addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - PaymentView
        paymentV.checkoutVC = vc
        addSubview(paymentV)
        paymentV.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 100.0),
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLbl.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            titleLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            
            paymentV.heightAnchor.constraint(equalToConstant: 60.0),
            paymentV.leadingAnchor.constraint(equalTo: leadingAnchor),
            paymentV.trailingAnchor.constraint(equalTo: trailingAnchor),
            paymentV.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

//MARK: - DarkMode

extension CheckoutTopView {
    
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
        titleLbl.textColor = isDarkMode ? .white : .darkGray
    }
}
