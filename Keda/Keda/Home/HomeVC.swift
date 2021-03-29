//
//  HomeVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Alamofire

class HomeVC: UIViewController {
    
    //MARK: - Properties
    private let internetView = InternetView()
    private let scrollView = HomeScrollView()
    private let containerView = HomeContainerView()
    
    private let naContainerV = UIView()
    private var hud = HUD()
    private let refresh = UIRefreshControl()
    private let searchTF = UITextField()
    
    private let topHeight: CGFloat = 55.0
    private var tapCount = 0
    let isHomeVC = true
    
    lazy var arrivals: [Product] = []
    lazy var featured: [Product] = []
    lazy var sellers: [Product] = []
    lazy var allProducts: [Product] = []
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavi()
        createdScrollView()
        
        guard isInternetAvailable() else {
            naContainerV.isHidden = true
            scrollView.isHidden = true
            internetView.setupInternetView(view, dl: self)
            return
        }
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        if !appDl.isHomeVC {
            naContainerV.isHidden = true
            scrollView.isHidden = true
        }
        
        //TODO - SearchTextField
        setupSearchTF()
        setupDarkMode()
        if scrollView.contentOffset.y > 0 { tapCount = 1 }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.delegate = self
        
        guard !appDl.isHomeVC else { return }
        hud = createdHUD()
        removeHUD(self.hud) {
            self.naContainerV.isHidden = false
            self.scrollView.isHidden = false
            appDl.isHomeVC = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.delegate = nil
        tapCount = 0
    }
}

//MARK: - Configures

extension HomeVC {
    
    func setupNavi() {
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Filter
        let filterBtn = UIButton()
        filterBtn.configureFilterBtn(naContainerV, selector: #selector(filterDidTap), controller: self)
    }
    
    @objc func filterDidTap() {
        let filterVC = FilterVC()
        filterVC.kDelegate = self
        filterVC.allProducts = allProducts
        filterVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(filterVC, animated: false)
    }
    
    func createdScrollView() {
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        scrollView.setupSV(view, dl: self, ref: refresh, contView: containerView, topH: topHeight)
        
        containerView.arrivalsView.homeVC = self
        containerView.featuredView.homeVC = self
        containerView.sellersView.homeVC = self
        containerView.setupContView(categDl: self, arrDl: self, feaDl: self, sellDl: self, dl: self, topH: topHeight, homeVC: self)
    }
    
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.async {
            delay(duration: 1.0) {
                guard isInternetAvailable() else {
                    handleBackToTabHome()
                    return
                }
                
                self.arrivals.shuffledInPlace()
                self.featured.shuffledInPlace()
                self.sellers.shuffledInPlace()
                
                self.containerView.arrivalsView.collectionView.reloadData()
                self.containerView.featuredView.collectionView.reloadData()
                self.containerView.sellersView.collectionView.reloadData()
                sender.endRefreshing()
            }
        }
    }
    
    func setupSearchTF() {
        let width = naContainerV.frame.width - 40.0
        searchTF.configureTF(self, naContainerV, xPos: 0.0, width: width, dl: self)
    }
}

//MARK: - Functions

extension HomeVC {
    
    private func fetchData() {
        Product.fetchProducts { (products) in
            self.arrivals = products.sorted(by: { $0.createdTime < $1.createdTime })
            self.allProducts = products
            
            DispatchQueue.main.async {
                self.containerView.arrivalsView.collectionView.reloadData()
            }
        }
        
        Product.fetchFeatured { (products) in
            self.featured = products.sorted(by: { $0.viewed > $1.viewed })
            DispatchQueue.main.async {
                self.containerView.featuredView.collectionView.reloadData()
            }
        }
        
        Product.fetchSellers { (products) in
            self.sellers = products.sorted(by: { $0.buyed > $1.buyed })
            DispatchQueue.main.async {
                self.containerView.sellersView.collectionView.reloadData()
            }
        }
    }
}

//MARK: - CategoriesViewDelegate

extension HomeVC: CategoriesViewDelegate {
    
    func categoriesDidTap(_ corverImgName: String, title: String, categories: [Product]) {
        let cateDetail = CategoriesDetailVC()
        cateDetail.headerView.image = UIImage(named: corverImgName)
        cateDetail.headerView.titleTxt = title
        cateDetail.categories = categories
        cateDetail.products = allProducts
        cateDetail.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(cateDetail, animated: true)
    }
}

