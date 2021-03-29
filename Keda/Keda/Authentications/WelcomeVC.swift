//
//  WelcomeVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Firebase

class WelcomeVC: UIViewController {
    
    //MARK: - Properties
    private let logoImgView = UIImageView()
    private let welcomeLbl = UILabel()
    private let titleLbl = UILabel()
    private let logInBtn = ShowMoreBtn()
    private let signUpBtn = ShowMoreBtn()
    private let ignoreBtn = ShowMoreBtn()
    
    private let logInTxt = NSLocalizedString("LOG IN", comment: "WelcomeVC.swift: LOG IN")
    private let signUpTxt = NSLocalizedString("SIGN UP", comment: "WelcomeVC.swift: SIGN UP")
    private let ignoreTxt = NSLocalizedString("Ignore", comment: "WelcomeVC.swift: Ignore")
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    var isPresent = false
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupDarkMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let _ = user {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
}

//MARK: - Configures

extension WelcomeVC {
    
    func updateUI() {
        view.backgroundColor = .white
        
        //TODO: - Logo ImageView
        logoImgView.clipsToBounds = true
        logoImgView.contentMode = .scaleAspectFit
        logoImgView.image = UIImage(named: "icon-f")?.withRenderingMode(.alwaysTemplate)
        logoImgView.tintColor = .black
        view.addSubview(logoImgView)
        logoImgView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Welcome Lbl
        let welcomeTxt = NSLocalizedString("Welcome To Keda", comment: "WelcomeVC.swift: Welcome To KEDA")
        welcomeLbl.configureNameForCell(false, line: 2, txtColor: .black, fontSize: 25.0, isTxt: welcomeTxt, fontN: fontNamedBold)
        welcomeLbl.textAlignment = .center
        
        let titleTxt = NSLocalizedString("Rent high end fashion and streetwear in a safe and welcoming marketplace.", comment: "WelcomeVC.swift: Title")
        titleLbl.configureNameForCell(false, line: 0, txtColor: .gray, fontSize: 18.0, isTxt: titleTxt, fontN: fontNamed)
        titleLbl.textAlignment = .center
        
        let views1 = [welcomeLbl, titleLbl]
        let sv1 = createdStackView(views1, spacing: 10.0, axis: .vertical, distribution: .fill, alignment: .center)
        view.addSubview(sv1)
        sv1.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - LogIn - Sign Up
        logInBtn.configureLogInSignUpBtn(logInTxt, txtColor: .white, bgColor: .black, selector: #selector(logInDidTap), vc: self)
        
        signUpBtn.configureLogInSignUpBtn(signUpTxt, txtColor: .black, bgColor: .white, selector: #selector(signUpDidTap), vc: self, borderC: .black)
        
        let views2 = [logInBtn, signUpBtn]
        let sv2 = createdStackView(views2, spacing: 20.0, axis: .vertical, distribution: .fillEqually, alignment: .center)
        view.addSubview(sv2)
        sv2.translatesAutoresizingMaskIntoConstraints = false
        
        let attributed = setupTitleAttri(ignoreTxt, size: 13.0)
        ignoreBtn.setAttributedTitle(attributed, for: .normal)
        ignoreBtn.backgroundColor = .black
        ignoreBtn.clipsToBounds = true
        ignoreBtn.layer.cornerRadius = 3.0
        ignoreBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
        ignoreBtn.addTarget(self, action: #selector(ignoreDidTap), for: .touchUpInside)
        view.addSubview(ignoreBtn)
        ignoreBtn.translatesAutoresizingMaskIntoConstraints = false
        
        let barH = UIApplication.shared.statusBarFrame.height
        let naviH = navigationController!.navigationBar.frame.height
        NSLayoutConstraint.activate([
            logoImgView.topAnchor.constraint(equalTo: view.topAnchor, constant: barH+naviH+20),
            logoImgView.widthAnchor.constraint(equalToConstant: 100.0),
            logoImgView.heightAnchor.constraint(equalToConstant: 100.0),
            logoImgView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            sv1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sv1.topAnchor.constraint(equalTo: logoImgView.bottomAnchor, constant: 20.0),
            sv1.leadingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor, constant: 20.0),
            sv1.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20.0),
            
            sv2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sv2.topAnchor.constraint(equalTo: sv1.bottomAnchor, constant: 40.0),
            
            ignoreBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
            ignoreBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0)
        ])
    }
    
    @objc func ignoreDidTap(_ sender: UIButton) {
        if !isPresent {
            NotificationCenter.default.post(name: Notification.Name("DismissHomeVC"), object: nil)
        }
        
        touchAnim(sender) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func logInDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            let signInVC = SignInVC()
            signInVC.delegate = self
            self.navigationController?.pushViewController(signInVC, animated: true)
        }
    }
    
    @objc func signUpDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            let signUpVC = SignUpVC()
            signUpVC.delegate = self
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
}

//MARK: - SignInVCDelegate

extension WelcomeVC: SignInVCDelegate {
    
    func handleLogIn(_ vc: SignInVC) {
        handlePop(vc)
    }
    
    func handleFBLogIn(_ vc: SignInVC) {
        handlePop(vc)
    }
    
    func handleAppleSignIn(_ vc: SignInVC) {
        handlePop(vc)
    }
    
    private func handlePop(_ vc: UIViewController) {
        NotificationCenter.default.post(name: Notification.Name("DismissHomeVC"), object: nil)
        User.connected()
        
        if !Manager.sharedInstance.getFirstLogin() {
            NotificationFor.sharedInstance.addNotification()
            Manager.sharedInstance.setFirstLogin(true)
        }
        
        vc.navigationController?.popViewController(animated: false)
        view.isUserInteractionEnabled = false
    }
}

//MARK: - SignUpVCDelegate

extension WelcomeVC: SignUpVCDelegate {
    
    func handleSignUp(_ vc: SignUpVC) {
        handlePop(vc)
    }
}

//MARK: - DarkMode

extension WelcomeVC {
    
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
        logoImgView.tintColor = isDarkMode ? .white : .black
        welcomeLbl.textColor = isDarkMode ? .white : .black
        titleLbl.textColor = isDarkMode ? .lightGray : .gray
        
        let logInC: UIColor = isDarkMode ? .black : .white
        let logInAttr = setupTitleAttri(logInTxt, txtColor: logInC, size: 17.0)
        logInBtn.setAttributedTitle(logInAttr, for: .normal)
        logInBtn.backgroundColor = isDarkMode ? .white : .black
        logInBtn.layer.borderColor = isDarkMode ? UIColor.black.cgColor : UIColor.clear.cgColor
        
        let signUpC: UIColor = isDarkMode ? .white : .black
        let signUpAttr = setupTitleAttri(signUpTxt, txtColor: signUpC, size: 17.0)
        signUpBtn.setAttributedTitle(signUpAttr, for: .normal)
        signUpBtn.backgroundColor = isDarkMode ? .clear : .white
        signUpBtn.layer.borderColor = isDarkMode ? UIColor.white.cgColor : UIColor.black.cgColor
        
        let ignoreC: UIColor = isDarkMode ? .black : .white
        let ignoreAttr = setupTitleAttri(ignoreTxt, txtColor: ignoreC, size: 13.0)
        ignoreBtn.setAttributedTitle(ignoreAttr, for: .normal)
        ignoreBtn.backgroundColor = isDarkMode ? .white : .black
    }
}
