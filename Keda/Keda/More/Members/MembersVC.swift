//
//  MembersVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class MembersVC: UIViewController {
    
    //MARK: - Properties
    private let internetView = InternetView()
    let tableView = UITableView(frame: .zero, style: .grouped)
    private let naContainerV = UIView()
    private let refresh = UIRefreshControl()
    private var hud = HUD()
    
    private let backBtn = UIButton()
    private let titleLbl = UILabel()
    private let notiLbl = UILabel()
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    private lazy var usersOrderPlaced: [User] = []
    private lazy var users: [User] = []
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleObserve), name: Notification.Name("ReloadData"), object: nil)
        
        setupData()
    }
}

//MARK: - Configures

extension MembersVC {
    
    func setupNavi() {
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Title
        let title = NSLocalizedString("Members", comment: "MembersVC.swift: Members")
        titleLbl.configureTitleForNavi(naContainerV, isTxt: title)
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupTV() {
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        tableView.configureTVSepar(ds: self, dl: self, view: view)
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 70.0, bottom: 0.0, right: 15.0)
        tableView.separatorColor = lightSeparatorColor
        tableView.refreshControl = refresh
        tableView.register(MembersTVCell.self, forCellReuseIdentifier: MembersTVCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 50.0, right: 0.0)
        tableView.rowHeight = 60.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.async {
            delay(duration: 1.0) {
                self.getData()
                sender.endRefreshing()
            }
        }
    }
}

//MARK: - Functions

extension MembersVC {
    
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
    
    func setupData() {
        if users.count <= 0 {
            tableView.isHidden = true
            hud = createdHUD()
            getData(hud)
        }
    }
    
    func getData(_ hud: HUD = HUD()) {
        users.removeAll()
        User.fetchAllUsers { (users) in
            self.users = users.sorted(by: { $0.fullName < $1.fullName })
            self.tableView.reloadData()
            removeHUD(hud, duration: 0.5) {
                self.tableView.isHidden = self.users.count <= 0
            }
        }
        
        usersOrderPlaced.removeAll()
        History.fetchUsersFromOrderPlaced { (orderPlaced) in
            self.usersOrderPlaced = orderPlaced.sorted(by: { $0.orderDate < $1.orderDate })
            self.tableView.reloadData()
        }
    }

    
    @objc func handleObserve() {
        tableView.isHidden = true
        hud = createdHUD()
        getData(hud)
    }
}

//MARK: - UITableViewDataSource

extension MembersVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if usersOrderPlaced.count != 0 {
            return 2
            
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if usersOrderPlaced.count != 0 {
            switch section {
            case 0: return usersOrderPlaced.count
            default: return users.count
            }
            
        } else {
            return users.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if usersOrderPlaced.count != 0 {
            switch section {
            case 0:
                let cell = setupCell(tableView, indexPath, users: usersOrderPlaced, isHidden: false)
                let user = usersOrderPlaced[indexPath.row]
                fetchBadge(user, cell: cell)
                return cell
            default:
                let cell = setupCell(tableView, indexPath, users: users)
                return cell
            }
            
        } else {
            let cell = setupCell(tableView, indexPath, users: users)
            return cell
        }
    }
    
    private func setupCell(_ tv: UITableView, _ iP: IndexPath, users: [User], isHidden: Bool = true) -> MembersTVCell {
        let cell = tv.dequeueReusableCell(withIdentifier: MembersTVCell.identifier, for: iP) as! MembersTVCell
        let user = users[iP.row]
        cell.selectionStyle = .none
        cell.user = user
        cell.badgeLbl.isHidden = isHidden
        return cell
    }
    
    private func fetchBadge(_ user: User, cell: MembersTVCell) {
        History.fetchOrderPlacedFrom(userUID: user.uid) { (histories) in
            guard histories.count != 0 else {
                cell.setupBadge(cell.numberBadge)
                return
            }
            
            cell.numberBadge = histories.count
            cell.setupBadge(cell.numberBadge)
        }
    }
}

//MARK: - UITableViewDelegate

extension MembersVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MembersTVCell
        
        touchAnim(cell, frValue: 0.8) {
            let section = indexPath.section
            
            if self.usersOrderPlaced.count != 0 {
                switch section {
                case 0:
                    let user = self.usersOrderPlaced[indexPath.row]
                    self.handlePushVC(user)
                default:
                    let user = self.users[indexPath.row]
                    self.handlePushMemberDetailsVC(user)
                }
                
            } else {
                let user = self.users[indexPath.row]
                self.handlePushMemberDetailsVC(user)
            }
        }
    }
    
    func handlePushMemberDetailsVC(_ user: User) {
        let memberDetailsVC = MemberDetailsVC()
        memberDetailsVC.user = user
        navigationController?.pushViewController(memberDetailsVC, animated: true)
    }
    
    func handlePushVC(_ user: User, isDelivered: Bool = false) {
        let orderHistoryVC = OrderHistoryVC()
        orderHistoryVC.userUID = user.uid
        orderHistoryVC.isDelivered = isDelivered
        orderHistoryVC.isAdmin = true
        self.navigationController?.pushViewController(orderHistoryVC, animated: true)
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
        
        if usersOrderPlaced.count != 0 {
            switch section {
            case 0: orderPlacedLbl(kView)
            default: memberLbl(kView)
            }
            
        } else {
            memberLbl(kView)
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
    
    private func orderPlacedLbl(_ kView: UIView) {
        let orderLbl = UILabel()
        let txt = NSLocalizedString("ORDER PLACED", comment: "MembersVC.swift: ORDER PLACED")
        orderLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
        orderLbl.configureHeaderTitle(kView)
    }
    
    private func memberLbl(_ kView: UIView) {
        let memberLbl = UILabel()
        let txt = NSLocalizedString("MEMBERS", comment: "MembersVC.swift: MEMBERS")
        memberLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
        memberLbl.configureHeaderTitle(kView)
    }
}

//MARK: - UINavigationControllerDelegate

extension MembersVC: UINavigationControllerDelegate {
    
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

//MARK: - InternetViewDelegate

extension MembersVC: InternetViewDelegate {
    
    func handleReload() {
        handleBackToTabMore()
    }
}

//MARK: - DarkMode

extension MembersVC {
    
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
        tableView.separatorColor = isDarkMode ? darkSeparatorColor : lightSeparatorColor
        notiLbl.textColor = isDarkMode ? .white : .black
        internetView.setupDarkMode(isDarkMode)
        tableView.reloadData()
    }
}
