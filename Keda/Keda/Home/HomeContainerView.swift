//
//  HomeContainerView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol HomeContainerViewDelegate: class {
    func handleArrivalsDidTap()
    func handleFeaturedDidTap()
    func handleSellersDidTap()
    func handleFacebookDidTap()
    func handleTwitterDidTap()
}

class HomeContainerView: UIView {
    
    //MARK: - Properties
    weak var delegate: HomeContainerViewDelegate?
    let categoriesView = CategoriesView()
    let arrivalsView = ArrivalsView()
    let featuredView = FeaturedView()
    let sellersView = SellersView()
    private let contactsView = UIView()
    
    private let arrHeaderV = UIView()
    private let arrFooterV = UIView()
    private let arrHeaderLbl = UILabel()
    private let arrFooterBtn = ShowMoreBtn()
    
    private let feaHeaderV = UIView()
    private let feaFooterV = UIView()
    private let feaHeaderLbl = UILabel()
    private let feaFooterBtn = ShowMoreBtn()
    
    private let sellHeaderV = UIView()
    private let sellFooterV = UIView()
    private let sellHeaderLbl = UILabel()
    private let sellFooterBtn = ShowMoreBtn()
    
    private let iconFB = UIImageView()
    private let iconTW = UIImageView()
    private let fbBtn = ShowMoreBtn()
    private let twBtn = ShowMoreBtn()
    
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

extension HomeContainerView {
    
    func setupContView(categDl: CategoriesViewDelegate, arrDl: ArrivalsViewDelegate, feaDl: FeaturedViewDelegate, sellDl: SellersViewDelegate, dl: HomeContainerViewDelegate, topH: CGFloat, homeVC: HomeVC) {
        handleView(categoriesView) //CategoriesView
        categoriesView.delegate = categDl
        categoriesView.homeVC = homeVC
        
        handleView(arrHeaderV) //Arrivals-HeaderView
        handleView(arrivalsView) //ArrivalsView
        handleView(arrFooterV) //Arrivals-FooterView
        arrivalsView.delegate = arrDl
        
        handleView(feaHeaderV) //Featured-HeaderView
        handleView(featuredView) //FeaturedView
        handleView(feaFooterV) //Featured-FooterView
        featuredView.delegate = feaDl
        
        handleView(sellHeaderV) //Seller-HeaderView
        handleView(sellersView) //SellerView
        handleView(sellFooterV) //Seller-FooterView
        sellersView.delegate = sellDl
        
        handleView(contactsView, bgColor: UIColor(hex: 0xF3F3F3)) //contactView
        
        let viewW2 = screenWidth/3
        let sellerW = screenWidth + viewW2
        NSLayoutConstraint.activate([
            //TODO: - Categories
            categoriesView.heightAnchor.constraint(equalToConstant: topH),
            categoriesView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            
            //TODO: - Arrivals
            arrHeaderV.heightAnchor.constraint(equalToConstant: 30.0),
            arrHeaderV.topAnchor.constraint(equalTo: categoriesView.bottomAnchor, constant: 10.0),
            
            arrivalsView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0),
            arrivalsView.topAnchor.constraint(equalTo: arrHeaderV.bottomAnchor),
            
            arrFooterV.heightAnchor.constraint(equalToConstant: 40.0),
            arrFooterV.topAnchor.constraint(equalTo: arrivalsView.bottomAnchor),
            
            //TODO: - Featured
            feaHeaderV.heightAnchor.constraint(equalToConstant: 30.0),
            feaHeaderV.topAnchor.constraint(equalTo: arrFooterV.bottomAnchor, constant: 10.0),
            
            featuredView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0),
            featuredView.topAnchor.constraint(equalTo: feaHeaderV.bottomAnchor, constant: 10.0),
            
            feaFooterV.heightAnchor.constraint(equalToConstant: 40.0),
            feaFooterV.topAnchor.constraint(equalTo: featuredView.bottomAnchor),
            
            //TODO: - Sellers
            sellHeaderV.heightAnchor.constraint(equalToConstant: 30.0),
            sellHeaderV.topAnchor.constraint(equalTo: feaFooterV.bottomAnchor, constant: 10.0),
            
            sellersView.heightAnchor.constraint(equalToConstant: sellerW),
            sellersView.topAnchor.constraint(equalTo: sellHeaderV.bottomAnchor, constant: 10.0),
            
            sellFooterV.heightAnchor.constraint(equalToConstant: 40.0),
            sellFooterV.topAnchor.constraint(equalTo: sellersView.bottomAnchor),
            
            //TODO: - Contacts
            contactsView.heightAnchor.constraint(equalToConstant: 60.0),
            contactsView.topAnchor.constraint(equalTo: sellFooterV.bottomAnchor, constant: 10.0),
        ])
        
