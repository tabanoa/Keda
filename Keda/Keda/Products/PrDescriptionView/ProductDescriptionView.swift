//
//  ProductDescriptionView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol ProductDescriptionViewDelegate: class {
    func handleShowMoreDidTap(_ lbl: UILabel)
}

class ProductDescriptionView: UIView {
    
    //MARK: - Properties
    weak var delegate: ProductDescriptionViewDelegate?
    let descriptionLbl = UILabel()
    
    private let readMoreBtn = ShowMoreBtn()
    private let btnTxt = NSLocalizedString("Show More", comment: "ProductDescriptionView.swift: Show More")
    
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

extension ProductDescriptionView {
    
    func setupDescriptionView(_ view: UIView, contentV: UIView, bottomV: UIView, dl: ProductDescriptionViewDelegate, pr: Product) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Name
        descriptionLbl.configureNameForCell(false, line: 0, txtColor: .gray, fontSize: 15.0, isTxt: pr.description, fontN: fontNamed)
        descriptionLbl.lineBreakMode = .byTruncatingTail
        addSubview(descriptionLbl)
        descriptionLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let attributed = setupTitleAttri(btnTxt, txtColor: UIColor(hex: 0x2AB5EC), size: 14.0)
        readMoreBtn.setAttributedTitle(attributed, for: .normal)
        readMoreBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 0.0)
        readMoreBtn.contentVerticalAlignment = .bottom
        readMoreBtn.addTarget(self, action: #selector(readMoreDidTap), for: .touchUpInside)
        view.addSubview(readMoreBtn)
        readMoreBtn.translatesAutoresizingMaskIntoConstraints = false
        delegate = dl
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: contentV.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: bottomV.topAnchor, constant: -35.0),
            
            descriptionLbl.topAnchor.constraint(equalTo: topAnchor, constant: 5.0),
            descriptionLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            descriptionLbl.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10.0),
            descriptionLbl.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -5.0),
            
            readMoreBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
            readMoreBtn.bottomAnchor.constraint(equalTo: bottomV.topAnchor, constant: -5.0),
        ])
    }
    
    @objc func readMoreDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleShowMoreDidTap(self.descriptionLbl)
        }
    }
    
    func setupDesLbl(_ pr: Product) {
        descriptionLbl.text = pr.description
    }
    
    func setupDarkMode(_ isDarkMode: Bool) {
        backgroundColor = isDarkMode ? .black : groupColor
        descriptionLbl.textColor = isDarkMode ? .lightGray : .gray
        
        let attriC: UIColor = isDarkMode ? UIColor(hex: 0x2687FB) : UIColor(hex: 0x2AB5EC)
        let attributed = setupTitleAttri(btnTxt, txtColor: attriC, size: 14.0)
        readMoreBtn.setAttributedTitle(attributed, for: .normal)
    }
}
