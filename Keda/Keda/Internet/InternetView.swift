//
//  InternetView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol InternetViewDelegate: class {
    func handleReload()
}

class InternetView: UIView {
    
    //MARK: - Properties
    private let wifiImgView = UIImageView()
    private let notificationLbl = UILabel()
    private let reloadBtn = UIButton()
    weak var delegate: InternetViewDelegate?
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension InternetView {
    
    func setupInternetView(_ view: UIView, dl: InternetViewDelegate) {
        frame = view.bounds
        delegate = dl
        view.addSubview(self)
    }
    
    func updateUI() {
        backgroundColor = .white
        
        //TODO: - ImageView
        let iconW: CGFloat = 150.0
        wifiImgView.clipsToBounds = true
        wifiImgView.contentMode = .scaleAspectFit
        wifiImgView.image = UIImage(named: "icon-wifi-unavailable")?.withRenderingMode(.alwaysTemplate)
        wifiImgView.tintColor = UIColor(hex: 0xCDCDCD)
        wifiImgView.translatesAutoresizingMaskIntoConstraints = false
        wifiImgView.widthAnchor.constraint(equalToConstant: iconW).isActive = true
        wifiImgView.heightAnchor.constraint(equalToConstant: iconW).isActive = true
        
        //TODO: - NotificationLbl
        let txt = NSLocalizedString("Internet Not Available", comment: "InternetView.swift: Internet Not Available")
        notificationLbl.configureNameForCell(false, txtColor: UIColor(hex: 0xCDCDCD), fontSize: 17.0, isTxt: txt, fontN: fontNamed)
        notificationLbl.textAlignment = .center
        
        //TODO: - ReloadBtn
        reloadBtn.setImage(UIImage(named: "icon-reload")?.withRenderingMode(.alwaysTemplate), for: .normal)
        reloadBtn.tintColor = .white
        reloadBtn.backgroundColor = .black
        reloadBtn.clipsToBounds = true
        reloadBtn.layer.cornerRadius = 5.0
        reloadBtn.addTarget(self, action: #selector(reloadDidTap), for: .touchUpInside)
        reloadBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        reloadBtn.translatesAutoresizingMaskIntoConstraints = false
        reloadBtn.widthAnchor.constraint(equalToConstant: 130.0).isActive = true
        reloadBtn.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        let views1 = [notificationLbl, reloadBtn]
        let sv1 = createdStackView(views1, spacing: 20.0, axis: .vertical, distribution: .fill, alignment: .center)
        
        let views2 = [wifiImgView, sv1]
        let sv2 = createdStackView(views2, spacing: 0.0, axis: .vertical, distribution: .fill, alignment: .center)
        addSubview(sv2)
        sv2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sv2.centerXAnchor.constraint(equalTo: centerXAnchor),
            sv2.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100.0),
        ])
    }
    
    @objc func reloadDidTap() {
        delegate?.handleReload()
    }
    
    func setupInternetAvailable(_ parentView: UIView, dl: InternetViewDelegate, kHidden: Bool, completion: (() -> ())?) {
        guard isInternetAvailable() else {
            frame = parentView.bounds
            isHidden = kHidden
            delegate = dl
            parentView.addSubview(self)
            return
        }
        
        completion?()
    }
    
    func setupDarkMode(_ isDarkMode: Bool = false) {
        let color = UIColor(hex: 0xCDCDCD)
        backgroundColor = isDarkMode ? .black : .white
        notificationLbl.textColor = isDarkMode ? .white : color
        wifiImgView.tintColor = isDarkMode ? .white : color
        reloadBtn.tintColor = isDarkMode ? .black : .white
        reloadBtn.backgroundColor = isDarkMode ? .white : .black
    }
}
