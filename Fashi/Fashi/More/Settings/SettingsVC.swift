//
//  SettingsVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import MessageUI
import Firebase

class SettingsVC: UIViewController {
    
    //MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let naContainerV = UIView()
    private let changePassLbl = UILabel()
    private let updatingOrdersLbl = UILabel()
    private let newArrivalLbl = UILabel()
    private let promotionLbl = UILabel()
    private let saleOffLbl = UILabel()
    private let supportLbl = UILabel()
    private let logOutLbl = UILabel()
    
    private let updatingOrdersSw = UISwitch()
    private let newArrivalSw = UISwitch()
    private let promotionSw = UISwitch()
    private let saleOffSw = UISwitch()
    
    var email = ""
    private let backBtn = UIButton()
    private let titleLbl = UILabel()
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    var isTurnOn = false
    var updatingOrdersTurnOn = false
    var newArrivalTurnOn = false
    var promotionTurnOn = false
    var saleOffTurnOn = false
    
    private let shared = NotificationFor.sharedInstance
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupTV()
        setupDarkMode()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
        
        setupObserve()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        confNotif()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Configures

extension SettingsVC {
    
    func setupNavi() {
        view.backgroundColor = groupColor
        navigationItem.setHidesBackButton(true, animated: false)
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Title
//        let title = "Cài Đặt"
        let title = NSLocalizedString("Settings", comment: "SettingsVC.swift: Settings")
        titleLbl.configureTitleForNavi(naContainerV, isTxt: title)
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupTV() {
        tableView.configureTVSepar(groupColor, ds: self, dl: self, view: view)
        tableView.separatorColor = lightSeparatorColor
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsTVCell")
        tableView.rowHeight = 50.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - Functions

extension SettingsVC {
    
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
    
    func confNotif() {
        configureNotification { (status) in
            DispatchQueue.main.async {
                self.isTurnOn = status == .authorized
                self.confData()
            }
        }
    }
    
    func confData() {
        guard isTurnOn else {
            updatingOrdersTurnOn = false
            newArrivalTurnOn = false
            promotionTurnOn = false
            saleOffTurnOn = false
            tableView.reloadData()
            return
        }
        
        shared.fetchNotificationFrom(child: shared.updatingOrders) { (array) in
            self.updatingOrdersTurnOn = array.contains(currentUID)
            self.reloadData()
        }
        
        shared.fetchNotificationFrom(child: shared.newArrival) { (array) in
            self.newArrivalTurnOn = array.contains(currentUID)
            self.reloadData()
        }
        
        shared.fetchNotificationFrom(child: shared.promotion) { (array) in
            self.promotionTurnOn = array.contains(currentUID)
            self.reloadData()
        }
        
        shared.fetchNotificationFrom(child: shared.saleOff) { (array) in
            self.saleOffTurnOn = array.contains(currentUID)
            self.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource

extension SettingsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 4
            
        } else if section == 2 {
            return 2
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTVCell", for: indexPath)
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            let txt = NSLocalizedString("Change Password", comment: "SettingsVC.swift: Change Password")
            let fontC: UIColor = email.contains("Facebook") ? .lightGray : .systemBlue
            setupLabel(changePassLbl, text: txt, fontC: fontC, fontN: fontNamedBold, cell: cell)
            cell.accessoryType = email.contains("Facebook") ? .none : .disclosureIndicator
            
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let txt = NSLocalizedString("Order Updates", comment: "SettingsVC.swift: Order Updates")
                setupLabel(updatingOrdersLbl, text: txt, cell: cell)
                setupSwitch(updatingOrdersSw,
                            turnOn: updatingOrdersTurnOn,
                            cell: cell,
                            selector: #selector(updatingOrdersSwitch(_:)))
            case 1:
                let txt = NSLocalizedString("New Arrivals", comment: "SettingsVC.swift: New Arrivals")
                setupLabel(newArrivalLbl, text: txt, cell: cell)
                setupSwitch(newArrivalSw,
                            turnOn: newArrivalTurnOn,
                            cell: cell,
                            selector: #selector(newArrivalSwitch(_:)))
            case 2:
                let txt = NSLocalizedString("Promotions", comment: "SettingsVC.swift: Promotions")
                setupLabel(promotionLbl, text: txt, cell: cell)
                setupSwitch(promotionSw,
                            turnOn: promotionTurnOn,
                            cell: cell,
                            selector: #selector(promotionSwitch(_:)))
            default:
                let txt = NSLocalizedString("Sales Alerts", comment: "SettingsVC.swift: Sales Alerts")
                setupLabel(saleOffLbl, text: txt, cell: cell)
                setupSwitch(saleOffSw,
                            turnOn: saleOffTurnOn,
                            cell: cell,
                            selector: #selector(saleOffSwitch(_:)))
            }
            
        } else {
            switch indexPath.row {
            case 0:
                let txt = NSLocalizedString("Support", comment: "SettingsVC.swift: Support")
                setupSupportLabel(supportLbl, text: txt, cell: cell)
            default:
                let txt = NSLocalizedString("Log Out", comment: "SettingsVC.swift: Log Out")
                setupSupportLabel(logOutLbl, text: txt, cell: cell)
            }
        }
        
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupDMLbl()
            case .dark: setupDMLbl(true)
            default: break
            }
        } else {
            setupDMLbl()
        }
        
        return cell
    }
    
    @objc func updatingOrdersSwitch(_ sender: UISwitch) {
        if sender.isOn {
            guard isTurnOn else { openSettingURL(); return }
            shared.addNotificationWith(child: shared.updatingOrders) { self.reloadData() }
            
        } else {
            updatingOrdersTurnOn = false
            shared.removeNotificationFrom(child: shared.updatingOrders) { self.reloadData() }
        }
    }
    
    @objc func newArrivalSwitch(_ sender: UISwitch) {
        if sender.isOn {
            guard isTurnOn else { openSettingURL(); return }
            retrievingAndAddOrRemoveNotification(keyName: notifKeyNewArrival, operation: "add", ids: [appDl.tokenKey])
            shared.addNotificationWith(child: shared.newArrival) { self.reloadData() }
            
        } else {
            newArrivalTurnOn = false
            retrievingAndAddOrRemoveNotification(keyName: notifKeyNewArrival, operation: "remove", ids: [appDl.tokenKey])
            shared.removeNotificationFrom(child: shared.newArrival) { self.reloadData() }
        }
    }
    
    @objc func promotionSwitch(_ sender: UISwitch) {
        if sender.isOn {
            guard isTurnOn else { openSettingURL(); return }
            retrievingAndAddOrRemoveNotification(keyName: notifKeyPromotion, operation: "add", ids: [appDl.tokenKey])
            shared.addNotificationWith(child: shared.promotion) { self.reloadData() }
            
        } else {
            promotionTurnOn = false
            retrievingAndAddOrRemoveNotification(keyName: notifKeyPromotion, operation: "remove", ids: [appDl.tokenKey])
            shared.removeNotificationFrom(child: shared.promotion) { self.reloadData() }
        }
    }
    
    @objc func saleOffSwitch(_ sender: UISwitch) {
        if sender.isOn {
            guard isTurnOn else { openSettingURL(); return }
            retrievingAndAddOrRemoveNotification(keyName: notifKeySaleOff, operation: "add", ids: [appDl.tokenKey])
            shared.addNotificationWith(child: shared.saleOff) { self.reloadData() }
            
        } else {
            saleOffTurnOn = false
            retrievingAndAddOrRemoveNotification(keyName: notifKeySaleOff, operation: "remove", ids: [appDl.tokenKey])
            shared.removeNotificationFrom(child: shared.saleOff) { self.reloadData() }
        }
    }
    
    func setupLabel(_ lbl: UILabel, text: String, fontC: UIColor = .black, fontN: String = fontNamed, cell: UITableViewCell) {
        lbl.configureNameForCell(false, txtColor: fontC, fontSize: 17.0, isTxt: text, fontN: fontN)
        cell.contentView.addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lbl.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            lbl.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15.0)
        ])
    }
    
    func setupSwitch(_ sw: UISwitch, turnOn: Bool, cell: UITableViewCell, selector: Selector) {
        sw.isOn = turnOn
        sw.addTarget(self, action: selector, for: .valueChanged)
        cell.contentView.addSubview(sw)
        sw.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sw.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            sw.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15.0),
        ])
    }
    
    func setupSupportLabel(_ lbl: UILabel, text: String, cell: UITableViewCell) {
        lbl.configureNameForCell(false, txtColor: .systemBlue, fontSize: 17.0, isTxt: text, fontN: fontNamedBold)
        cell.contentView.addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lbl.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            lbl.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
        ])
    }
}

