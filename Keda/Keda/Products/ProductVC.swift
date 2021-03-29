//
//  ProductVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import CoreData
import Firebase

class ProductVC: UIViewController {
    
    //MARK: - Properties
    private let headerView = ProductHeaderView()
    private let colorView = ProductColorView()
    private let sizeView = ProductSizeView()
    private let contentView = ProductContentView()
    private let bottomView = ProductBottomView()
    private let descriptionView = ProductDescriptionView()
    private var descriptionDeliveryVC = DescriptionDeliveryVC()
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    var isRecentlyViewed = false
    var isSearch = false
    var isCart = false
    var isFilteredVC = false
    
    var selectedColor: String?
    var selectedSize: String?
    
    private var isSelectColor = false
    private var isSelectSize = false
    
    var product: Product!
    var selectedProduct: Product?
    
    private var recentlyVieweds: [RecentlyViewedModel] = []
    private var prCart: ProductCart?
    
    private var coreDataStack: CoreDataStack {
        return appDl.coreDataStack
    }
    
    private var rating1: Int = 0
    private var rating2: Int = 0
    private var rating3: Int = 0
    private var rating4: Int = 0
    private var rating5: Int = 0
    
    private var average: Double = 0.0
    private var rating: String = ""
    private var total: Int = 0
    private var isPurchased = false
    private var prRating: Rating?
    
    private var currentPage = 0
    
    private var isViews = true
    
    var modelU: NotificationUserModel?
    var userUID: String = ""
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = groupColor
        navigationItem.setHidesBackButton(true, animated: false)
        
        setupHeaderView()
        setupDarkMode()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
        
        fetchRating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSelectedIndex), name: Notification.Name("DismissHomeVC"), object: nil)
        
        fetchColorAndSize()
        fetchPrCart()
        fetchFavorite()
        fetchPrPurchased()
        
        recentlyVieweds = []
        RecentlyViewedModel.fetchFromCoreData { (recentlyVieweds) in
            self.recentlyVieweds = recentlyVieweds
        }
        
        guard var modelU = modelU else { return }
        modelU.value = 0
        
        let notifU = NotificationUser()
        notifU.saveNotificationUser(userUID: userUID, modelU)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addCoreData()
        addViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isViews = false
        
        guard isLogIn() else { return }
        NotificationCenter.default.removeObserver(self)
        //setupPopVC()
    }
}

//MARK: - Configures

extension ProductVC {
    
    func setupHeaderView() {
        //TODO: - HeaderView
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenWidth)
        headerView.delegate = self
        view.addSubview(headerView)
        
        headerView.updateUI(self, dl: self, view: view, pr: product)
        colorView.setupColorView(view, headerV: headerView, dl: self)
        sizeView.setupSizeView(view, headerV: headerView, dl: self)
        contentView.setupContentView(view, sizeView: sizeView, dl: self)
        contentView.setupTextForLbl(product)
        bottomView.setupBotomView(view, dl: self)
        descriptionView.setupDescriptionView(view, contentV: contentView, bottomV: bottomView, dl: self, pr: product)
        
        colorView.product = product
        sizeView.product = product
    }
    
    func fetchColorAndSize() {
        guard selectedProduct == nil else { return }
        
        colorView.selectedColor = product.colors.first
        selectedColor = colorView.selectedColor
        
        sizeView.selectedSize = product.sizes.first
        selectedSize = sizeView.selectedSize
        
        isSelectColor = selectedColor != nil
        isSelectSize = selectedSize != nil
        
        colorView.collectionView.reloadData()
        sizeView.collectionView.reloadData()
        
        if let color = selectedColor {
            if product.colors.contains(color) {
                let index = product.colors.firstIndex(of: color)!
                product.colorModelIndex = index
                
                if let size = selectedSize {
                    if product.sizes.contains(size) {
                        let index = product.sizes.firstIndex(of: size)!
                        product.sizeModelIndex = index
                        selectedProduct = product
                    }
                }
            }
        }
    }
}

//MARK: - Functions

extension ProductVC {
    
    func setupPopVC() {
        //guard isPush else { return }
        guard let navi = navigationController else { return }
        for vc in navi.viewControllers {
            if vc.isKind(of: HomeVC.self) {
                navi.popToViewController(vc, animated: false)
                
            } else if vc.isKind(of: WishlistVC.self) {
                navi.popToViewController(vc, animated: false)
                
            } else if vc.isKind(of: ShopVC.self) {
                navi.popToViewController(vc, animated: false)
                
            } else if vc.isKind(of: MoreVC.self) {
                navi.popToViewController(vc, animated: false)
            }
        }
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        guard !isFilteredVC else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: view)
        let percent = translation.x / view.bounds.width
        let progress = CGFloat(fminf(fmax(Float(percent), 0.0), 1.0))
        
