//
//  TabBarController.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol TabBarControllerDelegate: class {
    func handleSelectIndex(_ isTwo: Bool)
}

class TabBarController: UITabBarController {
    
    //MARK: - Properties
    let homeVC = HomeVC()
    let wishlistVC = WishlistVC()
    let shopVC = ShopVC()
    let cartVC = CartVC()
    let productsListVC = ProductsListVC()
    let moreVC = MoreVC()
    let myTabBar = CustomizedTabBar()
    
    weak var kDelegate: TabBarControllerDelegate?
    var isSelect = false
    
    private var isAdmin = false
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        guard isLogIn() else {
            self.updateUI()
            self.setupMiddleBtn()
            return
        }
        
        User.fetchCurrentUser { (user) in
            self.isAdmin = user.type == "admin"
            self.updateUI(self.isAdmin)
            self.setupMiddleBtn()
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let height = tabBar.frame.height - 10.0
        let size = CGSize(width: height, height: height)
        tabBar.selectionIndicatorImage = UIImage.imgWithColor(UIColor(hex: 0xE5E5E5, alpha: 0.7), with: size)

        guard let index = tabBar.items?.firstIndex(of: item),
            tabBar.subviews.count > index,
            let view = tabBar.subviews[index].subviews.compactMap({ $0 }).first else { return }
        setupAnim(view)
        
        if index == 2 {
            tabBar.selectionIndicatorImage = UIImage()
        }
    }
}

//MARK: - Configures

extension TabBarController {
    
    func updateUI(_ isAdmin: Bool = false) {
        setValue(myTabBar, forKey: "tabBar")
        tabBar.backgroundColor = .clear
        
        let homeNavi = UINavigationController(rootViewController: homeVC)
        homeVC.tabBarItem.image = UIImage(named: "icon-home")
        homeVC.tabBarItem.selectedImage = UIImage(named: "icon-home-filled")
        
        let wishlistNavi = UINavigationController(rootViewController: wishlistVC)
        wishlistVC.tabBarItem.image = UIImage(named: "icon-wishlist")
        wishlistVC.tabBarItem.selectedImage = UIImage(named: "icon-wishlist-filled")
        
        /*
        let cartNavi = UINavigationController(rootViewController: cartVC)
        cartVC.tabBarItem.image = UIImage(named: "icon-cart")
        cartVC.tabBarItem.selectedImage = UIImage(named: "icon-cart-filled")
        */
        
        let cartNavi = UINavigationController(rootViewController: isAdmin ? productsListVC : cartVC)
        productsListVC.tabBarItem.image = UIImage(named: "icon-list")
        productsListVC.tabBarItem.selectedImage = UIImage(named: "icon-list-filled")
        cartVC.tabBarItem.image = UIImage(named: "icon-cart")
        cartVC.tabBarItem.selectedImage = UIImage(named: "icon-cart-filled")
        
        let moreNavi = UINavigationController(rootViewController: moreVC)
        moreVC.tabBarItem.image = UIImage(named: "icon-more")
        moreVC.tabBarItem.selectedImage = UIImage(named: "icon-more-filled")
        
        let shopNavi = UINavigationController(rootViewController: shopVC)
        shopVC.tabBarC = self
        
        viewControllers = [homeNavi, wishlistNavi, shopNavi, cartNavi, moreNavi]
        tabBar.tintColor = defaultColor
        
        for item in tabBar.items! {
            item.title = ""
            item.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
        }
    }
    
    func setupAnim(_ view: UIView) {
        view.isHidden = false
        view.clipsToBounds = true
        view.layer.cornerRadius = view.frame.height/2.0
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.toValue = 1.5
        
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1.0
        opacity.toValue = 0.2
        
        let group = CAAnimationGroup()
        group.duration = 0.33
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.animations = [scale, opacity]
        view.layer.add(group, forKey: nil)
        view.layer.opacity = 0.0
    }
    
    func setupMiddleBtn() {
        let btnSize: CGFloat = 69.0
        /*
        let middleBtn = UIButton(frame: CGRect(
            x: (view.bounds.width/2.0)-value/2.0,
            y: -23.0, width: value, height: value))
        */
        let x: CGFloat = (view.bounds.width/2.0)-btnSize/2.0
        let y: CGFloat = -22.0
        let middleBtn = UIButton(frame: CGRect(x: x, y: y, width: btnSize, height: btnSize))
        middleBtn.setBackgroundImage(UIImage(named: "icon-shop"), for: .normal)
        middleBtn.backgroundColor = defaultColor
        middleBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        middleBtn.addTarget(self, action: #selector(btnDidTap), for: .touchUpInside)
        middleBtn.clipsToBounds = true
        middleBtn.layer.cornerRadius = btnSize/2.0
        middleBtn.layer.masksToBounds = false
        middleBtn.layer.shadowOffset = CGSize.zero
        middleBtn.layer.shadowRadius = 3.0
        middleBtn.layer.shadowColor = UIColor.black.cgColor
        middleBtn.layer.shadowOpacity = 0.3
        middleBtn.layer.shouldRasterize = true
        middleBtn.layer.rasterizationScale = UIScreen.main.scale
        tabBar.addSubview(middleBtn)
        view.layoutIfNeeded()
    }
    
    @objc func btnDidTap(_ sender: UIButton) {
        touchAnim(sender, frValue: 0.8) {
            self.selectedIndex = 2
            self.tabBar.selectionIndicatorImage = UIImage()
            
            self.isSelect = self.selectedIndex == 2
            if self.isSelect {
                for vc in self.shopVC.navigationController!.viewControllers {
                    if vc.isKind(of: ShopVC.self) {
                        self.shopVC.navigationController?.popToViewController(vc, animated: true)
                    }
                }
            }
            
            self.kDelegate?.handleSelectIndex(self.isSelect)
        }
    }
}