//MARK: - UITableViewDelegate

extension SettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        if indexPath.section == 0 {
            guard !email.contains("Facebook") else { return }
            touchAnim(cell) {
                let changePasswordVC = ChangePasswordVC()
                if !self.email.isEmpty { changePasswordVC.email = self.email }
                changePasswordVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(changePasswordVC, animated: true)
            }
            
        } else if indexPath.section == 2 {
            if indexPath.item == 0 {
                touchAnim(cell) {
                    configureMail(self, email: "fashi-support@gmail.com", vc: self)
                }
                
            } else {
                touchAnim(cell) {
                    guard isInternetAvailable() else { internetNotAvailable(); return }
                    User.disconnected()
                    
                    let hud = createdHUD()
                    delay(duration: 1.0) {
                        UIView.animate(withDuration: 0.5, animations: {
                            hud.alpha = 0.0
                        }) { (_) in
                            hud.removeFromSuperview()
                            try! Auth.auth().signOut()
                            handleBackToTabHome()
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let kView = UIView().configureHeaderView(view, tableView: tableView)
        
        if section == 0 {
            let securityLbl = UILabel()
            let txt = NSLocalizedString("SECURITY", comment: "SettingsVC.swift: SECURITY")
            securityLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
            securityLbl.configureHeaderTitle(kView)
            
        } else if section == 1 {
            let notificationLbl = UILabel()
            let txt = NSLocalizedString("PUSH NOTIFICATIONS", comment: "SettingsVC.swift: PUSH NOTIFICATIONS")
            notificationLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
            notificationLbl.configureHeaderTitle(kView)
            
        } else if section == 2 {
            let accountLbl = UILabel()
            let txt = NSLocalizedString("ACCOUNT", comment: "SettingsVC.swift: ACCOUNT")
            accountLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
            accountLbl.configureHeaderTitle(kView)
        }
        
        if #available(iOS 12.0, *) {
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

//MARK: - Observe

extension SettingsVC {
    
    private func setupObserve() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidEnterBG),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillResignActive),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    @objc private func appDidEnterBG() {
        print("*** appDidEnterBG")
    }
    
    @objc private func appDidBecomeActive() {
        confNotif()
    }
    
    @objc private func appWillResignActive() {
        print("*** appWillResignActive")
    }
}

//MARK: - UINavigationControllerDelegate

extension SettingsVC: UINavigationControllerDelegate {
    
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

//MARK: - MFMailComposeViewControllerDelegate

extension SettingsVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - DarkMode

extension SettingsVC {
    
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
        tableView.separatorColor = isDarkMode ? darkSeparatorColor : lightSeparatorColor
        setupDMLbl(isDarkMode)
        tableView.reloadData()
    }
    
    private func setupDMLbl(_ isDarkMode: Bool = false) {
        let fontCLight: UIColor = email.contains("Facebook") ? .lightGray : .systemBlue
        let fontCDark: UIColor = email.contains("Facebook") ? .lightGray : UIColor(hex: 0x2687FB)
        changePassLbl.textColor = isDarkMode ? fontCDark : fontCLight
        updatingOrdersLbl.textColor = isDarkMode ? .white : .black
        newArrivalLbl.textColor = isDarkMode ? .white : .black
        promotionLbl.textColor = isDarkMode ? .white : .black
        saleOffLbl.textColor = isDarkMode ? .white : .black
        supportLbl.textColor = isDarkMode ? UIColor(hex: 0x2687FB) : .systemBlue
        logOutLbl.textColor = isDarkMode ? UIColor(hex: 0x2687FB) : .systemBlue
    }
}
