//
//  NotificationVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class NotificationVC: UIViewController {
    
    //MARK: - Properties
    private let internetView = InternetView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let refresh = UIRefreshControl()
    private let naContainerV = UIView()
    
    private let backBtn = UIButton()
    private let titleLbl = UILabel()
    private let readedBtn = UIButton()
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    private var notifU: NotificationUser!
    private lazy var notifUsers: [NotificationUserModel] = []
    var isPop = false
    
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
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        guard isInternetAvailable() else {
            naContainerV.isHidden = true
            tableView.isHidden = true
            internetView.setupInternetView(view, dl: self)
            return
        }
        
        fetchData()
    }
    
    func fetchData() {
        NotificationUser.fetchNotifUIDFromUser { (notifU) in
            self.notifU = notifU
            
            guard let notifU = self.notifU else { return }
            self.notifUsers = notifU.models.sorted(by: { $0.notifUID > $1.notifUID })
            self.tableView.reloadData()
        }
    }
}

//MARK: - Configures

extension NotificationVC {
    
    func setupNavi() {
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Readed
        readedBtn.configureFilterBtn(naContainerV, imgNamed: "icon-readed", selector: #selector(readedDidTap), controller: self)
        
        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Title
        let title = NSLocalizedString("Notifications", comment: "NotificationVC.swift: Notifications")
        titleLbl.configureTitleForNavi(naContainerV, isTxt: title)
    }
    
    @objc func readedDidTap() {
        updateReadAll {
            self.fetchData()
        }
    }
    
    func updateReadAll(completion: @escaping () -> Void) {
        notifUsers.forEach({
            let notifUID = $0.notifUID
            let modelU = NotificationUserModel(notifUID: notifUID, value: 0)
            let notifU = NotificationUser()
            notifU.saveNotificationUser(userUID: self.notifU!.userUID, modelU)
            DispatchQueue.main.async {
                completion()
            }
        })
    }
    
    @objc func backDidTap() {
        guard !isPop else {
            handleBackToTabHome()
            return
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func setupTV() {
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        tableView.configureTVSepar(ds: self, dl: self, view: view)
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 65.0, bottom: 0.0, right: 15.0)
        tableView.separatorColor = lightSeparatorColor
        tableView.refreshControl = refresh
        tableView.register(NotificationTVCell.self, forCellReuseIdentifier: NotificationTVCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 50.0, right: 0.0)
        tableView.rowHeight = 100.0
        
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
                self.fetchData()
                sender.endRefreshing()
            }
        }
    }
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        guard !isPop else {
            handleBackToTabHome()
            return
        }
        
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
}

//MARK: - UITableViewDataSource

extension NotificationVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTVCell.identifier, for: indexPath) as! NotificationTVCell
        cell.modelU = notifUsers[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NotificationVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! NotificationTVCell
        let modelU = notifUsers[indexPath.row]
        
        touchAnim(cell, frValue: 0.8) {
            if cell.type == saleOffKey {
                self.pushVC(cell, modelU: modelU)
                
            } else if cell.type == newArrivalKey {
                self.pushVC(cell, modelU: modelU)
                
            } else if cell.type == updatingOrdersKey {
                let receiptVC = ReceiptVC()
                receiptVC.uid = cell.history!.uid
                receiptVC.history = cell.history
                receiptVC.modelU = modelU
                receiptVC.userUID = self.notifU.userUID
                receiptVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(receiptVC, animated: true)
                
            } else {
                return
            }
        }
    }
    
    private func pushVC(_ cell: NotificationTVCell, modelU: NotificationUserModel) {
        let prVC = ProductVC()
        prVC.product = cell.product
        prVC.modelU = modelU
        prVC.userUID = notifU.userUID
        prVC.isFilteredVC = true
        navigationController?.pushViewController(prVC, animated: true)
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

//MARK: - UINavigationControllerDelegate

extension NotificationVC: UINavigationControllerDelegate {
    
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

extension NotificationVC: InternetViewDelegate {
    
    func handleReload() {
        handleBackToTabMore()
    }
}

//MARK: - DarkMode

extension NotificationVC {
    
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
        internetView.setupDarkMode(isDarkMode)
    }
}
