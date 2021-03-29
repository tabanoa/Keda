//
//  CategoriesDetailHV.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol CategoriesDetailHVDelegate: class {
    func handleBackDidTap()
    func handleSearchDidTap()
}

class CategoriesDetailHV: UIView {
    
    //MARK: - Properties
    weak var delegate: CategoriesDetailHVDelegate?
    private let backBtn = UIButton()
    private let searchBtn = UIButton()
    private let imageView = UIImageView()
    private let titleLbl = UILabel()
    private let collectionLbl = UILabel()
    private var dimsBG = UIView()
    
    let shopLbl = UILabel()
    var stackView = UIStackView()
    
    var image: UIImage?
    var titleTxt = ""
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension CategoriesDetailHV {
    
    func setupHeaderView(_ view: UIView, dl: CategoriesDetailHVDelegate) {
        frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenWidth)
        view.addSubview(self)
        
        //TODO: - ImageView
        imageView.frame = bounds
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        addSubview(imageView)
        
        //TODO: - Dimming BG
        dimsBG = UIView(frame: bounds)
        dimsBG.backgroundColor = UIColor(hex: 0x000000, alpha: 0.7)
        dimsBG.clipsToBounds = true
        insertSubview(dimsBG, aboveSubview: imageView)
        
        //TODO: - TitleLbl
        titleLbl.configureNameForCell(false, txtColor: .white, fontSize: 30.0, isTxt: titleTxt, fontN: fontNamedBold)
        
        //TODO: - CollectionLbl
        let collTxt = NSLocalizedString("COLLECTION 2020", comment: "CategoriesDetailHV.swift: COLLECTION 2020")
        collectionLbl.configureNameForCell(false, txtColor: defaultColor, fontSize: 12.0, isTxt: collTxt, fontN: fontNamedBold)
        
        let views = [collectionLbl, titleLbl]
        stackView = createdStackView(views, spacing: 5.0, axis: .vertical, distribution: .fill, alignment: .leading)
        insertSubview(stackView, aboveSubview: dimsBG)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let constant = screenWidth*0.6
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(constant+10)),
        ])
        
        setupButton(view)
        delegate = dl
    }
    
    func setupButton(_ view: UIView) {
        setupBtn(backBtn, imgName: "icon-back", selector: #selector(backDidTap), view: view)
        setupBtn(searchBtn, imgName: "icon-search", selector: #selector(shareDidTap), view: view)
        
        //TODO - ShopLbl
        shopLbl.configureNameForCell(false, txtColor: .white, fontSize: 25.0, isTxt: "Rent", fontN: fontNamedBold)
        view.insertSubview(shopLbl, aboveSubview: self)
        shopLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let widthBtn: CGFloat = 45.0
        NSLayoutConstraint.activate([
            backBtn.widthAnchor.constraint(equalToConstant: widthBtn),
            backBtn.heightAnchor.constraint(equalToConstant: widthBtn),
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2.0),
            
            searchBtn.widthAnchor.constraint(equalToConstant: widthBtn),
            searchBtn.heightAnchor.constraint(equalToConstant: widthBtn),
            searchBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0),
            searchBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -1.0),
            
            shopLbl.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor),
            shopLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func setupBtn(_ btn: UIButton, imgName: String, selector: Selector, view: UIView) {
        btn.setImage(UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: selector, for: .touchUpInside)
        view.insertSubview(btn, aboveSubview: self)
        btn.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func backDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleBackDidTap()
        }
    }
    
    @objc func shareDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleSearchDidTap()
        }
    }
    
    func setupDarkMode(_ isDarkMode: Bool = false) {
        dimsBG.backgroundColor = UIColor(hex: 0x000000, alpha: isDarkMode ? 0.4 : 0.7)
    }
}
