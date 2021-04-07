//
//  CartVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Firebase

class CartVC: UIViewController {
    
    //MARK: - Properties
    private let internetView = InternetView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let naContainerV = UIView()
    private var hud = HUD()
    
    private let quantityLbl = UILabel()
    private let itemImg = UIImageView()
    private let addBtn = UIButton()
    private let titleLbl = UILabel()
    
    private var popUpView = PopUpView()
    private let containerView = UIView()
    private let popUpTV = UITableView(frame: .zero, style: .grouped)
    
    private var removeItemView = RemoveItemView()
    private let notifView = UIView()
    private let cancelBtn = ShowMoreBtn()
    private let imgView = UIImageView()
    private let removeTitleLbl = UILabel()
    private let removeBtn = ShowMoreBtn()
    private var cell: CartItemTVCell!
    
    private let notiLbl = UILabel()
    
    private var tapCount = 0
    
    let isCartVC = true
    private var isPush = true
    private var isDelete = true
    
    private var user: User?
    private var addresses: [Address] = []
    private var address: Address?
    private var shoppingCart = ShoppingCart()
    private var productCarts: [ProductCart] = []
    private var ref = DatabaseReference()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        
        setupNavi()
        setupTV()
        setupDarkMode()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCancelPopUpView), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSelectedIndex), name: Notification.Name("DismissHomeVC"), object: nil)
        
        guard isInternetAvailable() else {
            naContainerV.isHidden = true
            tableView.isHidden = true
            internetView.setupInternetView(view, dl: self)
            return
        }
        
        if isLogIn() {
            tableView.isHidden = true
            hud = createdHUD()
            
            fetchAddress()
            fetchShoppingCart()
            fetchUser()
            if tableView.contentOffset.y > 0 { tapCount = 1 }
            
        } else {
            presentWelcomeVC(self)
        }
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
        isPush = true
        ref.removeAllObservers()
    }
}

//MARK: - Configures

extension CartVC {
    
    func setupNavi() {
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Item
        itemImg.frame = CGRect(x: naContainerV.frame.width-30.0, y: 0.0, width: 40.0, height: 40.0)
        itemImg.image = UIImage(named: "icon-item")
        itemImg.clipsToBounds = true
        itemImg.contentMode = .scaleAspectFit
        naContainerV.addSubview(itemImg)
        
        //TODO - Add
        addBtn.configureAddBtn(naContainerV, selector: #selector(addDidTap), vc: self)
        
        //TODO: - Title
        let title = NSLocalizedString("Shopping Cart", comment: "CartVC.swift: Shopping Cart")
        titleLbl.configureTitleForNavi(naContainerV, isTxt: title)
        
        //TODO: - Quantity
        naContainerV.insertSubview(quantityLbl, belowSubview: itemImg)
        setupBagLbl(0, label: quantityLbl)
        
        let x = naContainerV.frame.width-20.0
        quantityLbl.frame = CGRect(x: x, y: -4.0, width: 30.0, height: 30.0)
    }
    
    @objc func addDidTap() {
        tabBarController?.selectedIndex = 2
        tabBarController?.tabBar.selectionIndicatorImage = UIImage()
    }
    
    func setupTV() {
        tableView.removeFromSuperview()
        tableView.configureTVNonSepar(groupColor, ds: self, dl: self, view: view)
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 100.0, right: 0.0)
        tableView.register(CartShipToTVCell.self, forCellReuseIdentifier: CartShipToTVCell.identifier)
        tableView.register(CartItemTVCell.self, forCellReuseIdentifier: CartItemTVCell.identifier)
        tableView.register(CartSubtotalTVCell.self, forCellReuseIdentifier: CartSubtotalTVCell.identifier)
        tableView.register(CartTotalTVCell.self, forCellReuseIdentifier: CartTotalTVCell.identifier)
        tableView.register(CartCheckoutTVCell.self, forCellReuseIdentifier: CartCheckoutTVCell.identifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

//MARK: - Functions

extension CartVC {
    
    @objc func handleSelectedIndex() {
        handleBackToTabHome()
    }
    
    private func fetchShoppingCart() {
        ref = DatabaseRef.user(uid: currentUID).ref().child("shoppingCart")
        ref.observe(.value) { (snapshot) in
            guard snapshot.exists() else {
                self.productCarts = []
                self.hud.removeFromSuperview()
                self.tableView.isHidden = true
                self.tabBarController?.selectedIndex = 2
                self.tabBarController?.tabBar.selectionIndicatorImage = UIImage()
                return
            }
            
            if let dict = snapshot.value as? [String: Any] {
                DispatchQueue.main.async {
                    self.shoppingCart = ShoppingCart(dictionary: dict)
                    self.productCarts = self.shoppingCart.productCarts.sorted(by: { $0.createdTime > $1.createdTime })
                    self.quantityLbl.text = "\(self.productCarts.count)"
                    self.tableView.reloadData()
                    
                    removeHUD(self.hud) {
                        self.tableView.isHidden = self.productCarts.count <= 0
                    }
                }
            }
        }
    }
    
    func fetchAddress() {
        Address.fetchAddress { (addresses) in
            self.addresses = addresses
            for addr in addresses {
                if addr.defaults { self.address = addr }
            }
        }
    }
    
    func fetchUser() {
        User.fetchUserFromUID { (user) in
            self.user = user
        }
    }
}

//MARK: - UITableViewDataSource

extension CartVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 { return productCarts.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch true {
        case section == 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartShipToTVCell.identifier, for: indexPath) as! CartShipToTVCell
            cell.selectionStyle = .none
            cell.isHidden = addresses == []
            if let addr = address { cell.addr = addr }
            return cell
        case section == 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartItemTVCell.identifier, for: indexPath) as! CartItemTVCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.product = productCarts[indexPath.row]
            return cell
        case section == 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartSubtotalTVCell.identifier, for: indexPath) as! CartSubtotalTVCell
            cell.selectionStyle = .none
            cell.shoppingCart = shoppingCart
            return cell
        case section == 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartTotalTVCell.identifier, for: indexPath) as! CartTotalTVCell
            cell.selectionStyle = .none
            cell.shoppingCart = shoppingCart
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CartCheckoutTVCell.identifier, for: indexPath) as! CartCheckoutTVCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
    }
}