        switch sender.state {
        case .began:
            navigationController?.delegate = self
            presentHomeVC()
            navigationController?.popViewController(animated: true)
        case .changed:
            if let interractiveTransition = interactiveTransition {
                interractiveTransition.update(progress)
            }
            
            shouldFinish = progress > percentThreshold
        case .cancelled, .failed:
            interactiveTransition.cancel()
        case .ended:
            shouldFinish ? interactiveTransition.finish() : interactiveTransition.cancel()
        default: break
        }
    }
    
    private func fetchFavorite() {
        guard isLogIn() else { return }
        Wishlist.fetchProductsUID { (prUIDs) in
            self.headerView.isFavorite = prUIDs.contains(self.product.uid)

            let imgName = self.headerView.isFavorite ? "icon-favorite-filled" : "icon-favorite"
            self.headerView.favoriteBtn.setImage(UIImage(named: imgName), for: .normal)
        }
    }
    
    private func addCoreData() {
        let model = RecentlyViewedModel(prUID: product.uid, createdTime: createTime())
        if !recentlyVieweds.contains(model) {
            let recently = RecentlyViewed(context: coreDataStack.managedObjectContext)
            recently.productUID = model.prUID
            recently.createdTime = model.createdTime
            coreDataStack.saveContext()
            getPath()
        }
    }
    
    private func addViews() {
        guard isViews else { return }
        let viewsModel = ViewsModel()
        viewsModel.saveViews(prUID: product.uid)
    }
    
    private func fetchPrCart() {
        prCart = nil
        guard isLogIn() else { return }
        ShoppingCart.fetchProductCart(name: selectedProduct!.name,
                                      selectColor: selectedColor!,
                                      selectSize: selectedSize!) { (prCart) in
                                        self.prCart = prCart
        }
    }
    
    private func fetchPrPurchased() {
        guard isLogIn() else { return }
        
        History.fetchHistories { (histories) in
            guard histories.count != 0 else { return }
            histories.forEach({
                if $0.delivered {
                    for pr in $0.shoppingCart.productCarts {
                        if pr.prUID == self.product.uid {
                            self.isPurchased = true
                        }
                    }
                }
            })
        }
    }
    
    private func fetchRating() {
        Rating.fetchRatings(prUID: product.uid) { (rating) in
            guard let rating = rating else {
                self.contentView.ratingsCountLbl.isHidden = false
                self.contentView.viewAllBtn.isHidden = false
                self.contentView.ratingSmallSV.rating = 0
                self.contentView.ratingsCountLbl.text = "(\(0))"
                return
            }
            
            self.prRating = rating
            
            rating.calculateAverage { (r1, r2, r3, r4, r5, total, average) in
                self.rating1 = r1
                self.rating2 = r2
                self.rating3 = r3
                self.rating4 = r4
                self.rating5 = r5
                self.total = total
                self.average = average
                
                self.contentView.ratingSmallSV.rating = Int(average)
                self.contentView.ratingsCountLbl.isHidden = true
                self.contentView.viewAllBtn.isHidden = true
                
                handleText(Double(total)) { (rating) in
                    self.rating = rating
                    self.contentView.ratingsCountLbl.text = "(\(self.rating))"
                    
                    UIView.animate(withDuration: 0.5) {
                        self.contentView.ratingsCountLbl.isHidden = false
                        self.contentView.viewAllBtn.isHidden = false
                    }
                }
            }
        }
    }
    
    @objc func handleSelectedIndex() {
        handleBackToTabHome()
    }
}

//MARK: - UINavigationControllerDelegate

extension ProductVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopAnimatedTransitioning()
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        navigationController.delegate = nil
        
        if panGestureRecognizer.state == .began {
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            interactiveTransition.completionCurve = .easeOut
            
        } else {
            interactiveTransition = nil
        }
        
        return interactiveTransition
    }
}

//MARK: - ProductPageVCDelegate

extension ProductVC: ProductPageVCDelegate {
    
    func numberOfPages(_ num: Int) {
        headerView.pageControl.numberOfPages = num
    }
    
    func currentPage(_ num: Int) {
        headerView.pageControl.currentPage = num
        currentPage = num
    }
}

//MARK: - ProductHeaderViewDelegate

extension ProductVC: ProductHeaderViewDelegate {
    
    func handleBackDidTap() {
        presentHomeVC()
        navigationController?.popViewController(animated: true)
    }
    
