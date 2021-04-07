//
//  ShippingBottomView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol ShippingBottomViewDelegate: class {
    func handleUseThisAddressDidTap()
}

class ShippingBottomView: UIView {
    
    //MARK: - Properties
    weak var delegate: ShippingBottomViewDelegate?
    
    private let btn = ShowMoreBtn()
    private let txt = NSLocalizedString("Use This Address", comment: "ShippingBottomView.swift: Use This Address")
    
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

extension ShippingBottomView {
    
    func setupBottomView(_ view: UIView, dl: ShippingBottomViewDelegate) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Btn
        let attributed = setupTitleAttri(txt, size: 17.0)
        btn.setAttributedTitle(attributed, for: .normal)
        btn.backgroundColor = .black
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5.0
        btn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        btn.addTarget(self, action: #selector(useThisAddressDidTap), for: .touchUpInside)
        addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        delegate = dl
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60.0),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            btn.topAnchor.constraint(equalTo: topAnchor, constant: 5.0),
            btn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0),
            btn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.0),
            btn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.0),
        ])
        
        setupDarkMode()
    }
    
    @objc func useThisAddressDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleUseThisAddressDidTap()
        }
    }
}

//MARK: - DarkMode

extension ShippingBottomView {
    
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
        btn.setAttributedTitle(attributed, for: .normal)
        btn.backgroundColor = isDarkMode ? .white : .black
    }
}
