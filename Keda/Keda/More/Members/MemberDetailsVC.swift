//
//  MemberDetailsVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class MemberDetailsVC: UIViewController {
    
    //MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let headerView = MemberDetailsHV()
    private let naContainerV = UIView()
    private let backBtn = UIButton()
    private let titleLbl = UILabel()
    
    var user: User!
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        
        setupNavi()
        setupTableView()
        setupHeaderView()
        setupDarkMode()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
}

//MARK: - Configures

extension MemberDetailsVC {
    
    func setupNavi() {
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Title
        let title = NSLocalizedString("Details", comment: "MemberDetailsVC.swift: Details")
        titleLbl.configureTitleForNavi(naContainerV, isTxt: title)
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupTableView() {
        tableView.configureTVSepar(ds: self, dl: self, view: view)
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        tableView.separatorColor = lightSeparatorColor
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 100.0, right: 0.0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MemberDetailsTVCell")
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
        headerView.setupHeaderView(tableView)
    }
    
    func updateUI() {
        Wishlist.fetchPrFromWishlist(userUID: user.uid) { (products) in
            guard products.count != 0 else {
                self.headerView.wishlistLbl.text = "\(0)"
                return
            }
            
            handleText(Double(products.count)) { (txt) in
                self.headerView.wishlistLbl.text = txt
                self.tableView.reloadData()
            }
        }
        
        History.fetchDeliveredFrom(userUID: user.uid) { (histories) in
            guard histories.count != 0 else {
                self.headerView.boughtLbl.text = "\(0)"
                return
            }
            
            handleText(Double(histories.count)) { (txt) in
                self.headerView.boughtLbl.text = txt
                self.tableView.reloadData()
            }
        }
        
        user.fullName.fetchFirstLastName { (fn, ln) in
            self.headerView.prefixLbl.text = "\(fn.prefix(1) + ln.prefix(1))".uppercased()
            self.tableView.reloadData()
        }
        
        guard let link = user.avatarLink else {
            headerView.prefixLbl.isHidden = false
            headerView.avatarImg = nil
            self.tableView.reloadData()
            return
        }
        
        user.downloadAvatar(link: link) { (image) in
            DispatchQueue.main.async {
                self.headerView.prefixLbl.isHidden = true
                self.headerView.avatarImg = image
                self.headerView.avatarImgView.image = self.headerView.avatarImg
                self.tableView.reloadData()
            }
        }
    }
    
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
}

//MARK: - UITableViewDataSource

extension MemberDetailsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberDetailsTVCell", for: indexPath)
        cell.selectionStyle = .none
        let label = cell.textLabel!
        
        let fnTxt = NSLocalizedString("Full Name: ", comment: "MemberDetailsVC.swift: Full Name: ")
        let emailTxt = "Email: "
        let phoneNumberTxt = NSLocalizedString("Phone Number: ", comment: "MemberDetailsVC.swift: Phone Number: ")
        
        switch indexPath.row {
        case 0: label.attributedText = createAttributedText(fnTxt, user.fullName)
        case 1: label.attributedText = createAttributedText(emailTxt, user.email)
        case 2: label.attributedText = createAttributedText(phoneNumberTxt, user.phoneNumber)
        default: break
        }
        
        return cell
    }
    
    private func createAttributedText(_ txt1: String, _ txt2: String) -> NSMutableAttributedString {
        let alt1 = [NSAttributedString.Key.font: UIFont(name: fontNamedBold, size: 17.0)!]
        let altStr1 = NSAttributedString(string: txt1, attributes: alt1)
        
        let alt2 = [NSAttributedString.Key.font: UIFont(name: fontNamed, size: 17.0)!]
        let altStr2 = NSAttributedString(string: txt2, attributes: alt2)
        
        let attributedText = NSMutableAttributedString()
        attributedText.append(altStr1)
        attributedText.append(altStr2)
        
        return attributedText
    }
}

//MARK: - UITableViewDelegate

extension MemberDetailsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
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

extension MemberDetailsVC: UINavigationControllerDelegate {
    
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

//MARK: - DarkMode

extension MemberDetailsVC {
    
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
        tableView.separatorColor = isDarkMode ? darkSeparatorColor : lightSeparatorColor
        tableView.reloadData()
    }
}