        setupHeaderFooterArrivals()
        setuContacts()
        delegate = dl
    }
    
    func setupHeaderFooterArrivals() {
        //TODO: - Arrivals
        let arrLblTitle = NSLocalizedString("New Arrivals", comment: "HomeContainerView.swift: New Arrivals")
        
        handleLbl(arrHeaderLbl, view: arrHeaderV, title: arrLblTitle)
        handleBtn(arrFooterBtn, view: arrFooterV, selector: #selector(arrShowMore))
        handleConstraint(arrHeaderLbl, btn: arrFooterBtn, headerV: arrHeaderV, footerV: arrFooterV)
        
        //TODO: - Featured
        let feaLblTitle = NSLocalizedString("Featured", comment: "HomeContainerView.swift: Featured")
        handleLbl(feaHeaderLbl, view: feaHeaderV, title: feaLblTitle)
        handleBtn(feaFooterBtn, view: feaFooterV, selector: #selector(feaShowMore))
        handleConstraint(feaHeaderLbl, btn: feaFooterBtn, headerV: feaHeaderV, footerV: feaFooterV)
        
        //TODO: - Best Seller
        let sellLblTitle = NSLocalizedString("Best Seller", comment: "HomeContainerView.swift: Best Seller")
        handleLbl(sellHeaderLbl, view: sellHeaderV, title: sellLblTitle)
        handleBtn(sellFooterBtn, view: sellFooterV, selector: #selector(sellShowMore))
        handleConstraint(sellHeaderLbl, btn: sellFooterBtn, headerV: sellHeaderV, footerV: sellFooterV)
    }
    
    func handleView(_ view: UIView, bgColor: UIColor = .clear) {
        view.backgroundColor = bgColor
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    @objc func arrShowMore(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleArrivalsDidTap()
        }
    }
    
    @objc func feaShowMore(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleFeaturedDidTap()
        }
    }
    
    @objc func sellShowMore(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleSellersDidTap()
        }
    }
    
    func handleLbl(_ lbl: UILabel, view: UIView, title: String) {
        lbl.text = title
        lbl.font = UIFont(name: fontNamedBold, size: 17.0)
        lbl.textAlignment = .center
        view.addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func handleBtn(_ btn: UIButton, view: UIView, selector: Selector) {
        setupDMShowMoreBtn(btn, txtC: .white, bgC: .black)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 3.0
        btn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        view.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func handleConstraint(_ lbl: UILabel, btn: UIButton, headerV: UIView, footerV: UIView) {
        NSLayoutConstraint.activate([
            lbl.centerYAnchor.constraint(equalTo: headerV.centerYAnchor),
            lbl.leadingAnchor.constraint(equalTo: headerV.leadingAnchor, constant: 2.0),
            
            btn.widthAnchor.constraint(equalToConstant: 130.0),
            btn.heightAnchor.constraint(equalToConstant: 30.0),
            btn.centerXAnchor.constraint(equalTo: footerV.centerXAnchor),
            btn.centerYAnchor.constraint(equalTo: footerV.centerYAnchor),
        ])
    }
    
    func setuContacts() {
        setupContactImg(iconFB, imgName: "icon-fb")
        setupContactBtn(fbBtn, selector: #selector(fbDidTap), title: "KedaApp")
        
        setupContactImg(iconTW, imgName: "icon-tw")
        setupContactBtn(twBtn, selector: #selector(twDidTap), title: "@KedaApp")
        
        let fbSV = createdStackView([iconFB, fbBtn], spacing: 0.0, axis: .horizontal, distribution: .fillProportionally, alignment: .center)
        let twSV = createdStackView([iconTW, twBtn], spacing: 0.0, axis: .horizontal, distribution: .fillProportionally, alignment: .center)
        let sv = createdStackView([fbSV, twSV], spacing: 5.0, axis: .vertical, distribution: .fill, alignment: .trailing)
        contactsView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: contactsView.leadingAnchor, constant: 8.0),
            sv.trailingAnchor.constraint(lessThanOrEqualTo: contactsView.trailingAnchor, constant: -8.0),
            sv.bottomAnchor.constraint(equalTo: contactsView.bottomAnchor, constant: -8.0),
        ])
    }
    
    func setupContactImg(_ imgV: UIImageView, imgName: String) {
        imgV.clipsToBounds = true
        imgV.contentMode = .scaleAspectFit
        imgV.image = UIImage(named: imgName)
        imgV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imgV.widthAnchor.constraint(equalToConstant: 20.0),
            imgV.heightAnchor.constraint(equalToConstant: 20.0),
        ])
    }
    
    func setupContactBtn(_ btn: UIButton, selector: Selector, title: String) {
        let attributed = setupTitleAttri(title, txtColor: UIColor(hex: 0x505050), size: 12.0)
        btn.setAttributedTitle(attributed, for: .normal)
        btn.contentHorizontalAlignment = .leading
        btn.contentEdgeInsets = UIEdgeInsets(top: 1.0, left: 3.0, bottom: 1.0, right: 3.0)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
    }
    
    @objc func fbDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleFacebookDidTap()
        }
    }
    
    @objc func twDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleTwitterDidTap()
        }
    }
}

