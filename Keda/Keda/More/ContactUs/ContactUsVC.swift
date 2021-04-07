//
//  ContactUsVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import MessageUI

class ContactUsVC: UIViewController {
    
    //MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let naContainerV = UIView()
    private let titleAddressLbl = UILabel()
    private let addressLbl = UILabel()
    private let titleEmailUsLbl = UILabel()
    private let emailUsLbl = UILabel()
    private let callUsLbl = UILabel()
    
    private let backBtn = UIButton()
    private let titleLbl = UILabel()
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupTV()
        setupDarkMode()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
    }
}

//MARK: - Configures

extension ContactUsVC {
    
    func setupNavi() {
        view.backgroundColor = groupColor
        navigationItem.setHidesBackButton(true, animated: false)
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Title
        let title = NSLocalizedString("Contact", comment: "ContactUsVC.swift: Contact")
        titleLbl.configureTitleForNavi(naContainerV, isTxt: title)
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupTV() {
        tableView.configureTVSepar(groupColor, ds: self, dl: self, view: view)
        tableView.separatorColor = lightSeparatorColor
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactUsTVCell")
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

extension ContactUsVC {
    
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

extension ContactUsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 2 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsTVCell", for: indexPath)
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                setupAddress(titleAddressLbl, sub: addressLbl, cell: cell)
            default:
                cell.accessoryType = .disclosureIndicator
                setupEmail(titleEmailUsLbl, sub: emailUsLbl, cell: cell)
            }
            
        } else if indexPath.section == 1 {
            let txt = NSLocalizedString("Call Us", comment: "ContactUsVC.swift: Call Us")
            setupCallLabel(callUsLbl, text: txt, cell: cell)
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
    
    func setupAddress(_ title: UILabel, sub: UILabel, cell: UITableViewCell) {
        let txt = NSLocalizedString("Our Address", comment: "ContactUsVC.swift: Our Address")
        title.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: txt, fontN: fontNamed)
        sub.configureNameForCell(false, line: 2, txtColor: .gray, fontSize: 14.0, isTxt: "29A Street, An Khe town, Gia Lai province, 600000", fontN: fontNamed)
        
        let views = [title, sub]
        let sv = createdStackView(views, spacing: 5.0, axis: .vertical, distribution: .fill, alignment: .leading)
        cell.contentView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sv.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            sv.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15.0),
            sv.trailingAnchor.constraint(lessThanOrEqualTo: cell.contentView.trailingAnchor, constant: -15.0)
        ])
    }
    
    func setupEmail(_ title: UILabel, sub: UILabel, cell: UITableViewCell) {
        let txt = NSLocalizedString("E-Mail Us", comment: "ContactUsVC.swift: E-Mail Us")
        title.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: txt, fontN: fontNamed)
        sub.configureNameForCell(false, txtColor: .lightGray, fontSize: 17.0, isTxt: "kedatest1@gmail.com", fontN: fontNamed)
        cell.contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        cell.contentView.addSubview(sub)
        sub.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15.0),
            
            sub.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            sub.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10.0)
        ])
    }
    
    func setupCallLabel(_ lbl: UILabel, text: String, cell: UITableViewCell) {
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

extension ContactUsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                touchAnim(cell) {
                    configureMail(self, email: "kedatest1@gmail.com", vc: self)
                }
            }
            
        } else {
            touchAnim(cell) {
                guard let url = URL(string: "tel://\(0944784567)") else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 { return 60.0 }
            return tableView.rowHeight
        }
        
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
            let contactLbl = UILabel()
            let txt = NSLocalizedString("CONTACT", comment: "ContactUsVC.swift: CONTACT")
            contactLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
            contactLbl.configureHeaderTitle(kView)
            
        } else if section == 1 {
            let notificationLbl = UILabel()
            let txt = NSLocalizedString("Our business hours are Mon - Fri, 8am - 5pm.", comment: "ContactUsVC.swift: Our business hours are Mon - Fri, 8am - 5pm.")
            notificationLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 12.0, isTxt: txt)
            notificationLbl.configureHeaderTitle(kView)
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

//MARK: - UINavigationControllerDelegate

extension ContactUsVC: UINavigationControllerDelegate {
    
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

extension ContactUsVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - DarkMode

extension ContactUsVC {
    
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
        titleAddressLbl.textColor = isDarkMode ? .white : .black
        titleEmailUsLbl.textColor = isDarkMode ? .white : .black
        addressLbl.textColor = isDarkMode ? .lightGray : .gray
        emailUsLbl.textColor = isDarkMode ? .lightGray : .gray
        callUsLbl.textColor = isDarkMode ? UIColor(hex: 0x2687FB) : .systemBlue
    }
}
