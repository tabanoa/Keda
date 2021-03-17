//
//  ReceiptVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ReceiptVC: UIViewController {
    
    //MARK: - Properties
    private let internetView = InternetView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let naContainerV = UIView()
    private let backBtn = UIButton()
    private let titleLbl = UILabel()
    private let confirmBtn = UIButton()
    
    var uid = ""
    var history: History!
    lazy var productCarts: [ProductCart] = []
    
    var isSuccess = false
    var isAdmin = false
    var isDelivered = false
    
    private lazy var updatingOrdersUID: [String] = []
    
    var modelU: NotificationUserModel?
    var userUID: String = ""
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        
        setupNavi()
        setupTV()
        setupDarkMode()
        
        guard isSuccess else { return }
        let txt = NSLocalizedString("Success", comment: "ReceiptVC.swift: Success")
        handleInternet(txt, imgName: "icon-checkmark") {}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard isInternetAvailable() else {
            naContainerV.isHidden = true
            tableView.isHidden = true
            internetView.setupInternetView(view, dl: self)
            return
        }
        
        if history == nil {
            History.fetchHistory(uid: uid) { (history) in
                self.history = history
                self.productCarts = self.history.shoppingCart.productCarts.sorted(by: { $0.createdTime > $1.createdTime })
                self.tableView.reloadData()
            }
            
        } else {
            productCarts = history.shoppingCart.productCarts.sorted(by: { $0.createdTime > $1.createdTime })
        }
        
        let shared = NotificationFor.sharedInstance
        shared.fetchNotificationFrom(child: shared.newArrival) { (updatingOrdersUID) in
            self.updatingOrdersUID = updatingOrdersUID
        }
        
        guard var modelU = modelU else { return }
        modelU.value = 0
        
        let notifU = NotificationUser()
        notifU.saveNotificationUser(userUID: userUID, modelU)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isSuccess = false
    }
}

//MARK: - Configures

extension ReceiptVC {
    