//MARK: - Dark Mode

extension HomeContainerView {
    
    func darkModeViewBtn(_ isDarkMode: Bool = false) {
        let txtColor: UIColor = isDarkMode ? .black : .white
        let bgColor: UIColor = isDarkMode ? .white : .black
        setupDMShowMoreBtn(arrFooterBtn, txtC: txtColor, bgC: bgColor)
        setupDMShowMoreBtn(feaFooterBtn, txtC: txtColor, bgC: bgColor)
        setupDMShowMoreBtn(sellFooterBtn, txtC: txtColor, bgC: bgColor)
    }
    
    func darkModeContactBtn(_ isDarkMode: Bool = false) {
        let bgColor: UIColor = isDarkMode ? UIColor(hex: 0x232323) : UIColor(hex: 0xF3F3F3)
        let tintColor: UIColor = isDarkMode ? .lightGray : UIColor(hex: 0x505050)
        contactsView.backgroundColor = bgColor
        
        setupDMContactBtn(fbBtn, txtC: tintColor, title: "Keda")
        setupDMContactBtn(twBtn, txtC: tintColor, title: "@KedaApp")
        
        setupDMContactImg(iconFB, imgName: "icon-fb", tintC: tintColor)
        setupDMContactImg(iconTW, imgName: "icon-tw", tintC: tintColor)
    }
    
    private func setupDMContactBtn(_ btn: UIButton, txtC: UIColor, title: String) {
        let attributed = setupTitleAttri(title, txtColor: txtC, size: 12.0)
        btn.setAttributedTitle(attributed, for: .normal)
    }
    
    private func setupDMContactImg(_ imgV: UIImageView, imgName: String, tintC: UIColor) {
        imgV.image = UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate)
        imgV.tintColor = tintC
    }
    
    private func setupDMShowMoreBtn(_ btn: UIButton, txtC: UIColor, bgC: UIColor) {
        let showMoreTxt = NSLocalizedString("Show More", comment: "HomeContainerView.swift: Show More")
        let attributed = setupTitleAttri(showMoreTxt, txtColor: txtC)
        btn.setAttributedTitle(attributed, for: .normal)
        btn.backgroundColor = bgC
    }
}
