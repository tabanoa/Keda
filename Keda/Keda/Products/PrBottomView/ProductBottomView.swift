//
//  ProductBottomView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import UIKit

protocol ProductBottomViewDelegate: class {
    func handleMsgDidTap()
    func handleBagDidTap()
}

class ProductBottomView: UIView {
    
    //MARK: - Properties
    weak var delegate: ProductBottomViewDelegate?
    private let bagBtn = ShowMoreBtn()
    private let msgBtn = ShowMoreBtn()
    
    private let msgTitle = NSLocalizedString("SEND MESSAGE", comment: "ProductBottomView.swift: SEND MESSAGE")
    private let bagTitle = NSLocalizedString("RENT", comment: "ProductBottomView.swift: RENT")
    
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

extension ProductBottomView {
    
    func setupBotomView(_ view: UIView, dl: ProductBottomViewDelegate) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - BagBtn
        setupBtn(bagBtn, title: bagTitle, bgColor: .white, selector: #selector(bagDidTap), textColor: .black)
        
        //TODO: - msgBtn
        setupBtn(msgBtn, title: msgTitle, bgColor: .black, selector: #selector(msgDidTap), textColor: .white)
        delegate = dl
        
        let width = (screenWidth-40)/2
        let height: CGFloat = 50.0
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 54.0),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2.0),
            
            bagBtn.widthAnchor.constraint(equalToConstant: width),
            bagBtn.heightAnchor.constraint(equalToConstant: height),
            bagBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2.0),
            bagBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            msgBtn.widthAnchor.constraint(equalToConstant: width),
            msgBtn.heightAnchor.constraint(equalToConstant: height),
            msgBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2.0),
            msgBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func setupBtn(_ btn: UIButton, title: String, bgColor: UIColor, selector: Selector, textColor: UIColor) {
        let attributed = setupTitleAttri(title, txtColor: textColor)
        btn.setAttributedTitle(attributed, for: .normal)
        btn.backgroundColor = bgColor
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5.0
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1.0
        btn.addTarget(self, action: selector, for: .touchUpInside)
        addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func msgDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            if #available(iOS 12.0, *) {
                switch self.traitCollection.userInterfaceStyle {
                case .light, .unspecified: self.darkModeMsg(sender)
                case .dark: self.darkModeMsg(sender, isDarkMode: true)
                default: break
                }
            } else {
                self.darkModeMsg(sender)
            }
            
            self.delegate?.handleMsgDidTap()
        }
    }
    
    private func darkModeMsg(_ sender: UIButton, isDarkMode: Bool = false) {
        let msgTxtC: UIColor = isDarkMode ? .black : .white
        let msgAttri = setupTitleAttri(msgTitle, txtColor: msgTxtC)
        sender.setAttributedTitle(msgAttri, for: .normal)
        sender.backgroundColor = isDarkMode ? .white : .black
        
        let bagTxtC: UIColor = isDarkMode ? .white : .black
        let bagAttri = setupTitleAttri(self.bagTitle, txtColor: bagTxtC)
        bagBtn.setAttributedTitle(bagAttri, for: .normal)
        bagBtn.backgroundColor = isDarkMode ? .black : .white
        bagBtn.layer.borderColor = bagTxtC.cgColor
    }
    
    @objc func bagDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            if #available(iOS 12.0, *) {
                switch self.traitCollection.userInterfaceStyle {
                case .light, .unspecified: self.darkModeBag(sender)
                case .dark: self.darkModeBag(sender, isDarkMode: true)
                default: break
                }
            } else {
                self.darkModeBag(sender)
            }
            
            self.delegate?.handleBagDidTap()
        }
    }
    
    private func darkModeBag(_ sender: UIButton, isDarkMode: Bool = false) {
        let bagTxtC: UIColor = isDarkMode ? .black : .white
        let bagAttri = setupTitleAttri(bagTitle, txtColor: bagTxtC)
        sender.setAttributedTitle(bagAttri, for: .normal)
        sender.backgroundColor = isDarkMode ? .white : .black
        
        let msgTxtC: UIColor = isDarkMode ? .white : .black
        let msgAttri = setupTitleAttri(msgTitle, txtColor: msgTxtC)
        msgBtn.setAttributedTitle(msgAttri, for: .normal)
        msgBtn.backgroundColor = isDarkMode ? .black : .white
        msgBtn.layer.borderColor = msgTxtC.cgColor
    }
    
    func setupDarkMode(_ isDarkMode: Bool) {
        let msgC: UIColor = isDarkMode ? .black : .white
        let bagC: UIColor = isDarkMode ? .white : .black
        let attriMsg = setupTitleAttri(msgTitle, txtColor: msgC)
        msgBtn.setAttributedTitle(attriMsg, for: .normal)
        msgBtn.backgroundColor = bagC
        
        let attriBag = setupTitleAttri(bagTitle, txtColor: bagC)
        bagBtn.setAttributedTitle(attriBag, for: .normal)
        bagBtn.backgroundColor = msgC
        bagBtn.layer.borderColor = bagC.cgColor
    }
}