    func presentHomeVC() {
        if isRecentlyViewed || isSearch {
            handlePopToVC()
            isRecentlyViewed = false
            isSearch = false
        }
    }
    
    func handlePopToVC() {
        for vc in navigationController!.viewControllers {
            if vc.isKind(of: HomeVC.self) {
                navigationController?.popToViewController(vc, animated: true)
                
            } else if vc.isKind(of: WishlistVC.self) {
                navigationController?.popToViewController(vc, animated: true)
                
            } else if vc.isKind(of: ShopVC.self) {
                navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    func handleShareDidTap() {
        let text = "Hello!!! Please buy my app,... Thanks!"
        let image = UIImage(named: "shoes2-1")!
        let link = "https://wwww.example.com"
        let shareAll: [Any] = [image, text, link]
        let activityVC = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityVC.title = NSLocalizedString("Share", comment: "ProductVC.swift: Share")
        activityVC.popoverPresentationController?.sourceView = view
        present(activityVC, animated: true, completion: nil)
    }
    
    func handleFavoriteDidTap(_ v: ProductHeaderView) {
        guard isInternetAvailable() else {
            internetNotAvailable()
            return
        }
        
        if isLogIn() {
            v.isFavorite = !v.isFavorite
            
            let imgName = v.isFavorite ? "icon-favorite-filled" : "icon-favorite"
            v.favoriteBtn.setImage(UIImage(named: imgName), for: .normal)
            
            if v.isFavorite {
                let wishlist = Wishlist(prUID: product.uid)
                wishlist.saveWishlist {}
                
            } else {
                let wishlist = Wishlist(prUID: product.uid)
                wishlist.removeWishlist {}
            }
            
        } else {
            presentWelcomeVC(self, isPresent: true)
        }
    }
    
    func handleIMGDidTap() {
        if let color = selectedColor {
            if product.colors.contains(color) {
                let index = product.colors.firstIndex(of: color)!
                product.colorModelIndex = index
                
                let productShowIMGVC = ProductShowIMGVC()
                productShowIMGVC.currentPage = currentPage
                productShowIMGVC.imageLinks = product.imageLinks
                present(productShowIMGVC, animated: true, completion: nil)
            }
        }
    }
}

//MARK: - ProductContentViewDelegate

extension ProductVC: ProductContentViewDelegate {
    
    func handleViewAllDidTap() {
        let productRatingVC = ProductRatingVC()
        productRatingVC.prUID = product.uid
        productRatingVC.isPurchased = isPurchased
        productRatingVC.rating1 = rating1
        productRatingVC.rating2 = rating2
        productRatingVC.rating3 = rating3
        productRatingVC.rating4 = rating4
        productRatingVC.rating5 = rating5
        productRatingVC.prRating = prRating
        productRatingVC.average = average
        productRatingVC.rating = rating
        productRatingVC.total = total
        navigationController?.pushViewController(productRatingVC, animated: true)
    }
}

//MARK: - ProductDescriptionViewDelegate

extension ProductVC: ProductDescriptionViewDelegate {
    
    func handleShowMoreDidTap(_ lbl: UILabel) {
        descriptionDeliveryVC = DescriptionDeliveryVC()
        
        let desTxt = NSLocalizedString("Description", comment: "ProductVC.swift: Description")
        let deliveryTxt = NSLocalizedString("Delivery Options", comment: "ProductVC.swift: Delivery Options")
        let titleTxt = NSLocalizedString("Description & Delivery", comment: "ProductVC.swift: Description & Delivery")
        
        descriptionDeliveryVC.delegate = self
        descriptionDeliveryVC.titleTxt = titleTxt
        descriptionDeliveryVC.desTxt = desTxt
        descriptionDeliveryVC.deliveryTxt = deliveryTxt
        descriptionDeliveryVC.contentTxt = lbl.text!
        
        addChild(descriptionDeliveryVC)
        view.addSubview(descriptionDeliveryVC.view)
        descriptionDeliveryVC.didMove(toParent: self)
        setupDarkMode()
    }
}

//MARK: - DescriptionDeliveryVCDelegate

extension ProductVC: DescriptionDeliveryVCDelegate {
    
    func handleAddBagDidTap(vc: DescriptionDeliveryVC) {
        vc.cancelDidTap()
        
        guard isSelectColor && isSelectSize else { colorAndSizeAlert(); return }
        guard isInternetAvailable() else { internetNotAvailable(); return }
        addToBag { self.successAlert(); self.fetchPrCart() }
    }
}


//MARK: - ProductBottomViewDelegate

extension ProductVC: ProductBottomViewDelegate {
    
    func handleBuyDidTap() {
        guard isSelectColor && isSelectSize else { colorAndSizeAlert(); return }
        guard isInternetAvailable() else { internetNotAvailable(); return }
        addToBag {
            self.fetchPrCart()
            
            let hud = createdHUD()
            self.handlePopTabCart(hud)
        }
    }
    
    func handlePopTabCart(_ hud: HUD) {
        if isCart {
            navigationController?.popViewController(animated: true)

        } else {
            delay(duration: 3.0) { hud.removeFromSuperview(); handleBackToTabCart() }
        }
    }
    
    func handleBagDidTap() {
        guard isSelectColor && isSelectSize else { colorAndSizeAlert(); return }
        guard isInternetAvailable() else { internetNotAvailable(); return }
        addToBag { self.successAlert(); self.fetchPrCart() }
    }
    
    private func addToBag(completion: @escaping () -> Void) {
        if isLogIn() {
            let shoppingCart = ShoppingCart()
            guard prCart == nil else {
                shoppingCart.updateShoppingCart(prCart: prCart!) { completion() }
                return
            }
            
            shoppingCart.addNewShoppingCart(selectedProduct!, selectedColor!, selectedSize!) {
                completion()
            }
            
        } else {
            presentWelcomeVC(self, isPresent: true)
        }
    }
    
    func successAlert() {
        let cTxt = NSLocalizedString("Success", comment: "ProductVC.swift: Success")
        handleInternet(cTxt, imgName: "icon-checkmark")
    }
    
    func colorAndSizeAlert() {
        let txt: String
        if isSelectColor && !isSelectSize {
            txt = NSLocalizedString("Select Sizes", comment: "ProductVC.swift: Select Sizes")
            
        } else if !isSelectColor && isSelectSize {
            txt = NSLocalizedString("Select Colos", comment: "ProductVC.swift: Select Colos")
            
        } else {
            txt = NSLocalizedString("Select Colos And Sizes", comment: "ProductVC.swift: Select Colos And Sizes")
        }
        
        handleInternet(txt, imgName: "icon-error")
    }
}

//MARK: - ProductColorViewDelegate

extension ProductVC: ProductColorViewDelegate {
    
    func didSelectColor(_ selectedColor: String, isSelectColor: Bool) {
        self.selectedColor = selectedColor
        self.isSelectColor = isSelectColor

        if let color = self.selectedColor {
            if product.colors.contains(color) {
                let index = product.colors.firstIndex(of: color)!
                product.colorModelIndex = index
                colorView.collectionView.reloadData()
                sizeView.collectionView.reloadData()
                
                if let size = self.selectedSize {
                    if product.sizes.contains(size) {
                        let index = product.sizes.firstIndex(of: size)!
                        product.sizeModelIndex = index
                        handleReloadData()
                        
                    } else {
                        sizeView.selectedSize = product.sizes[0]
                        selectedSize = sizeView.selectedSize
                        isSelectSize = selectedSize != nil
                        sizeView.collectionView.reloadData()
                        product.sizeModelIndex = 0
                        handleReloadData()
                    }
                }
            }
        }
    }
    
    func handleReloadData() {
        contentView.setupTextForLbl(product)
        descriptionView.setupDesLbl(product)
        headerView.setupPageVC(self, dl: self, view: view, pr: product)
        headerView.setupPercent(product)
        selectedProduct = product
        fetchPrCart()
    }
}

//MARK: - ProductSizeViewDelegate

extension ProductVC: ProductSizeViewDelegate {
    
    func didSelectSize(_ selectedSize: String, isSelectSize: Bool) {
        self.selectedSize = selectedSize
        self.isSelectSize = isSelectSize
        
        if let size = self.selectedSize {
            if product.sizes.contains(size) {
                let index = product.sizes.firstIndex(of: size)!
                product.sizeModelIndex = index
                handleReloadData()
            }
        }
    }
}

//MARK: - DarkMode

extension ProductVC {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    private func setupDarkMode() {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: darkModeView()
            case .dark: darkModeView(true)
            default: break
            }
        } else {
            darkModeView()
        }
    }
    
    private func darkModeView(_ isDarkMode: Bool = false) {
        view.backgroundColor = isDarkMode ? .black : groupColor
        headerView.setupDarkMode(isDarkMode)
        colorView.setupDarkMode(isDarkMode)
        sizeView.setupDarkMode(isDarkMode)
        contentView.setupDarkMode(isDarkMode)
        descriptionView.setupDarkMode(isDarkMode)
        bottomView.setupDarkMode(isDarkMode)
        descriptionDeliveryVC.setupDarkMode(isDarkMode)
        descriptionDeliveryVC.tableView.reloadData()
    }
}
