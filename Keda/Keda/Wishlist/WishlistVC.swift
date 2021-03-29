//
//  WishlistVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class WishlistVC: UIViewController {
    
    //MARK: - Properties
    private let internetView = InternetView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let naContainerV = UIView()
    private let quantityLbl = UILabel()
    private let bagBtn = UIButton()
    private let addBtn = UIButton()
    private let titleLbl = UILabel()
    private var hud = HUD()
    
    private var removeItemView = RemoveItemView()
    private let notifView = UIView()
    private let cancelBtn = ShowMoreBtn()
    private let imgView = UIImageView()
    private let removeTitleLbl = UILabel()
    private let removeBtn = ShowMoreBtn()
    private var cell: WishlistCVCell!
    
    private var tapCount = 0
    private var isTV = false
    let isWishlistVC = true
    
    lazy var wishlists: [Product] = []
    lazy var prCategories: [Product] = []
    
    lazy var categoriesW: [Category] = {
        return Category.fetchDataW()
    }()
    
    private var parallaxOffsetSpeed: CGFloat = 30.0
    private var cellHeight: CGFloat = 130.0
    private var parallaxImageHeight: CGFloat {
        let tvHeight = tableView.frame.height
        let maxOffset = (sqrt(pow(cellHeight, 2) + 4 * tvHeight * parallaxOffsetSpeed) - cellHeight)/2
        return maxOffset
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        
        setupNavi()
        setupDarkMode()

        NotificationCenter.default.addObserver(self, selector: #selector(handleCancel), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSelectedIndex), name: Notification.Name("DismissHomeVC"), object: nil)
        
        guard isInternetAvailable() else {
            naContainerV.isHidden = true
            collectionView.isHidden = true
            tableView.isHidden = true
            internetView.setupInternetView(view, dl: self)
            return
        }
        
        fetchCategories()
        fetchWishlists()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.delegate = nil
        tapCount = 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard isLogIn() else { return }
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - Configures

extension WishlistVC {
    
    func setupNavi() {
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Bag
        bagBtn.configureFilterBtn(naContainerV, imgNamed: "icon-bag", selector: #selector(bagDidTap), controller: self)
        
        //TODO - Add
        addBtn.configureAddBtn(naContainerV, selector: #selector(addDidTap), vc: self)
        
        //TODO: - Title
        let title = NSLocalizedString("My Wishlist", comment: "WishlistVC.swift: My Wishlist")
        titleLbl.configureTitleForNavi(naContainerV, isTxt: title)
        
        //TODO: - Quantity
        naContainerV.insertSubview(quantityLbl, belowSubview: bagBtn)
        setupBagLbl(0, label: quantityLbl)
        
        let x = naContainerV.frame.width-23.0
        quantityLbl.frame = CGRect(x: x, y: 0.0, width: 30.0, height: 30.0)
    }
    
    @objc func bagDidTap() {
        handleBackToTabCart()
    }
    
    @objc func addDidTap() {
        tabBarController?.selectedIndex = 2
        tabBarController?.tabBar.selectionIndicatorImage = UIImage()
    }
    
    func setupCV() {
        collectionView.configureCVAddSub(ds: self, dl: self, view: view)
        collectionView.register(WishlistCVCell.self, forCellWithReuseIdentifier: WishlistCVCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setupTV() {
        tableView.configureTVNonSepar(ds: self, dl: self, view: view)
        tableView.register(WishlistTVCell.self, forCellReuseIdentifier: WishlistTVCell.identifier)
        tableView.rowHeight = 130.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func handleSelectedIndex() {
        handleBackToTabHome()
    }
    
    private func fetchCategories() {
        prCategories = []
        Product.fetchProducts { (products) in
            self.prCategories = products
        }
    }
    
    private func fetchWishlists() {
        if isLogIn() {
            if !appDl.isWishlistVC {
                collectionView.isHidden = true
                tableView.isHidden = true
                hud = createdHUD()
            }
            
            Wishlist.fetchPrFromWishlist { (products) in
                self.wishlists = products.sorted(by: { $0.name < $1.name })
                self.collectionView.reloadData()
                
                guard self.wishlists.count != 0 else {
                    self.collectionView.removeFromSuperview()
                    self.isTV = true
                    self.setupTV()
                    self.setupDarkMode()
                    
                    if self.tableView.contentOffset.y > 0 { self.tapCount = 1 }
                    removeHUD(self.hud) {
                        self.collectionView.isHidden = self.wishlists.count <= 0
                        self.tableView.isHidden = !(self.wishlists.count <= 0)
                        appDl.isWishlistVC = true
                    }
                    
                    return
                }
                
                self.tableView.removeFromSuperview()
                self.isTV = false
                self.setupCV()
                self.setupDarkMode()
                
                if self.collectionView.contentOffset.y > 0 { self.tapCount = 1 }
                removeHUD(self.hud) {
                    self.collectionView.isHidden = self.wishlists.count <= 0
                    self.tableView.isHidden = !(self.wishlists.count <= 0)
                    appDl.isWishlistVC = true
                }
            }
            
            ShoppingCart.fetchShoppingCart(completion: { (shoppingCart) in
                if let shoppingCart = shoppingCart {
                    self.quantityLbl.text = "\(shoppingCart.productCarts.count)"
                    
                } else {
                    self.quantityLbl.text = "\(0)"
                }
            })
            
        } else {
            presentWelcomeVC(self)
        }
    }
}

//MARK: - UICollectionViewDataSource

extension WishlistVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishlistCVCell.identifier, for: indexPath) as! WishlistCVCell
        cell.wishlist = wishlists[indexPath.item]
        cell.delegate = self
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension WishlistVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! WishlistCVCell
        let product = wishlists[indexPath.item]
        
        touchAnim(cell, frValue: 0.8) {
            let productVC = ProductVC()
            productVC.product = product
            productVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(productVC, animated: true)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension WishlistVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeItem = (collectionView.frame.size.width - 40.0)/2.0
        return CGSize(width: sizeItem, height: (sizeItem*1.4)+(sizeItem*0.40))
    }
}

//MARK: - WishlistCVCellDelegate

extension WishlistVC: WishlistCVCellDelegate {
    
    func handleRemoveItem(_ cell: WishlistCVCell) {
        //TODO: - RemoveItemView
        let titleLblTxt = NSLocalizedString("Remove this item from wishlist?", comment: "WishlistVC.swift: Remove this item from wishlist?")
        let titleBtnTxt = NSLocalizedString("Remove Item", comment: "WishlistVC.swift: Remove Item")
        
        self.cell = cell
        removeItemView = RemoveItemView(frame: kWindow!.bounds)
        removeItemView.delegate = self
        kWindow!.addSubview(removeItemView)
        removeItemView.setupView(notifView, cancelBtn, imgView, removeTitleLbl, removeBtn, titleLblTxt, titleBtnTxt, cell.imgView.image)
    }
}

//MARK: - RemoveItemViewDelegate

extension WishlistVC: RemoveItemViewDelegate {
    
    @objc func handleCancel() {
        handleRemoveView(completion: nil)
    }
    
    func handleRemoveView(completion: (() -> ())?) {
        cancelBtn.alpha = 0.0
        imgView.alpha = 0.0
        removeTitleLbl.alpha = 0.0
        removeBtn.alpha = 0.0
        
        UIView.animate(withDuration: 0.33, animations: {
            self.notifView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            self.notifView.alpha = 0.0
            self.removeItemView.alpha = 0.0
        }) { (_) in
            self.removeItemView.removeFromSuperview()
            completion?()
        }
    }
    
    func handleRemove() {
        handleRemoveView {
            guard let indexPath = self.collectionView.indexPath(for: self.cell) else { return }
            let uid = self.wishlists[indexPath.item].uid
            let wishlist = Wishlist(prUID: uid)
            wishlist.removeWishlist {}
            
            self.wishlists.remove(at: indexPath.item)
            self.collectionView.deleteItems(at: [indexPath])
            self.collectionView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource

extension WishlistVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return categoriesW.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WishlistTVCell.identifier, for: indexPath) as! WishlistTVCell
        let categoryW = categoriesW[indexPath.row]
        cell.categoryW = categoryW
        cell.selectionStyle = .none
        cell.imgViewTopConst.constant = parallaxOffset(tableView.contentOffset.y, cell: cell)
        return cell
    }
    
    func parallaxOffset(_ newOffsetY: CGFloat, cell: WishlistTVCell) -> CGFloat {
        return (newOffsetY - cell.frame.origin.y) / parallaxImageHeight * parallaxOffsetSpeed
    }
}

//MARK: - UITableViewDelegate

extension WishlistVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! WishlistTVCell
        let category = categoriesW[indexPath.row]
        touchAnim(cell.containerView, frValue: 0.8) {
            let products: [Product]
            switch category.name {
            case categories[0]: products = Product.hoodies(self.prCategories); break
            case categories[1]: products = Product.belts(self.prCategories); break
            case categories[2]: products = Product.shoes(self.prCategories); break
            case categories[3]: products = Product.watches(self.prCategories); break
            case categories[4]: products = Product.bags(self.prCategories); break
            case categories[5]: products = Product.jackets(self.prCategories); break
            case categories[6]: products = Product.shirts(self.prCategories); break
            case categories[7]: products = Product.shorts(self.prCategories); break
            case categories[8]: products = Product.pants(self.prCategories); break
            case categories[9]: products = Product.slides(self.prCategories); break
            case categories[10]: products = Product.lounge(self.prCategories); break
            default: products = Product.collectables(self.prCategories); break
            }
            
            let cateDetail = CategoriesDetailVC()
            cateDetail.headerView.image = UIImage(named: category.imageName)
            cateDetail.headerView.titleTxt = category.name
            cateDetail.categories = products
            cateDetail.products = self.prCategories
            cateDetail.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(cateDetail, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}

//MARK: - UITabBarControllerDelegate

extension WishlistVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            tapCount += 1
            
            if tapCount == 2 {
                tapCount = 1
                
                if isTV {
                    if tableView.contentOffset.y > 0.0 {
                        let origin = CGPoint(x: tableView.center.x, y: -44.0)
                        tableView.scrollRectToVisible(CGRect(origin: origin, size: view.bounds.size), animated: true)
                    }
                    
                } else {
                    if collectionView.contentOffset.y > 0.0 {
                        let indexPath = IndexPath(item: 0, section: 0)
                        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
                    }
                }
            }
        }
    }
}

//MARK: - UIScrollViewDelegate

extension WishlistVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tapCount += 1
        if tapCount >= 2 { tapCount = 1 }
        
        guard isTV else { return }
        for cell in tableView.visibleCells as! [WishlistTVCell] {
            cell.imgViewTopConst.constant = parallaxOffset(tableView.contentOffset.y, cell: cell)
        }
    }
}

//MARK: - InternetViewDelegate

extension WishlistVC: InternetViewDelegate {
    
    func handleReload() {
        handleBackToTabWishlish()
    }
}

//MARK: - DarkMode

extension WishlistVC {
    
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
        internetView.setupDarkMode(isDarkMode)
        collectionView.backgroundColor = isDarkMode ? .black : .white
        tableView.backgroundColor = isDarkMode ? .black : .white
    }
}