//MARK: - UITableViewDelegate

extension CartVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let shippingToVC = ShippingToVC()
            shippingToVC.delegate = self
            shippingToVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(shippingToVC, animated: true)
            
        } else if indexPath.section == 1 {
            let prCart = productCarts[indexPath.row]
            
            Product.fetchPrFromUIDColorSize(prUID: prCart.prUID, color: prCart.selectColor, size: prCart.selectSize) { (product) in
                guard self.isPush else { return }
                let productVC = ProductVC()
                productVC.product = product
                productVC.selectedColor = prCart.selectColor
                productVC.selectedSize = prCart.selectSize
                productVC.isCart = true
                productVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(productVC, animated: true)
                self.isPush = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 || section == 4 { return 5 }
        if section == 0 {
            return addresses == [] ? CGFloat.leastNonzeroMagnitude : 40.0
        }
        
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 || section == 3 || section == 4 { return CGFloat.leastNonzeroMagnitude }
        if section == 0 {
            return addresses == [] ? CGFloat.leastNonzeroMagnitude : 10.0
        }
        
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        switch true {
        case section == 0: return addresses == [] ? CGFloat.leastNonzeroMagnitude : 60.0
        case section == 1:
            let height = CGFloat(3*(5+30))
            let spacing = CGFloat(10*3)
            
            if appDl.iPhone5 { return CGFloat(31+height+18+spacing) }
            return CGFloat(36+height+21+spacing)
        case section == 2: return 95.0
        default: return 60.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let kView = UIView().configureHeaderView(view, tableView: tableView)
        
        if section == 0 {
            let shippingLbl = UILabel()
            let txt = NSLocalizedString("SHIPPING AND PAYMENT", comment: "CartVC.swift: SHIPPING AND PAYMENT")
            shippingLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
            shippingLbl.configureHeaderTitle(kView)
            
        } else if section == 1 {
            let itemLbl = UILabel()
            let txt = NSLocalizedString("ITEMS IN CART", comment: "CartVC.swift: ITEMS IN CART")
            itemLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
            itemLbl.configureHeaderTitle(kView)
            
        } else if section == 2 {
            let orderLbl = UILabel()
            let txt = NSLocalizedString("ORDER SUMMARY", comment: "CartVC.swift: ORDER SUMMARY")
            orderLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
            orderLbl.configureHeaderTitle(kView)
        }
        
        if #available(iOS 12, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: kView.backgroundColor = groupColor
            case .dark: kView.backgroundColor = .black
            default: break
            }
        } else {
            kView.backgroundColor = groupColor
        }
        
        return kView
    }
}

//MARK: - CartItemTVCellDelegate

extension CartVC: CartItemTVCellDelegate {
    
    func deleteItem(_ cell: CartItemTVCell) {
        //TODO: - RemoveItemView
        let titleLblTxt = NSLocalizedString("Remove this item from cart?", comment: "CartVC.swift: Remove this item from cart?")
        let titleBtnTxt = NSLocalizedString("Remove Item", comment: "CartVC.swift: Remove Item")
        
        self.cell = cell
        removeItemView = RemoveItemView(frame: kWindow!.bounds)
        removeItemView.delegate = self
        kWindow!.addSubview(removeItemView)
        removeItemView.setupView(notifView, cancelBtn, imgView, removeTitleLbl, removeBtn, titleLblTxt, titleBtnTxt, cell.imgView.image)
    }
    
