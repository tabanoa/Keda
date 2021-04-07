//
//  NewUserOnboardingCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class NewUserOnboardingCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "NewUserOnboardingCVCell"
    
    let bgIMGView = UIImageView()
    let imgView = UIImageView()
    let titleLbl = UILabel()
    let contentLbl = UILabel()
    let fontC = UIColor(hex: 0x2c313b)
    
    var newUser: NewUser! {
        didSet {
            imgView.image = newUser.image.withRenderingMode(.alwaysTemplate)
            imgView.tintColor = fontC
            imgView.alpha = 0.05
            titleLbl.text = newUser.title
            
            contentLbl.isHidden = newUser.content == ""
            contentLbl.text = newUser.content
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
}

//MARK: - Configure

extension NewUserOnboardingCVCell {
    
    func configureCell() {
        backgroundColor = .clear
        
        let fontS: CGFloat = 35.0
        titleLbl.configureNameForCell(false, line: 0, txtColor: fontC, fontSize: fontS, isTxt: "", fontN: fontLinhBold)
        contentLbl.configureNameForCell(false, line: 0, txtColor: fontC, fontSize: 17.0, isTxt: "", fontN: fontLinhLight)
        titleLbl.textAlignment = .center
        contentLbl.textAlignment = .center
        
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        contentView.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [titleLbl, contentLbl]
        let sv = createdStackView(views, spacing: 30.0, axis: .vertical, distribution: .fill, alignment: .center)
        contentView.insertSubview(sv, aboveSubview: imgView)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        let imgW: CGFloat = screenWidth*0.5
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalToConstant: imgW),
            imgView.heightAnchor.constraint(equalToConstant: imgW),
            imgView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            sv.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sv.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sv.leadingAnchor.constraint(lessThanOrEqualTo: contentView.leadingAnchor, constant: 50.0),
            sv.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -50.0),
        ])
    }
}
