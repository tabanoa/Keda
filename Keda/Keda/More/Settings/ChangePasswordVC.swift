//
//  ChangePasswordVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Firebase

protocol ChangePasswordVCDelegate: class {
    func handleChangePassword(_ vc: ChangePasswordVC)
}

class ChangePasswordVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: ChangePasswordVCDelegate?
    private let naContainerV = UIView()
    private let containerView = UIView()
    
    var email = ""
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        
        updateUI()
        setupDarkMode()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEndEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

//MARK: - Configures

extension ChangePasswordVC {
    
    func setupNavi() {
        view.backgroundColor = groupColor
        navigationItem.setHidesBackButton(true, animated: false)
        naContainerV.configureContainerView(navigationItem)
        
        //TODO: - Title
//        let title = "Thay Đổi Mật Khẩu"
        let title = NSLocalizedString("Change Password", comment: "ChangePasswordVC.swift: Change Password")
        let titleLbl = UILabel()
        titleLbl.configureTitleForNavi(naContainerV, isTxt: title)
    }
    
    func updateUI() {
        //TODO: - ContainerView
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let changePasswordTVC = ChangePasswordTVC(style: .grouped)
        changePasswordTVC.delegate = self
        containerView.addSubview(changePasswordTVC.view)
        addChild(changePasswordTVC)
        changePasswordTVC.didMove(toParent: self)
        changePasswordTVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            changePasswordTVC.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            changePasswordTVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            changePasswordTVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            changePasswordTVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    @objc func handleEndEditing() {
        view.endEditing(true)
    }
}

//MARK: - ChangePasswordTVCDelegate

extension ChangePasswordVC: ChangePasswordTVCDelegate {
    
    func handleSaveChanges(_ currentPassword: String, _ verifyPassword: String, vc: ChangePasswordTVC) {
        let hud = createdHUD()
        Auth.auth().signIn(withEmail: self.email, password: currentPassword) { (result, error) in
            guard error == nil else {
                hud.removeFromSuperview()
                
                let titleTxt = NSLocalizedString("Whoops!!!", comment: "ChangePasswordVC.swift: Whoops!!!")
                let mesTxt = NSLocalizedString("Current password is incorrect", comment: "ChangePasswordVC.swift: Current password is incorrect")
                handleErrorAlert(titleTxt, mes: mesTxt, act: "OK", vc: self)
                return
            }
            
            Auth.auth().currentUser?.updatePassword(to: verifyPassword, completion: { (error) in
                guard error == nil else { return }
                UIView.animate(withDuration: 0.5, animations: {
                    hud.alpha = 0.0
                }) { (_) in
                    hud.removeFromSuperview()
                    for vc in vc.navigationController!.viewControllers {
                        if vc.isKind(of: MoreVC.self) {
                            vc.navigationController?.popToViewController(vc, animated: false)
                        }
                    }
                }
            })
        }
    }
}

//MARK: - DarkMode

extension ChangePasswordVC {
    
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
    }
}