    func setupQuantity(_ cell: CartItemTVCell) {
        let quantities: [Int] = Array(0...50)
        let txt = NSLocalizedString("Number of days to rent", comment: "CartVC.swift: Number of days to rent")
        
        popUpView = PopUpView(frame: kWindow!.bounds)
        popUpView.quantity = cell.quantityLbl.text!.toInt()
        popUpView.quantities = quantities
        popUpView.cell = cell
        popUpView.naviTitle = txt
        popUpView.delegate = self
        kWindow!.addSubview(popUpView)
        popUpView.setupUI(containerView)
        popUpView.setupTV(containerView, popUpTV)
        popUpView.setupDarkMode()
    }
}

//MARK: - RemoveItemViewDelegate

extension CartVC: RemoveItemViewDelegate {
    
    func handleRemove() {
        handleRemoveView {
            guard self.isDelete else { return }
            guard let indexPath = self.tableView.indexPath(for: self.cell) else { return }
            let prCart = self.productCarts[indexPath.row]
            self.productCarts.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
            self.isDelete = false
            self.shoppingCart.deleteShoppingCart(prCart: prCart) { self.isDelete = true }
        }
    }
    
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
}


//MARK: - PopUpViewDelegate

extension CartVC: PopUpViewDelegate {
    
    func fetchQuantity(_ index: Int, view: PopUpView, cell: CartItemTVCell) {
        view.handleCancel(containerView, popUpTV)
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let prCart = productCarts[indexPath.row]
        shoppingCart.updateShoppingCart(prCart: prCart, isPrVC: false, quantity: index) {
            DispatchQueue.main.async {
                self.fetchShoppingCart()
            }
        }
    }
    
    func handleCancelDidTap(_ view: PopUpView) {
        view.handleCancel(containerView, popUpTV)
    }
    
    @objc func handleCancelPopUpView() {
        containerView.transform = .identity
        UIView.animate(withDuration: 0.33, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
            self.containerView.alpha = 0.0
            self.popUpTV.alpha = 0.0
            self.popUpView.alpha = 0.0
        }) { (_) in
            self.popUpView.removeFromSuperview()
        }
    }
}

//MARK: - CartCheckoutTVCellDelegate

extension CartVC: CartCheckoutTVCellDelegate {
    
    func handleCheckout() {
        guard isInternetAvailable() else {
            internetNotAvailable()
            return
        }
        
        if addresses.count != 0 {
            let checkoutVC = CheckoutVC()
            checkoutVC.total = shoppingCart.total
            checkoutVC.address = address
            checkoutVC.user = user
            checkoutVC.shoppingCart = shoppingCart
            checkoutVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(checkoutVC, animated: true)
            
        } else {
            let addressVC = AddressVC()
            let titleNavi = NSLocalizedString("Add New Address", comment: "CartVC.swift: Add New Address")
            let popUpTxt = NSLocalizedString("New address has been added", comment: "CartVC.swift: New address has been added")
            
            addressVC.phoneNumberTxt = user!.phoneNumber
            addressVC.addresses = addresses
            addressVC.titleNavi = titleNavi
            addressVC.addNewAddrTxt = titleNavi
            addressVC.popUpTxt = popUpTxt
            addressVC.hidesBottomBarWhenPushed = true
            addressVC.delegate = self
            navigationController?.pushViewController(addressVC, animated: true)
        }
    }
}

//MARK: - UITabBarControllerDelegate

extension CartVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 3 {
            tapCount += 1
            
            if tapCount == 2 {
                tapCount = 1
                if tableView.contentOffset.y > 0.0 {
                    tableView.scrollRectToVisible(CGRect(origin: CGPoint(x: 0.0, y: -44.0), size: view.bounds.size), animated: true)
                }
            }
        }
    }
}

//MARK: - UIScrollViewDelegate

extension CartVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tapCount += 1
        if tapCount >= 2 { tapCount = 1 }
    }
}

//MARK: - AddressVCDelegate

extension CartVC: AddressVCDelegate {
    
    func handlePopVC(vc: AddressVC) {
        vc.navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }
}

//MARK: - ShippingToVCDelegate

extension CartVC: ShippingToVCDelegate {
    
    func handleUseThisAddr(vc: ShippingToVC) {
        vc.navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }
}

//MARK: - InternetViewDelegate

extension CartVC: InternetViewDelegate {
    
    func handleReload() {
        handleBackToTabCart()
    }
}

//MARK: - DarkMode

extension CartVC {
    
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
        view.backgroundColor = isDarkMode ? .black : groupColor
        tableView.backgroundColor = isDarkMode ? .black : groupColor
        internetView.setupDarkMode(isDarkMode)
        tableView.reloadData()
    }
}
