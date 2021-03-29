//
//  OrderHistoryVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class OrderHistoryVC: UIViewController {
    
    //MARK: - Properties
    private let internetView = InternetView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let naContainerV = UIView()
    private var hud = HUD()
    
    private let bagBtn = UIButton()
    private let backBtn = UIButton()
    private let titleLbl = UILabel()
    private let quantityLbl = UILabel()
    private let notiLbl = UILabel()
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    var isDelivered = false
    var userUID: String?
    lazy var histories: [History] = []
    
    var isAdmin = false
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        
        setupNavi()
        setupTV()
        setupDarkMode()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard isInternetAvailable() else {
            naContainerV.isHidden = true
            tableView.isHidden = true
            internetView.setupInternetView(view, dl: self)
            return
        }
        
        fetchData()
    }
}

//MARK: - Configures

extension OrderHistoryVC {
    
    func setupNavi() {
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Title
        let title = NSLocalizedString("Orders", comment: "OrderHistoryVC.swift: Orders")
        titleLbl.configureTitleForNavi(naContainerV, isTxt: title)
        
        guard !isAdmin else { return }
        
        //TODO - Bag
        bagBtn.configureFilterBtn(naContainerV, imgNamed: "icon-bag", selector: #selector(bagDidTap), controller: self)
        
        //TODO: - Quantity
        naContainerV.insertSubview(quantityLbl, belowSubview: bagBtn)
        setupBagLbl(0, label: quantityLbl)
        
        let x = naContainerV.frame.width-23.0
        quantityLbl.frame = CGRect(x: x, y: 0.0, width: 30.0, height: 30.0)
    }
    
    @objc func bagDidTap() {
        handleBackToTabCart()
        
        for vc in navigationController!.viewControllers {
            if vc.isKind(of: SettingsVC.self) {
                navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupTV() {
        tableView.configureTVNonSepar(ds: self, dl: self, view: view)
        tableView.register(OrderHistoryTVCell.self, forCellReuseIdentifier: OrderHistoryTVCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 50.0, right: 0.0)
        tableView.estimatedRowHeight = screenWidth
        tableView.rowHeight = UITableView.automaticDimension
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - Functions

extension OrderHistoryVC {
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: view)
        let percent = translation.x / view.bounds.width
        let progress = CGFloat(fminf(fmax(Float(percent), 0.0), 1.0))
        
        switch sender.state {
        case .began:
            navigationController?.delegate = self
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
    
    func fetchData() {
        if histories.count <= 0 {
            tableView.isHidden = true
            hud = createdHUD()
        }
        
        histories.removeAll()
        guard let userUID = userUID else {
            History.fetchHistories { (histories) in
                guard histories.count != 0 else { self.handleRemoveHUD(); return }
                
                self.histories = histories.sorted(by: { $0.uid > $1.uid })
                self.handleTVHidden()
            }
            
            ShoppingCart.fetchShoppingCart(completion: { (shoppingCart) in
                if let shoppingCart = shoppingCart {
                    self.quantityLbl.text = "\(shoppingCart.productCarts.count)"
                    
                } else {
                    self.quantityLbl.text = "\(0)"
                }
            })
            
            return
        }
        
        guard isDelivered else {
            History.fetchOrderPlacedFrom(userUID: userUID) { (histories) in
                guard histories.count != 0 else { self.handleRemoveHUD(); return }
                
                self.histories = histories.sorted(by: { $0.uid < $1.uid })
                self.handleTVHidden()
            }
            
            return
        }
        
        History.fetchDeliveredFrom(userUID: userUID) { (histories) in
            guard histories.count != 0 else { self.handleRemoveHUD(); return }
            
            self.histories = histories.sorted(by: { $0.uid > $1.uid })
            self.handleTVHidden()
        }
    }
    
    func handleRemoveHUD() {
        removeHUD(self.hud, duration: 0.5) {
            self.tableView.isHidden = true
            self.checkData()
        }
    }
    
    func handleTVHidden() {
        self.tableView.reloadData()
        removeHUD(self.hud, duration: 0.5) {
            self.tableView.isHidden = self.histories.count <= 0
        }
    }
    
    func checkData() {
        let txt = NSLocalizedString("No data", comment: "OrderHistoryVC.swift: No data")
        notiLbl.configureNameForCell(!tableView.isHidden, txtColor: .black, fontSize: 17.0, isTxt: txt, fontN: fontNamedBold)
        view.addSubview(notiLbl)
        notiLbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            notiLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0),
            notiLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

//MARK: - UITableViewDataSource

extension OrderHistoryVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderHistoryTVCell.identifier, for: indexPath) as! OrderHistoryTVCell
        let history = histories[indexPath.row]
        cell.selectionStyle = .none
        cell.delegate = self
        cell.history = history
        cell.reorderBtn.isHidden = isAdmin
        return cell
    }
}

//MARK: - UITableViewDelegate

extension OrderHistoryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! OrderHistoryTVCell
        let history = histories[indexPath.row]
        touchAnim(cell, frValue: 0.8) {
            self.handlePushVC(history)
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
    
    private func handlePushVC(_ history: History) {
        let receiptVC = ReceiptVC()
        receiptVC.history = history
        receiptVC.isAdmin = isAdmin
        receiptVC.isDelivered = history.delivered
        receiptVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(receiptVC, animated: true)
    }
}

//MARK: - UINavigationControllerDelegate

extension OrderHistoryVC: UINavigationControllerDelegate {
    
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

//MARK: - OrderHistoryTVCellDelegate

extension OrderHistoryVC: OrderHistoryTVCellDelegate {
    
    func handleDidSelect(_ cell: OrderHistoryTVCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let history = histories[indexPath.row]
        handlePushVC(history)
    }
    
    func handleReorder(cell: OrderHistoryTVCell) {
        if isLogIn() {
            var isAdd = true
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            let history = histories[indexPath.row]
            let shoppingCart = ShoppingCart()
            
            guard history.shoppingCart.productCarts.count > 1 else {
                let prCart = history.shoppingCart.productCarts.first!
                let color = prCart.selectColor
                let size = prCart.selectSize
                Product.fetchPrFromUIDColorSize( prUID: prCart.prUID, color: color, size: size) { (product) in
                    guard isAdd else { return }
                    shoppingCart.addNewShoppingCart(product, color, size) {
                        self.successAlert()
                        handleBackToTabCart()
                        isAdd = false
                    }
                }
                
                return
            }
            
            var j = 0
            let prCarts = history.shoppingCart.productCarts
            for i in 0..<prCarts.count {
                let prUID = prCarts[i].prUID
                let color = prCarts[i].selectColor
                let size = prCarts[i].selectSize
                
                Product.fetchPrFromUIDColorSize( prUID: prUID, color: color, size: size) { (product) in
                    guard isAdd else { return }
                    shoppingCart.addNewShoppingCart(product, color, size) {
                        j += 1
                        isAdd = !(j == prCarts.count)
                        
                        if !isAdd {
                            self.successAlert()
                            handleBackToTabCart()
                        }
                    }
                }
            }
            
        } else {
            presentWelcomeVC(self, isPresent: true)
        }
    }
    
    func successAlert() {
        let cTxt = NSLocalizedString("Success", comment: "OrderHistoryVC.swift: Success")
        handleInternet(cTxt, imgName: "icon-checkmark")
    }
}

//MARK: - InternetViewDelegate

extension OrderHistoryVC: InternetViewDelegate {
    
    func handleReload() {
        handleBackToTabMore()
    }
}

//MARK: - DarkMode

extension OrderHistoryVC {
    
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
        tableView.backgroundColor = isDarkMode ? .black : .white
        notiLbl.textColor = isDarkMode ? .white : .black
        internetView.setupDarkMode(isDarkMode)
    }
}