//MARK: - ArrivalsViewDelegate

extension HomeVC: ArrivalsViewDelegate {
    
    func arrivalsDidTap(_ arrival: Product) {
        let productVC = ProductVC()
        productVC.product = arrival
        productVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(productVC, animated: true)
    }
}

//MARK: - FeaturedViewDelegate

extension HomeVC: FeaturedViewDelegate {
    
    func featuredDidTap(_ featured: Product) {
        let productVC = ProductVC()
        productVC.product = featured
        productVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(productVC, animated: true)
    }
}

//MARK: - SellersViewDelegate

extension HomeVC: SellersViewDelegate {
    
    func sellerDidTap(_ seller: Product) {
        let productVC = ProductVC()
        productVC.product = seller
        productVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(productVC, animated: true)
    }
}

//MARK: - HomeContainerViewDelegate

extension HomeVC: HomeContainerViewDelegate {
    
    func handleArrivalsDidTap() {
        let arrivalsDetailVC = ArrivalsDetailVC()
        arrivalsDetailVC.arrivals = arrivals
        arrivalsDetailVC.products = allProducts
        navigationController?.pushViewController(arrivalsDetailVC, animated: true)
    }
    
    func handleFeaturedDidTap() {
        let featuredDetailVC = FeaturedDetailVC()
        featuredDetailVC.products = allProducts
        featuredDetailVC.featured = featured
        navigationController?.pushViewController(featuredDetailVC, animated: true)
    }
    
    func handleSellersDidTap() {
        let sellersDetailVC = SellersDetailVC()
        sellersDetailVC.sellers = sellers
        sellersDetailVC.products = allProducts
        navigationController?.pushViewController(sellersDetailVC, animated: true)
    }
    
    func handleFacebookDidTap() {
        let urls = [
            "fb://profile/hoang.mtv.075", //App
            "https://www.facebook.com/hoang.mtv.075" //Web
        ]
        
        UIApplication.tryURL(urls: urls)
    }
    
    func handleTwitterDidTap() {
        let urls = [
            "twitter://user?screen_name=KedaApp", //App
            "https://twitter.com/KedaApp" //Web
        ]
        
        UIApplication.tryURL(urls: urls)
    }
}

//MARK: - UITextFieldDelegate

extension HomeVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        
        let searchVC = SearchVC()
        searchVC.allProducts = allProducts
        searchVC.products = allProducts
        searchVC.suggestions = Product.suggestions(allProducts)
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC, animated: false)
    }
}

//MARK: - UITabBarControllerDelegate

extension HomeVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 0 {
            tapCount += 1
            
            if tapCount == 2 {
                tapCount = 1
                if scrollView.contentOffset.y > 0.0 {
                    scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: 0.0, y: -44.0), size: view.bounds.size), animated: true)
                }
            }
        }
    }
}

//MARK: - UIScrollViewDelegate

extension HomeVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tapCount += 1
        if tapCount >= 2 { tapCount = 1 }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        containerView.arrivalsView.collectionView.reloadData()
        containerView.featuredView.collectionView.reloadData()
        containerView.sellersView.collectionView.reloadData()
    }
}

//MARK: - FilterVCDelegate

extension HomeVC: FilteredVCDelegate {
    
    func handleDoneDidTap(_ color: String, _ rating: Int, vc: FilterVC) {
        vc.handlePop()
        
        Product.filterByColorAndRating(color, rating, prs: allProducts) { (prs) in
            self.handlePushFilteredVC(prs)
        }
    }
    
    func handleDoneDidTap(_ color: String, vc: FilterVC) {
        vc.handlePop()
        
        Product.filterByColor(color, prs: allProducts) { (prs) in
            self.handlePushFilteredVC(prs)
        }
    }
    
    func handleDoneDidTap(_ rating: Int, vc: FilterVC) {
        vc.handlePop()
        
        Product.filterByRating(rating, prs: allProducts) { (prs) in
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

//MARK: - InternetViewDelegate

extension HomeVC: InternetViewDelegate {
    
    func handleReload() {
        handleBackToTabHome()
    }
}

//MARK: - DarkMode

extension HomeVC {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("willTransition")
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
        containerView.darkModeViewBtn(isDarkMode)
        containerView.darkModeContactBtn(isDarkMode)
        searchTF.backgroundColor = isDarkMode ? darkColor : .white
        internetView.setupDarkMode(isDarkMode)
    }
}
