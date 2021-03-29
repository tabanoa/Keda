//
//  ShopVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ShopVC: UIViewController {
    
    //MARK: - Properties
    private let internetView = InternetView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let naContainerV = UIView()
    private let rightBtn = UIButton()
    private let shopLayout = ShopLayout()
    private var tapCount = 0
    private let refresh = UIRefreshControl()
    private let searchTF = UITextField()
    private var hud = HUD()
    
    var tabBarC: TabBarController!
    let isShopVC = true
    private var color = ""
    private var star: Int = 0
    
    lazy var products: [Product] = []
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        
        setupNavi()
        setupCV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        guard isInternetAvailable() else {
            naContainerV.isHidden = true
            collectionView.isHidden = true
            internetView.setupInternetView(view, dl: self)
            return
        }
        
        if !appDl.isShopVC {
            collectionView.isHidden = true
            hud = createdHUD()
        }
        
        //TODO: - FetchData
        Product.fetchProducts { (products) in
            if self.products.count <= 0 { self.products = products }
            if !appDl.isShopVC { self.products.shuffledInPlace() }
            self.collectionView.reloadData()
            
            removeHUD(self.hud) {
                self.collectionView.isHidden = self.products.count <= 0
                appDl.isShopVC = true
            }
        }
        
        if collectionView.contentOffset.y > 0 { tapCount = 1 }
        
        //TODO - SearchTextField
        setupSearchTF()
        setupDarkMode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarC.kDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarC.kDelegate = nil
        tapCount = 0
    }
}

//MARK: - Configures

extension ShopVC {
    
    func setupNavi() {
        naContainerV.configureContainerView(navigationItem)
        rightBtn.configureFilterBtn(naContainerV, selector: #selector(filterDidTap), controller: self)
    }
    
    @objc func filterDidTap() {
        let filterVC = FilterVC()
        filterVC.kDelegate = self
        filterVC.allProducts = products
        filterVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(filterVC, animated: false)
    }
    
    func setupCV() {
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.configureCVAddSub(ds: self, dl: self, view: view)
        collectionView.register(ShopCVCell.self, forCellWithReuseIdentifier: ShopCVCell.identifier)
        collectionView.refreshControl = refresh
        
        collectionView.collectionViewLayout = shopLayout
        shopLayout.contentPadding = SpacingMode(horizontal: 2.0, vertical: 2.0)
        shopLayout.cellPadding = 2.0
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setupSearchTF() {
        let width = naContainerV.frame.width - 40.0
        searchTF.configureTF(self, naContainerV, xPos: 0.0, width: width, dl: self)
    }
    
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.async {
            delay(duration: 1.0) {
                guard isInternetAvailable() else {
                    handleBackToTabHome()
                    return
                }
                
                //Reload
                self.products.shuffledInPlace()
                self.collectionView.reloadData()
                sender.endRefreshing()
            }
        }
    }
}

//MARK: - UICollectionViewDataSource

extension ShopVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopCVCell.identifier, for: indexPath) as! ShopCVCell
        cell.product = products[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ShopVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ShopCVCell
        let product = products[indexPath.item]
        touchAnim(cell, frValue: 0.8) {
            let productVC = ProductVC()
            productVC.product = product
            productVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(productVC, animated: true)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ShopVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = collectionView.contentInset
        let sizeItem = (collectionView.frame.size.width - (inset.left + inset.right + 10.0))/2.0
        return CGSize(width: sizeItem, height: sizeItem)
    }
}

//MARK: - UITabBarControllerDelegate

extension ShopVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 2 {
            tapCount += 1
            
            if tapCount == 2 {
                tapCount = 1
                if collectionView.contentOffset.y > 0.0 {
                    collectionView.scrollRectToVisible(CGRect(origin: CGPoint(x: 0.0, y: -44.0), size: view.bounds.size), animated: true)
                }
            }
        }
    }
}

//MARK: - UIScrollViewDelegate

extension ShopVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tapCount += 1
        if tapCount >= 2 { tapCount = 1 }
    }
}

//MARK: - FilterVCDelegate

extension ShopVC: FilteredVCDelegate {
    
    func handleDoneDidTap(_ color: String, _ rating: Int, vc: FilterVC) {
        vc.handlePop()
        
        Product.filterByColorAndRating(color, rating, prs: products) { (prs) in
            self.handlePushFilteredVC(prs)
        }
    }
    
    func handleDoneDidTap(_ color: String, vc: FilterVC) {
        vc.handlePop()
        
        Product.filterByColor(color, prs: products) { (prs) in
            self.handlePushFilteredVC(prs)
        }
    }
    
    func handleDoneDidTap(_ rating: Int, vc: FilterVC) {
        vc.handlePop()
        
        Product.filterByRating(rating, prs: products) { (prs) in
            self.handlePushFilteredVC(prs)
        }
    }
    
    func handlePushFilteredVC(_ prs: [Product]) {
        let filteredVC = FilteredVC()
        filteredVC.products = prs
        filteredVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(filteredVC, animated: false)
    }
}

//MARK: - UITextFieldDelegate

extension ShopVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        
        let searchVC = SearchVC()
        searchVC.allProducts = products
        searchVC.products = products
        searchVC.suggestions = Product.suggestions(products)
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC, animated: false)
    }
}

//MARK: - UIScrollViewDelegate

extension ShopVC: TabBarControllerDelegate {
    
    func handleSelectIndex(_ isTwo: Bool) {
        guard isTwo else { return }
        tapCount += 1
        
        if tapCount == 2 {
            tapCount = 1
            if collectionView.contentOffset.y > 0.0 {
                collectionView.scrollRectToVisible(CGRect(origin: CGPoint(x: 0.0, y: -44.0), size: view.bounds.size), animated: true)
            }
        }
    }
}

//MARK: - InternetViewDelegate

extension ShopVC: InternetViewDelegate {
    
    func handleReload() {
        handleBackToTabShop()
    }
}

//MARK: - DarkMode

extension ShopVC {
    
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
        view.backgroundColor = isDarkMode ? .black : .white
        searchTF.backgroundColor = isDarkMode ? darkColor : .white
        internetView.setupDarkMode(isDarkMode)
    }
}
