//
//  MoreVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Firebase

class MoreVC: UIViewController {
    
    //MARK: - Properties
    private let internetView = InternetView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let headerView = MoreHeaderView()
    private var imagePickerHelper: ImagePickerHelper?
    
    let isMoreVC = true
    private var tapCount = 0
    
    private var user: User?
    private var isAvatar = false
    
    lazy var memberProfiles: [Profile] = {
        return Profile.fetchDataForMember()
    }()
    
    lazy var profilesForAdmin: [Profile] = {
        return Profile.fetchDataForAdmin()
    }()
    
    lazy var profiles: [Profile] = []
    private var isAdmin = false
    
    private var isOrderPlaced: Bool? = nil
    private var notifU: NotificationUser?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHeaderView()
        setupDarkMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard isInternetAvailable() else {
            tableView.isHidden = true
            internetView.setupInternetView(view, dl: self)
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSelectedIndex), name: Notification.Name("DismissHomeVC"), object: nil)
        
        tableView.isHidden = true
        
        if isLogIn() {
            fetchData()
            
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
    }
}

//MARK: - Configures

extension MoreVC {
    
    func setupTableView() {
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("Profile", comment: "MoreVC.swift: Profile")
        
        tableView.configureTVNonSepar(ds: self, dl: self, view: view)
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 100.0, right: 0.0)
        tableView.register(ProfileTVCell.self, forCellReuseIdentifier: ProfileTVCell.identifier)
        tableView.register(MoreMembersTVCell.self, forCellReuseIdentifier: MoreMembersTVCell.identifier)
        tableView.register(MoreNotificationsTVCell.self, forCellReuseIdentifier: MoreNotificationsTVCell.identifier)
        tableView.register(LogoutTVCell.self, forCellReuseIdentifier: LogoutTVCell.identifier)
        tableView.rowHeight = 60.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupHeaderView() {
        tableView.tableHeaderView?.backgroundColor = .clear
        headerView.setupHeaderView(tableView, dl: self, animDl: self)
    }
}

//MARK: - Functions

extension MoreVC {
    
    @objc func handleSelectedIndex() {
        handleBackToTabHome()
    }
    
    func updateUI() {
        guard let user = user else { return }
        headerView.nameLbl.text = user.fullName
        
        if user.type == "admin" {
            self.headerView.prefixLbl.text = user.type.capitalized
            self.headerView.prefixLbl.font = UIFont(name: fontNamedBold, size: 30.0)
            self.headerView.subnameLbl.text = "AD"
            
        } else {
            user.fullName.fetchFirstLastName { (fn, ln) in
                self.headerView.prefixLbl.text = "\(fn.prefix(1) + ln.prefix(1))".uppercased()
                self.headerView.subnameLbl.text = nil
            }
        }
        
        guard let link = user.avatarLink else {
            isAvatar = false
            headerView.prefixLbl.isHidden = false
            headerView.avatarImg = nil
            return
        }
        
        user.downloadAvatar(link: link) { (image) in
            DispatchQueue.main.async {
                self.isAvatar = true
                self.headerView.prefixLbl.isHidden = true
                self.headerView.avatarImg = image
            }
        }
    }
    
    func fetchData() {
        if tableView.contentOffset.y > 0 { tapCount = 1 }
        User.fetchUserFromUID { (user) in
            self.user = user
            self.updateUI()
            
            guard let user = self.user else { return }
            self.profiles = user.type == "admin" ? self.profilesForAdmin : self.memberProfiles
            self.isAdmin = user.type == "admin"
            self.tableView.isHidden = false
            self.reloadData()
        }
        
        fetchNotif()
        fetchOrderPlaced()
    }
    
    func fetchNotif() {
        NotificationUser.fetchNotifUIDFromUser { (notifU) in
            self.notifU = notifU
            self.reloadData()
        }
    }
    
