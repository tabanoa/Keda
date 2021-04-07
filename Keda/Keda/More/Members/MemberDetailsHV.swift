//
//  MemberDetailsHV.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class MemberDetailsHV: UIView {
    
    //MARK: - Properties
    let avatarImgView = UIImageView()
    private let nameLbl = UILabel()
    let prefixLbl = UILabel()
    
    let boughtLbl = UILabel()
    private let boughtTitleLbl = UILabel()
    
    let wishlistLbl = UILabel()
    private let wishlistTitleLbl = UILabel()
    
    private let fView = UIView()
    private let boughtView = UIView()
    private let wishlistView = UIView()
    private let separatorView = UIView()
    
    var avatarImg: UIImage?
    
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

extension MemberDetailsHV {
    
    func setupHeaderView(_ tableView: UITableView) {
        let headerH: CGFloat = 10+130+20+36+20+screenWidth*0.3
        frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: headerH)
        tableView.tableHeaderView = self
        
        //TODO: - Avatar
        let avatarW: CGFloat = 130.0
        avatarImgView.contentMode = .scaleAspectFill
        avatarImgView.clipsToBounds = true
        avatarImgView.layer.cornerRadius = avatarW/2.0
        avatarImgView.image = avatarImg
        addSubview(avatarImgView)
        avatarImgView.translatesAutoresizingMaskIntoConstraints = false

        //TODO: - NameLbl
        nameLbl.configureNameForCell(false, txtColor: .black, fontSize: 30.0, isTxt: "Keda Team", fontN: fontNamedBold)
        addSubview(nameLbl)
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - FlowView
        fView.backgroundColor = .white
        addSubview(fView)
        fView.translatesAutoresizingMaskIntoConstraints = false
        
        separatorView.backgroundColor = UIColor(hex: 0xE5E5E5, alpha: 0.7)
        fView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        boughtView.backgroundColor = .clear
        fView.addSubview(boughtView)
        boughtView.translatesAutoresizingMaskIntoConstraints = false
        
        wishlistView.backgroundColor = .clear
        fView.addSubview(wishlistView)
        wishlistView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - FlowLbl
        let boughtTxt = NSLocalizedString("Bought", comment: "MemberDetailsHV.swift: Bought")
        
        let wishlistTxt = "Wishlist"
        boughtLbl.configureNameForCell(false, txtColor: .black, fontSize: 23.0, isTxt: "0", fontN: fontNamedBold)
        boughtTitleLbl.configureNameForCell(false, txtColor: .black, fontSize: 15.0, isTxt: boughtTxt, fontN: fontNamed)
        wishlistLbl.configureNameForCell(false, txtColor: .black, fontSize: 23.0, isTxt: "0", fontN: fontNamedBold)
        wishlistTitleLbl.configureNameForCell(false, txtColor: .black, fontSize: 15.0, isTxt: wishlistTxt, fontN: fontNamed)
        
        let views1 = [boughtLbl, boughtTitleLbl]
        let sv1 = createdStackView(views1, spacing: 5.0, axis: .vertical, distribution: .fill, alignment: .center)
        boughtView.addSubview(sv1)
        sv1.translatesAutoresizingMaskIntoConstraints = false
        
        let views2 = [wishlistLbl, wishlistTitleLbl]
        let sv2 = createdStackView(views2, spacing: 5.0, axis: .vertical, distribution: .fill, alignment: .center)
        wishlistView.addSubview(sv2)
        sv2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImgView.widthAnchor.constraint(equalToConstant: avatarW),
            avatarImgView.heightAnchor.constraint(equalToConstant: avatarW),
            avatarImgView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            avatarImgView.centerXAnchor.constraint(equalTo: centerXAnchor),

            nameLbl.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLbl.topAnchor.constraint(equalTo: avatarImgView.bottomAnchor, constant: 20.0),
            
            fView.heightAnchor.constraint(equalToConstant: screenWidth*0.3),
            fView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fView.trailingAnchor.constraint(equalTo: trailingAnchor),
            fView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            separatorView.widthAnchor.constraint(equalToConstant: 1.0),
            separatorView.topAnchor.constraint(equalTo: fView.topAnchor, constant: 20.0),
            separatorView.bottomAnchor.constraint(equalTo: fView.bottomAnchor, constant: -20.0),
            separatorView.centerXAnchor.constraint(equalTo: fView.centerXAnchor),
            
            boughtView.widthAnchor.constraint(equalToConstant: (screenWidth-0.5)/2),
            boughtView.topAnchor.constraint(equalTo: fView.topAnchor),
            boughtView.leadingAnchor.constraint(equalTo: fView.leadingAnchor),
            boughtView.bottomAnchor.constraint(equalTo: fView.bottomAnchor),
            
            wishlistView.widthAnchor.constraint(equalToConstant: (screenWidth-0.5)/2),
            wishlistView.topAnchor.constraint(equalTo: fView.topAnchor),
            wishlistView.trailingAnchor.constraint(equalTo: fView.trailingAnchor),
            wishlistView.bottomAnchor.constraint(equalTo: fView.bottomAnchor),
            
            sv1.centerXAnchor.constraint(equalTo: boughtView.centerXAnchor),
            sv1.centerYAnchor.constraint(equalTo: boughtView.centerYAnchor),
            sv1.leadingAnchor.constraint(lessThanOrEqualTo: boughtView.leadingAnchor, constant: 10.0),
            sv1.trailingAnchor.constraint(lessThanOrEqualTo: boughtView.trailingAnchor, constant: -10.0),
            
            sv2.centerXAnchor.constraint(equalTo: wishlistView.centerXAnchor),
            sv2.centerYAnchor.constraint(equalTo: wishlistView.centerYAnchor),
            sv2.leadingAnchor.constraint(lessThanOrEqualTo: wishlistView.leadingAnchor, constant: 10.0),
            sv2.trailingAnchor.constraint(lessThanOrEqualTo: wishlistView.trailingAnchor, constant: -10.0),
        ])
        
        //TODO: - PrefixLbl
        let prefix = "\(nameLbl.text!.prefix(1))"
        prefixLbl.configureNameForCell(true, txtColor: .white, fontSize: 40.0, isTxt: prefix)
        insertSubview(prefixLbl, aboveSubview: avatarImgView)
        prefixLbl.translatesAutoresizingMaskIntoConstraints = false
        prefixLbl.centerXAnchor.constraint(equalTo: avatarImgView.centerXAnchor).isActive = true
        prefixLbl.centerYAnchor.constraint(equalTo: avatarImgView.centerYAnchor).isActive = true

        if avatarImgView.image == nil {
            avatarImgView.backgroundColor = UIColor(hex: 0xDEDEDE)
            prefixLbl.isHidden = false
        }
    }
    
    func setupDarkMode(_ isDarkMode: Bool) {
        nameLbl.textColor = isDarkMode ? .white : .black
        fView.backgroundColor = isDarkMode ? .black : .white
        boughtLbl.textColor = isDarkMode ? .white : .black
        boughtTitleLbl.textColor = isDarkMode ? .white : .black
        wishlistLbl.textColor = isDarkMode ? .white : .black
        wishlistTitleLbl.textColor = isDarkMode ? .white : .black
    }
}
