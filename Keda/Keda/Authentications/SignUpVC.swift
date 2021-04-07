//
//  SignUpVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Firebase

protocol SignUpVCDelegate: class {
    func handleSignUp(_ vc: SignUpVC)
}

class SignUpVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: SignUpVCDelegate?
    private let backBtn = ShowMoreBtn()
    private let titleLbl = UILabel()
    private let containerView = UIView()
    private let bottomView = UIView()
    private let leftLbl = UILabel()
    private let termsBtn = ShowMoreBtn()
    
    private let termsTxt = NSLocalizedString("Terms of Use.", comment: "SignUpVC.swift: Terms of Use")
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupDarkMode()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEndEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

//MARK: - Configures

extension SignUpVC {
    
    func updateUI() {
        view.backgroundColor = .white
        
        //TODO: - BackBtn
        backBtn.setImage(UIImage(named: "icon-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.tintColor = .black
        backBtn.addTarget(self, action: #selector(backDidTap), for: .touchUpInside)
        view.addSubview(backBtn)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleLbl
        let titleTxt = NSLocalizedString("CREATE NEW ACCOUNT", comment: "SignUpVC.swift: CREATE NEW ACCOUNT")
        titleLbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: titleTxt, fontN: fontNamedBold)
        view.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - BottomView
        bottomView.backgroundColor = .clear
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleBottom
        let fontS: CGFloat
        let edge: UIEdgeInsets
        if appDl.iPhone5 {
            fontS = 9.0
            edge = UIEdgeInsets(top: 1.0, left: 0.0, bottom: -0.5, right: 0.0)
            
        } else if appDl.isX || appDl.iPhonePlus {
            fontS = 11.0
            edge = UIEdgeInsets(top: 4.0, left: 0.0, bottom: -0.5, right: 0.0)
            
        } else {
            fontS = 10.0
            edge = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.5, right: 0.0)
        }
        
        let leftTxt = NSLocalizedString("By creating an account you agree with our ", comment: "SignUpVC.swift: LeftTxt")
        leftLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: fontS, isTxt: leftTxt, fontN: fontNamed)
        
        let attributed = setupTitleAttri(termsTxt, txtColor: .systemBlue, size: fontS)
        termsBtn.setAttributedTitle(attributed, for: .normal)
        termsBtn.addTarget(self, action: #selector(termsDidTap), for: .touchUpInside)
        termsBtn.contentEdgeInsets = edge
        termsBtn.contentVerticalAlignment = .bottom
        termsBtn.sizeToFit()
        
        let views: [UIView] = [leftLbl, termsBtn]
        let sv = createdStackView(views, spacing: 0.0, axis: .horizontal, distribution: .fill, alignment: .bottom)
        bottomView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ContainerView
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let signUpTVC = SignUpTVC()
        signUpTVC.delegate = self
        containerView.addSubview(signUpTVC.view)
        addChild(signUpTVC)
        signUpTVC.didMove(toParent: self)
        signUpTVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        let widthBtn: CGFloat = 45.0
        NSLayoutConstraint.activate([
            backBtn.widthAnchor.constraint(equalToConstant: widthBtn),
            backBtn.heightAnchor.constraint(equalToConstant: widthBtn),
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2.0),
            
            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.0),
            titleLbl.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 10.0),
            
            bottomView.heightAnchor.constraint(equalToConstant: 50.0),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            sv.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            sv.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            
            containerView.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 20.0),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            signUpTVC.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            signUpTVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            signUpTVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            signUpTVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    @objc func termsDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            let termsOfUseVC = TermsOfUseVC()
            self.navigationController?.pushViewController(termsOfUseVC, animated: true)
        }
    }
    
    @objc func backDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func handleEndEditing() {
        view.endEditing(true)
    }
}

//MARK: - Functions

extension SignUpVC {
    
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

//MARK: - SignUpTVCDelegate

extension SignUpVC: SignUpTVCDelegate {
    
    func handleSignUp(_ email: String, fullName: String, phoneNumber: String, password: String) {
        print("\n")
        print("===============Delegate===============")
        print("Email: \(email)")
        print("FullName: \(fullName)")
        print("Phone Number: \(phoneNumber)")
        print("Password: \(password)")
        
        let hud = createdHUD()
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard error == nil, let kUser = result?.user else { return }
            let userModel = UserModel(uid: kUser.uid, email: email, fullName: fullName, phoneNumber: phoneNumber, avatarLink: nil, type: "member")
            let user = User(userModel: userModel)
            user.saveUser {
                print("Successfully")
                
                UIView.animate(withDuration: 0.5, animations: {
                    hud.alpha = 0.0
                }) { (_) in
                    hud.removeFromSuperview()
                    self.delegate?.handleSignUp(self)
                }
            }
        }
    }
}

//MARK: - UINavigationControllerDelegate

extension SignUpVC: UINavigationControllerDelegate {
    
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

extension SignUpVC {
    
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
        backBtn.tintColor = isDarkMode ? .white : .black
        titleLbl.textColor = isDarkMode ? .white : .black
        
        let fontS: CGFloat
        if appDl.iPhone5 {
            fontS = 9.0
            
        } else if appDl.isX || appDl.iPhonePlus {
            fontS = 11.0
            
        } else {
            fontS = 10.0
        }
        let termsC: UIColor = isDarkMode ? UIColor(hex: 0x2687FB) : .systemBlue
        let termsAttr = setupTitleAttri(termsTxt, txtColor: termsC, size: fontS)
        termsBtn.setAttributedTitle(termsAttr, for: .normal)
    }
}