    func fetchOrderPlaced() {
        History.fetchOrderPlacedFrom { (isOrderPlaced) in
            self.isOrderPlaced = isOrderPlaced
            self.reloadData()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource

extension MoreVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return profiles.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if isAdmin {
                if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: MoreMembersTVCell.identifier, for: indexPath) as! MoreMembersTVCell
                    let profile = profiles[indexPath.row]
                    cell.titleLbl.text = profile.title
                    cell.iconImgView.image = profile.image
                    cell.badgeLbl.isHidden = isOrderPlaced == nil
                    return cell
                    
                } else if indexPath.row == 6 {
                    return setupCellIndex6(tableView, indexPath: indexPath)
                    
                } else {
                    return setupCell(tableView, indexPath: indexPath)
                }
                
            } else {
                if indexPath.row == 6 {
                    return setupCellIndex6(tableView, indexPath: indexPath)
                    
                } else {
                    return setupCell(tableView, indexPath: indexPath)
                }
            }
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LogoutTVCell.identifier, for: indexPath) as! LogoutTVCell
            return cell
        }
    }
    
    private func setupCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTVCell.identifier, for: indexPath) as! ProfileTVCell
        let profile = profiles[indexPath.row]
        cell.titleLbl.text = profile.title
        cell.iconImgView.image = profile.image
        return cell
    }
    
    private func setupCellIndex6(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoreNotificationsTVCell.identifier, for: indexPath) as! MoreNotificationsTVCell
        let profile = profiles[indexPath.row]
        cell.titleLbl.text = profile.title
        cell.iconImgView.image = profile.image
        if let notifU = notifU {
            cell.numberBadge = notifU.count
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension MoreVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        
        if section == 0 {
            let row = indexPath.row
            switch row {
            case 0: handleEditProfileVC()
            case 1: isAdmin ? handleMembersVC() : handleOrderHistoryVC()
            case 2: handleSettingsVC()
            case 3: handleContactUsVC()
            case 4: handleClearWatchHistory()
            case 5: handleClearSearchHistory()
            case 6: handleChats()
            default: handleNotifications()
            }
            
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! LogoutTVCell
            touchAnim(cell) {
                guard isInternetAvailable() else {
                    internetNotAvailable()
                    return
                }
                
                User.disconnected()
                
                let hud = createdHUD()
                self.tabBarController?.tabBar.selectionIndicatorImage = UIImage()
                
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
    
    private func handleEditProfileVC() {
        let editProfileVC = EditProfileVC()
        if let user = user {
            user.fullName.fetchFirstLastName { (fn, ln) in
                editProfileVC.firstName = fn
                editProfileVC.lastName = ln
            }
            
            editProfileVC.email = user.email
            editProfileVC.phoneNumber = user.phoneNumber
            editProfileVC.userUID = user.uid
        }
        
        editProfileVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    private func handleMembersVC() {
        let membersVC = MembersVC()
        membersVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(membersVC, animated: true)
    }
    
    private func handleOrderHistoryVC() {
        let orderHistoryVC = OrderHistoryVC()
        orderHistoryVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(orderHistoryVC, animated: true)
    }
    
    private func handleSettingsVC() {
        let settingsVC = SettingsVC()
        if let user = user { settingsVC.email = user.email }
        settingsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    private func handleContactUsVC() {
        let contactUsVC = ContactUsVC()
        contactUsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(contactUsVC, animated: true)
    }
    
    private func handleClearWatchHistory() {
        let txt = NSLocalizedString("Clear watch history?", comment: "MoreVC.swift: Clear watch history?")
        handleMessageAlert(vc: self, txt: txt, traitCollection: traitCollection) {
            appDl.deleteRecentlyViewed()
        }
    }
    
    private func handleClearSearchHistory() {
        let txt = NSLocalizedString("Clear search history?", comment: "MoreVC.swift: Clear search history?")
        handleMessageAlert(vc: self, txt: txt, traitCollection: traitCollection) {
            appDl.deleteRecentSearches()
        }
    }
    
    private func handleNotifications() {
        let notificationVC = NotificationVC()
        notificationVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(notificationVC, animated: true)
    }
    //Handles the chat view controller
    private func handleChats() {
        let ChatsVC = ChatVC()
        ChatsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(ChatsVC, animated: true)
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

//MARK: - MoreHeaderViewDelegate

extension MoreVC: MoreHeaderViewDelegate {
    
    func handleEditAvatarDidTap() {
        guard isInternetAvailable() else {
            internetNotAvailable()
            return
        }
        
        imagePickerHelper = ImagePickerHelper(vc: self, completion: { (image) in
            guard let user = self.user, let image = image else { return }
            let hud = createdHUD()
            Imgur.sharedInstance.uploadImageToImgur(image) { (link) in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5, animations: {
                        hud.alpha = 0.0
                    }) { (_) in
                        hud.removeFromSuperview()
                        user.saveAvatar(link)
                        self.updateUI()
                        self.headerView.setupGradientAvatarEditBtn(animDl: self)
                    }
                }
            }
        })
    }
}

//MARK: - UITabBarControllerDelegate

extension MoreVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 4 {
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

extension MoreVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tapCount += 1
        if tapCount >= 2 { tapCount = 1 }
    }
}

//MARK: - CAAnimationDelegate

extension MoreVC: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        headerView.editAvatarBtn.setImage(UIImage(named: "icon-pencil")?.withRenderingMode(.alwaysTemplate), for: .normal)
        headerView.isEdit = true
        headerView.prefixLbl.isHidden = isAvatar
        headerView.avatarImgView.image = headerView.avatarImg
        headerView.subnameLbl.isHidden = headerView.subnameLbl.text == nil
        
        if !headerView.prefixLbl.isHidden {
            let gradientLayer = createGradientLayer(width: 120.0, height: 50.0, startC: defaultColor, endC: UIColor(hex: 0xFF7B14))
            headerView.prefixView.layer.addSublayer(gradientLayer)
            headerView.prefixView.mask = headerView.prefixLbl
        }
        
        if !headerView.subnameLbl.isHidden {
            headerView.subnameLbl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.333) {
                    self.headerView.subnameLbl.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.334, relativeDuration: 0.333) {
                    self.headerView.subnameLbl.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.666, relativeDuration: 0.333) {
                    self.headerView.subnameLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }, completion: nil)
        }
    }
}

//MARK: - InternetViewDelegate

extension MoreVC: InternetViewDelegate {
    
    func handleReload() {
        handleBackToTabMore()
    }
}

//MARK: - DarkMode

extension MoreVC {
    
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
        headerView.setupDarkMode(isDarkMode)
        tableView.backgroundColor = isDarkMode ? .black : .white
        tableView.reloadData()
        appDl.window?.tintColor = isDarkMode ? .white : .black
    }
}
