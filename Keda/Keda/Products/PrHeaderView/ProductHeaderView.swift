//
//  ProductHeaderView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol ProductHeaderViewDelegate: class {
    func handleBackDidTap()
    func handleShareDidTap()
    func handleFavoriteDidTap(_ v: ProductHeaderView)
    func handleIMGDidTap()
}

class ProductHeaderView: UIView {
    
    //MARK: - Properties
    weak var delegate: ProductHeaderViewDelegate?
    private var productPageVC = ProductPageVC()
    private let percentLbl = UILabel()
    private let backBtn = UIButton()
    private let shareBtn = UIButton()
    private let imgBtn = UIButton()
    
    let favoriteBtn = UIButton()
    let pageControl = UIPageControl()
    var isFavorite = false
    
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

extension ProductHeaderView {
    
    func updateUI(_ vc: UIViewController, dl: ProductPageVCDelegate, view: UIView, pr: Product) {
        setupPageVC(vc, dl: dl, view: view, pr: pr)
        setupButton(view, pr: pr)
    }
    
    func setupPageVC(_ vc: UIViewController, dl: ProductPageVCDelegate, view: UIView, pr: Product) {
        //TODO: - PageViewController
        productPageVC = ProductPageVC(transitionStyle: .scroll,
                                      navigationOrientation: .horizontal,
                                      options: nil)
        
        productPageVC.imageLinks = pr.imageLinks
        vc.addChild(productPageVC)
        addSubview(productPageVC.view)
        productPageVC.kDelegate = dl
        productPageVC.didMove(toParent: vc)
        productPageVC.view.translatesAutoresizingMaskIntoConstraints = false

        //TODO: - PageControl
        pageControl.backgroundColor = .clear
        pageControl.currentPage = 0
        pageControl.numberOfPages = pr.imageLinks.count
        pageControl.currentPageIndicatorTintColor = .darkGray
        pageControl.pageIndicatorTintColor = .gray
        insertSubview(pageControl, aboveSubview: productPageVC.view)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productPageVC.view.topAnchor.constraint(equalTo: topAnchor),
            productPageVC.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            productPageVC.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            productPageVC.view.bottomAnchor.constraint(equalTo: bottomAnchor),

            pageControl.widthAnchor.constraint(equalToConstant: 39.0),
            pageControl.heightAnchor.constraint(equalToConstant: 37.0),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10.0)
        ])
    }
    
    func setupButton(_ view: UIView, pr: Product) {
        setupBtn(backBtn, imgName: "icon-back", selector: #selector(backDidTap), view: view)
        setupBtn(shareBtn, imgName: "icon-share", selector: #selector(shareDidTap), view: view)
        shareBtn.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
        shareBtn.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        
        let imgWidth: CGFloat = 30.0
        favoriteBtn.clipsToBounds = true
        favoriteBtn.layer.cornerRadius = imgWidth/2
        favoriteBtn.backgroundColor = groupColor
        favoriteBtn.setImage(UIImage(named: isFavorite ? "icon-favorite-filled" : "icon-favorite"), for: .normal)
        favoriteBtn.addTarget(self, action: #selector(favoriteDidTap), for: .touchUpInside)
        view.insertSubview(favoriteBtn, aboveSubview: self)
        favoriteBtn.translatesAutoresizingMaskIntoConstraints = false
        
        percentLbl.configurePercentForCell(view, bgColor: .black, hidden: pr.saleOff <= 0.0, fontSize: 13.0)
        percentLbl.clipsToBounds = true
        percentLbl.layer.cornerRadius = 3.0
        percentLbl.text = "-\(pr.saleOff.formattedWithDecimal)%"
        
        let percentW = estimatedText(percentLbl.text!).width + 8.0
        percentLbl.widthAnchor.constraint(equalToConstant: percentW).isActive = true
        percentLbl.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        imgBtn.clipsToBounds = true
        imgBtn.layer.cornerRadius = 5.0
        imgBtn.backgroundColor = .black
        imgBtn.setImage(UIImage(named: "icon-imgs"), for: .normal)
        imgBtn.addTarget(self, action: #selector(imgDidTap), for: .touchUpInside)
        imgBtn.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        view.insertSubview(imgBtn, aboveSubview: self)
        imgBtn.translatesAutoresizingMaskIntoConstraints = false
        imgBtn.widthAnchor.constraint(equalToConstant: imgWidth).isActive = true
        imgBtn.heightAnchor.constraint(equalToConstant: imgWidth).isActive = true
        
        let views = [shareBtn, percentLbl, imgBtn]
        let sv = createdStackView(views, spacing: 5.0, axis: .vertical, distribution: .fill, alignment: .trailing)
        view.insertSubview(sv, aboveSubview: self)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        let widthBtn: CGFloat = 45.0
        NSLayoutConstraint.activate([
            backBtn.widthAnchor.constraint(equalToConstant: widthBtn),
            backBtn.heightAnchor.constraint(equalToConstant: widthBtn),
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2.0),
            
            sv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0),
            sv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -1.0),
            
            favoriteBtn.widthAnchor.constraint(equalToConstant: imgWidth),
            favoriteBtn.heightAnchor.constraint(equalToConstant: imgWidth),
            favoriteBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            favoriteBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: appDl.iPhone5 ? 5.0 : 10.0),
        ])
    }
    
    func setupBtn(_ btn: UIButton, imgName: String, selector: Selector, view: UIView) {
        btn.setImage(UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .black
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
            self.delegate?.handleShareDidTap()
        }
    }
    
    @objc func favoriteDidTap(_ sender: UIButton) {
        self.delegate?.handleFavoriteDidTap(self)
    }
    
    @objc func imgDidTap() {
        delegate?.handleIMGDidTap()
    }
    
    func setupPercent(_ pr: Product) {
        percentLbl.text = "-\(pr.saleOff.formattedWithDecimal)%"
        percentLbl.isHidden = pr.saleOff <= 0.0
    }
    
    func setupDarkMode(_ isDarkMode: Bool) {
        favoriteBtn.backgroundColor = isDarkMode ? .black : groupColor
    }
}