    func setupNavi() {
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Title
        let title = NSLocalizedString("Orders", comment: "ReceiptVC.swift: Orders")
        titleLbl.configureTitleForNavi(naContainerV, isTxt: title)
        
        guard isAdmin else { return }
        guard !isDelivered else { return }
        confirmBtn.configureFilterBtn(naContainerV, imgNamed: "icon-confirm", selector: #selector(confirmDidTap), controller: self)
    }
    
    @objc func confirmDidTap() {
        guard history != nil else { return }
        NotificationCenter.default.post(name: Notification.Name("ReloadData"), object: nil)
        
        var isBuyed = true
        var count = 0
        let hud = createdHUD()
        
        history.updateDelivered {
            let prCarts = self.history.shoppingCart.productCarts
            prCarts.forEach({
                guard isBuyed else { return }
                let buyed = Buyed()
                buyed.saveBuyed(prUID: $0.prUID)
                count += 1
                if count >= prCarts.count { isBuyed = false }
            })
            
            delay(duration: 1.0) {
                hud.removeFromSuperview()
                
                for vc in self.navigationController!.viewControllers {
                    if vc.isKind(of: MembersVC.self) {
                        self.navigationController?.popToViewController(vc, animated: true)
                        (vc as! MembersVC).getData()
                        (vc as! MembersVC).tableView.reloadData()
                    }
                }
            }
        }
        
        let userUID = history.userUID
        let leftTxt = NSLocalizedString("Updating Orders - ", comment: "ReceiptVC.swift: Updating Orders - ")
        let title = "\(leftTxt)\(history.codeOrder)"
        let body = NSLocalizedString("Delivered", comment: "ReceiptVC.swift: Delivered")
        
        guard updatingOrdersUID.contains(userUID) else { return }
        pushNotificationTo(toUID: userUID, title: title, body: body)
        
        let modelFB = NotificationModel(title: title, body: body, prUID: history.uid, type: updatingOrdersKey)
        let notif = NotificationFB(model: modelFB)
        
        notif.saveNotification {
            let modelU = NotificationUserModel(notifUID: notif.uid, value: 1)
            let notifU = NotificationUser()
            notifU.saveNotificationUser(userUID: userUID, modelU)
        }
    }
    
    @objc func backDidTap() {
        for vc in navigationController!.viewControllers {
            if vc.isKind(of: CartVC.self) {
                navigationController?.popToViewController(vc, animated: true)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func setupTV() {
        tableView.configureTVNonSepar(ds: self, dl: self, view: view)
        tableView.register(CodeOrderTVCell.self, forCellReuseIdentifier: CodeOrderTVCell.identifier)
        tableView.register(AddressTVCell.self, forCellReuseIdentifier: AddressTVCell.identifier)
        tableView.register(DeliveryTVCell.self, forCellReuseIdentifier: DeliveryTVCell.identifier)
        tableView.register(PaymentMethodTVCell.self, forCellReuseIdentifier: PaymentMethodTVCell.identifier)
        tableView.register(ItemTVCell.self, forCellReuseIdentifier: ItemTVCell.identifier)
        tableView.register(SubtotalTVCell.self, forCellReuseIdentifier: SubtotalTVCell.identifier)
        tableView.register(TotalTVCell.self, forCellReuseIdentifier: TotalTVCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 50.0, right: 0.0)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - UITableViewDataSource

extension ReceiptVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 { return productCarts.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CodeOrderTVCell.identifier, for: indexPath) as! CodeOrderTVCell
            cell.selectionStyle = .none
            let codeOrder = NSLocalizedString("Code order: ", comment: "ReceiptVC.swift: Code order: ")
            cell.codeOrdersLbl.text = codeOrder + history.codeOrder
            
            let dateOrder = NSLocalizedString("Date order: ", comment: "ReceiptVC.swift: Date order: ")
            
            let f = DateFormatter()
            f.dateFormat = "dd/MM/yyyy"
            
            let date = dateFormatter().date(from: history.uid)!
            let dateTxt = f.string(from: date)
            cell.dateOrderedLbl.text = dateOrder + dateTxt
            
            let state = NSLocalizedString("State: ", comment: "ReceiptVC.swift: State: ")
            let orderPTxt = NSLocalizedString("Order Placed", comment: "ReceiptVC.swift: Order Placed")
            let deliveredTxt = NSLocalizedString("Delivered", comment: "ReceiptVC.swift: Delivered")
            
            let stateTxt = history.delivered ? deliveredTxt : orderPTxt
            setupDM(cell.stateLbl, str1: state, str2: stateTxt)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddressTVCell.identifier, for: indexPath) as! AddressTVCell
            cell.selectionStyle = .none
            
            let titleTxt = NSLocalizedString("Receiver's address", comment: "ReceiptVC.swift: Receiver's address")
            cell.titleLbl.text = titleTxt
            
            let addr = history.address
            cell.fullNameLbl.text = addr.firstName + " " + addr.lastName
            cell.phoneNumberLbl.text = addr.phoneNumber
            cell.streetLine1Lbl.text = addr.addrLine1
            cell.streetLine2Lbl.text = addr.addrLine2
            cell.streetLine2Lbl.isHidden = addr.addrLine2 == "" || addr.addrLine2 == nil
            cell.cityLbl.text = addr.city
            cell.stateLbl.text = addr.state
            cell.countryLbl.text = addr.country
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryTVCell.identifier, for: indexPath) as! DeliveryTVCell
            cell.selectionStyle = .none
            
            let deliveryTxt = NSLocalizedString("Forms of delivery", comment: "ReceiptVC.swift: Forms of delivery")
            cell.titleLbl.text = deliveryTxt
            
            let contentTxt = NSLocalizedString("Standard Saver", comment: "ReceiptVC.swift: Standard Saver")
            cell.contentLbl.text = contentTxt
            cell.dateLbl.text = getDate()
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodTVCell.identifier, for: indexPath) as! PaymentMethodTVCell
            cell.selectionStyle = .none
            
            let titleTxt = NSLocalizedString("Payment method", comment: "ReceiptVC.swift: Payment method")
            cell.titleLbl.text = titleTxt
            
            let txt1: String
            let txt2: String
            let paidByTxt = NSLocalizedString("Paid by ", comment: "ReceiptVC.swift: Paid by ")
            if history.paymentMethod == "Paid by Visa" {
                txt1 = paidByTxt
                txt2 = "Visa"
                
            } else if history.paymentMethod == "Cash payment on delivery" {
                txt1 = NSLocalizedString("Cash payment on delivery", comment: "ReceiptVC.swift: Cash payment on delivery")
                txt2 = ""
                
            } else if history.paymentMethod == "Paid by Apple Pay" {
                txt1 = paidByTxt
                txt2 = "Apple Pay"
                
            } else {
                txt1 = paidByTxt
                txt2 = "PayPal"
            }
            
            setupDM(cell.contentLbl, str1: txt1, str2: txt2)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemTVCell.identifier, for: indexPath) as! ItemTVCell
            cell.selectionStyle = .none
            cell.product = productCarts[indexPath.row]
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: SubtotalTVCell.identifier, for: indexPath) as! SubtotalTVCell
            cell.selectionStyle = .none
            cell.shoppingCart = history.shoppingCart
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: TotalTVCell.identifier, for: indexPath) as! TotalTVCell
            cell.selectionStyle = .none
            cell.shoppingCart = history.shoppingCart
            return cell
        }
    }
    
    private func setupDM(_ lbl: UILabel, str1: String, str2: String) {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                lbl.attributedText = setupAttributed(str1: str1, str2: str2)
            case .dark:
                lbl.attributedText = setupAttributed(str1: str1, str2: str2, true)
            default: break
            }
        } else {
            lbl.attributedText = setupAttributed(str1: str1, str2: str2)
        }
    }
    
    func setupAttributed(str1: String, str2: String, _ isDarkMode: Bool = false) -> NSMutableAttributedString {
        let txtC: UIColor = isDarkMode ? .lightGray : .darkGray
        let at1 = [NSAttributedString.Key.font: UIFont(name: fontNamed, size: 16.0)!,
                     NSAttributedString.Key.foregroundColor: txtC]
        let attr1 = NSAttributedString(string: str1, attributes: at1)
        
        let at2 = [NSAttributedString.Key.font: UIFont(name: fontNamedBold, size: 16.0)!,
                   NSAttributedString.Key.foregroundColor: txtC]
        let attr2 = NSAttributedString(string: str2, attributes: at2)
        
        let attributed = NSMutableAttributedString()
        attributed.append(attr1)
        attributed.append(attr2)
        
        return attributed
    }
    
    private func getDate() -> String {
        let cDate = Date()
        let fDate = Date(timeIntervalSinceNow: TimeInterval((5*24*60*60)))
        let f = DateFormatter()
        f.dateFormat = "dd/MM"
        
        let currentDay = f.string(from: cDate)
        let futureDay = f.string(from: fDate)
        let str = currentDay + " - " + "\(futureDay)"
        return str
    }
}

//MARK: - UITableViewDelegate

extension ReceiptVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 100.0
        case 1: return 220.0
        case 2: return 100.0
        case 3: return 80.0
        case 4:
            let height = CGFloat(3*(5+30))
            let spacing = CGFloat(10*3)
            
            if appDl.iPhone5 { return CGFloat(31+height+18+spacing) }
            return CGFloat(36+height+21+spacing)
        case 5: return 95.0
        default: return 60.0
        }
    }
}

//MARK: - InternetViewDelegate

extension ReceiptVC: InternetViewDelegate {
    
    func handleReload() {
        handleBackToTabMore()
    }
}

//MARK: - DarkMode

extension ReceiptVC {
    
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
    }
}
