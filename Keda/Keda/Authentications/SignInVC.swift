//
//  SignInVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import CoreData
import AuthenticationServices
import CryptoKit

protocol SignInVCDelegate: class {
    func handleLogIn(_ vc: SignInVC)
    func handleFBLogIn(_ vc: SignInVC)
    func handleAppleSignIn(_ vc: SignInVC)
}

class SignInVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: SignInVCDelegate?
    
    private let backBtn = ShowMoreBtn()
    private let titleLbl = UILabel()
    private let emailTF = EmailTF()
    let passwordTF = UITextField()
    private let orLbl = UILabel()
    private let logInBtn = ShowMoreBtn()
    private let fbBtn = FacebookButton()
    
    private let forgetPassBtn = ShowMoreBtn()
    private let savePasswordLbl = UILabel()
    private let savePasswordBtn = UIButton()
    private var isSave = false
    
    private let logInTxt = NSLocalizedString("LOG IN", comment: "SignInVC.swift: LOG IN")
    private let passPlTxt = "●●●●●●"
    private let forgetPassTxt = NSLocalizedString("Forget Password?", comment: "SignInVC.swift: Forget Password")
    private let orTxt = NSLocalizedString("OR", comment: "SignInVC.swift: OR")
    private let whoopsTxt = NSLocalizedString("Whoops!!!", comment: "SignInVC.swift: Whoops")
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    var password = ""
    private var email = ""
    private var isShow = false
    private let rightImgView = UIImageView()
    
    var emails: [Email] = []
    var coreDataStack: CoreDataStack { return appDl.coreDataStack }
    
    fileprivate var currentNonce: String?
    
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
        
        fbBtn.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        //TODO: - Fetch Email List
        let request: NSFetchRequest<EmailList> = EmailList.fetchRequest()
        do {
            let result = try coreDataStack.managedObjectContext.fetch(request)
            result.forEach({
                let email = Email(emailModel: EmailModel(email: $0.email, password: $0.password))
                self.emails.append(email)
            })
            
        } catch {}
    }
}

//MARK: - Configures

extension SignInVC {
    
    func updateUI() {
        view.backgroundColor = .white
        
        //TODO: - BackBtn
        backBtn.setImage(UIImage(named: "icon-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.tintColor = .black
        backBtn.addTarget(self, action: #selector(backDidTap), for: .touchUpInside)
        view.addSubview(backBtn)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleLbl
        let titleTxt = NSLocalizedString("LOGIN TO YOUR ACCOUNT", comment: "SignInVC.swift: LOGIN TO YOUR ACCOUNT")
        titleLbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: titleTxt, fontN: fontNamedBold)
        view.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TextField
        emailTF.signInVC = self
        
        let emailPlTxt = "example@gmail.com"
        emailTF.configureFromTF(emailPlTxt, imgName: "icon-email")
        emailTF.keyboardType = .emailAddress
        emailTF.autocapitalizationType = .none
        emailTF.delegate = self
        
        passwordTF.configureFromTFLeftRightView(passPlTxt, imgName: "icon-password", rightImgView: rightImgView)
        passwordTF.isSecureTextEntry = true
        passwordTF.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(eyeDidTap))
        rightImgView.addGestureRecognizer(tap)
        
        let views1 = [emailTF, passwordTF]
        let sv1 = createdStackView(views1, spacing: 20.0, axis: .vertical, distribution: .fillEqually, alignment: .center)
        view.addSubview(sv1)
        sv1.translatesAutoresizingMaskIntoConstraints = false
        
        let attributed = setupTitleAttri(forgetPassTxt, txtColor: .systemBlue, size: 13.0)
        forgetPassBtn.setAttributedTitle(attributed, for: .normal)
        forgetPassBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        forgetPassBtn.addTarget(self, action: #selector(forgetPassDidTap), for: .touchUpInside)
        view.addSubview(forgetPassBtn)
        forgetPassBtn.translatesAutoresizingMaskIntoConstraints = false
        
        let fbTxt = NSLocalizedString("FACEBOOK LOGIN", comment: "SignInVC.swift: FACEBOOK LOGIN")
        fbBtn.configureLogInSignUpBtn(fbTxt, txtColor: .white, bgColor: UIColor(hex: 0x384C8D), selector: #selector(facebookDidTap), vc: self)
        for constraint in fbBtn.constraints {
            if constraint.constant <= 50.0 {
                constraint.isActive = false
                break
            }
        }
        
        orLbl.configureNameForCell(false, txtColor: .black, fontSize: 20.0, isTxt: orTxt, fontN: fontNamedBold)
        orLbl.sizeToFit()
        
        let views2 = [logInBtn, orLbl, fbBtn]
        let sv2 = createdStackView(views2, spacing: 0.0, axis: .vertical, distribution: .fillEqually, alignment: .center)
        view.addSubview(sv2)
        sv2.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - SavePassword
        let imgName = isSave ? "icon-checkmark" : ""
        savePasswordBtn.clipsToBounds = true
        savePasswordBtn.layer.borderColor = UIColor.gray.cgColor
        savePasswordBtn.layer.borderWidth = 1.0
        savePasswordBtn.layer.cornerRadius = 3.0
        savePasswordBtn.setImage(UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        savePasswordBtn.tintColor = isSave ? .black : .white
        savePasswordBtn.contentEdgeInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
        savePasswordBtn.addTarget(self, action: #selector(checkDidTap), for: .touchUpInside)
        savePasswordBtn.translatesAutoresizingMaskIntoConstraints = false
        savePasswordBtn.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        savePasswordBtn.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        let savePTxt = NSLocalizedString("Save password", comment: "SignInVC.swift: Save password")
        savePasswordLbl.configureNameForCell(false, txtColor: .black, fontSize: 13.0, isTxt: savePTxt, fontN: fontNamed)
        
        let views3 = [savePasswordBtn, savePasswordLbl]
        let sv3 = createdStackView(views3, spacing: 5.0, axis: .horizontal, distribution: .fill, alignment: .center)
        view.addSubview(sv3)
        sv3.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - LogIn - Sign Up
        logInBtn.configureLogInSignUpBtn(logInTxt, txtColor: .white, bgColor: .black, selector: #selector(logInDidTap), vc: self)
        
        let widthBtn: CGFloat = 45.0
        NSLayoutConstraint.activate([
            backBtn.widthAnchor.constraint(equalToConstant: widthBtn),
            backBtn.heightAnchor.constraint(equalToConstant: widthBtn),
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2.0),
            
            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.0),
            titleLbl.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 10.0),
            
            sv1.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 30.0),
            sv1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            forgetPassBtn.trailingAnchor.constraint(equalTo: sv1.trailingAnchor),
            forgetPassBtn.topAnchor.constraint(equalTo: sv1.bottomAnchor, constant: 5.0),
            
            sv2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sv2.topAnchor.constraint(equalTo: forgetPassBtn.bottomAnchor, constant: 20.0),
            
            sv3.centerYAnchor.constraint(equalTo: forgetPassBtn.centerYAnchor),
            sv3.leadingAnchor.constraint(equalTo: sv1.leadingAnchor)
        ])
        
        if #available(iOS 13.0, *) {
            let appleLogInBtn = ASAuthorizationAppleIDButton()
            appleLogInBtn.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
            appleLogInBtn.clipsToBounds = true
            appleLogInBtn.layer.cornerRadius = 25.0
            view.addSubview(appleLogInBtn)
            appleLogInBtn.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                appleLogInBtn.widthAnchor.constraint(equalToConstant: screenWidth*0.9),
                appleLogInBtn.heightAnchor.constraint(equalToConstant: 50.0),
                appleLogInBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                appleLogInBtn.topAnchor.constraint(equalTo: sv2.bottomAnchor, constant: 10.0)
            ])
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func checkDidTap(_ sender: UIButton) {
        isSave = !isSave
        
        let imgName = isSave ? "icon-checkmark" : ""
        sender.setImage(UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: sender.tintColor = isSave ? .black : .white
            case .dark: sender.tintColor = isSave ? .white : .black
            default: break
            }
        } else {
            sender.tintColor = isSave ? .black : .white
        }
    }
    
    @objc func forgetPassDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            let title = NSLocalizedString("Reset Your Password", comment: "SignInVC.swift: Reset Your Password")
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addTextField { (textField) in
                let txt = NSLocalizedString("Enter email address", comment: "SignInVC.swift: Enter email address")
                textField.placeholder = txt
                textField.font = UIFont(name: fontNamed, size: 17.0)
                textField.keyboardType = .emailAddress
            }
            
            let cancelTxt = NSLocalizedString("Cancel", comment: "SignInVC.swift: Cancel")
            let cancelAct = UIAlertAction(title: cancelTxt, style: .cancel, handler: nil)
            
            let resetTxt = NSLocalizedString("Reset", comment: "SignInVC.swift: Reset")
            let resetAct = UIAlertAction(title: resetTxt, style: .default) { (_) in
                guard let tf = alert.textFields?.first else { return }
                if let text = tf.text,
                    !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                    text.isValidEmail {
                    let hud = createdHUD()
                    Auth.auth().sendPasswordReset(withEmail: text) { (error) in
                        guard error == nil else {
                            hud.removeFromSuperview()
                            
                            let mesTxt = NSLocalizedString("Email address does not exist", comment: "SignInVC.swift: Email address does not exist")
                            handleErrorAlert(self.whoopsTxt, mes: mesTxt, act: "OK", vc: self)
                            return
                        }
                        
                        UIView.animate(withDuration: 0.5, animations: {
                            hud.alpha = 0.0
                        }) { (_) in
                            hud.removeFromSuperview()
                            
                            let titleTxt = NSLocalizedString("Success", comment: "SignInVC.swift: Success")
                            
                            let mesTxt = NSLocalizedString("Check your email address", comment: "SignInVC.swift: Check your email address")
                            handleErrorAlert(titleTxt, mes: mesTxt, act: "OK", vc: self)
                        }
                    }
                }
            }
            
            alert.addAction(cancelAct)
            alert.addAction(resetAct)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func eyeDidTap() {
        isShow = !isShow
        rightImgView.image = UIImage(named: isShow ? "icon-eyeOn" : "icon-eyeOff")
        passwordTF.isSecureTextEntry = !isShow
    }
    
    @objc func logInDidTap(_ sender: UIButton) {
        handleEndEditing()
        
        print("===============//===============")
        print("Email: \(self.email)")
        print("Password: \(self.password)")
        
        touchAnim(sender) {
            self.handleError(self.email, view: self.emailTF)
            self.handleError(self.password, view: self.passwordTF)
            
            guard !self.email.trimmingCharacters(in: .whitespaces).isEmpty,
                !self.password.trimmingCharacters(in: .whitespaces).isEmpty,
                self.password.trimmingCharacters(in: .whitespaces).count > 8
                else { return }
            
            self.email = self.email.trimmingCharacters(in: .whitespacesAndNewlines)
            self.password = self.password.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard isInternetAvailable() else {
                internetNotAvailable()
                return
            }
            
            let hud = createdHUD()
            Auth.auth().signIn(withEmail: self.email, password: self.password) { (result, error) in
                if let _ = error {
                    hud.removeFromSuperview()
                    
                    let mes = NSLocalizedString("Email or password is incorrect", comment: "SignInVC.swift: Email or password is incorrect")
                    handleErrorAlert(self.whoopsTxt, mes: mes, act: "OK", vc: self)
                    
                } else {
                    UIView.animate(withDuration: 0.5, animations: {
                        hud.alpha = 0.0
                    }) { (_) in
                        hud.removeFromSuperview()
                        
                        if self.isSave {
                            let email = Email(emailModel: EmailModel(email: self.email, password: self.password))
                            if !self.emails.contains(email) {
                                let emailList = EmailList(context: self.coreDataStack.managedObjectContext)
                                emailList.email = email.email
                                
                                let password = email.password
                                let encrypt = try! password.aesEncrypt(key: passwordKey, iv: passwordIV)
                                emailList.password = encrypt
                                
                                self.coreDataStack.saveContext()
                                getPath()
                            }
                        }
                        
                        self.delegate?.handleLogIn(self)
                    }
                }
            }
        }
    }
    
    func handleError(_ txt: String, view: UIView) {
        if !txt.isEmpty {
            borderView(view, color: .lightGray)
            
        } else {
            setupAnimBorderView(view)
        }
    }
    
    @objc func facebookDidTap(_ sender: UIButton) {
        touchAnim(sender) { print("Facebook Login") }
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

extension SignInVC {
    
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

//MARK: - UITextFieldDelegate

extension SignInVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            if let text = emailTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.isValidEmail {
                    borderView(emailTF, color: .lightGray)
                    email = text
                    passwordTF.becomeFirstResponder()
                    
                } else {
                    setupAnimBorderView(emailTF)
                    email = ""
                    emailTF.becomeFirstResponder()
                }
            }
            
        } else if textField == passwordTF {
            if let text = passwordTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.count > 8 {
                    borderView(passwordTF, color: .lightGray)
                    password = text
                    logInDidTap(logInBtn)
                    
                } else {
                    setupAnimBorderView(passwordTF)
                    password = ""
                    passwordTF.becomeFirstResponder()
                }
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTF {
            if let text = emailTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.isValidEmail {
                    borderView(emailTF, color: .lightGray)
                    email = text
                    
                } else {
                    setupAnimBorderView(emailTF)
                    email = ""
                }
            }
            
        } else if textField.text == passwordTF.text {
            if let text = passwordTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.count > 8 {
                    borderView(passwordTF, color: .lightGray)
                    password = text
                    
                } else {
                    setupAnimBorderView(passwordTF)
                    password = ""
                }
            }
        }
    }
}

//MARK: - LoginButtonDelegate

extension SignInVC: LoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {}
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            handleErrorAlert("Oops!!!", mes: error.localizedDescription, act: "OK", vc: self)
        }
        
        guard let tokenStr = AccessToken.current?.tokenString else { return }
        view.isUserInteractionEnabled = false
        
        let credential = FacebookAuthProvider.credential(withAccessToken: tokenStr)
        Auth.auth().signIn(with: credential) { (result, error) in
            guard error == nil, let kUser = result?.user else { return }
            let uid = kUser.uid
            let email = kUser.email ?? "@Facebook"
            let fullName = kUser.displayName ?? kUser.providerID
            let phone = kUser.phoneNumber ?? "No Phone Number"
            let avatar = kUser.photoURL?.absoluteString ?? nil
            let userModel = UserModel(uid: uid, email: email, fullName: fullName, phoneNumber: phone, avatarLink: avatar, type: "member")
            let user = User(userModel: userModel)
            user.saveUser {
                self.delegate?.handleFBLogIn(self)
            }
        }
    }
}

//MARK: - Sign In With Apple

extension SignInVC {
    
    private func randomNonceStr(length: Int = 32) -> String {
        precondition(length > 0)
        
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map({ _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError()
                }
                
                return random
            })
            
            randoms.forEach({
                if remainingLength == 0 {
                    return
                }
                
                if $0 < charset.count {
                    result.append(charset[Int($0)])
                    remainingLength -= 1
                }
            })
        }
        
        return result
    }
    
    @available(iOS 13, *)
    @objc func startSignInWithAppleFlow(_ sender: ASAuthorizationAppleIDButton) {
        touchAnim(sender) {
            let nonce = self.randomNonceStr()
            self.currentNonce = nonce

            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = self.sha256(nonce)

            let authorization = ASAuthorizationController(authorizationRequests: [request])
            authorization.delegate = self
            authorization.presentationContextProvider = self
            authorization.performRequests()
        }
    }
    
    @available (iOS 13, *)
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashedStr = hashedData.compactMap({ return String(format: "%02x", $0) }).joined()
        return hashedStr
    }
}

//MARK: - ASAuthorizationControllerDelegate

@available (iOS 13, *)
extension SignInVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else { fatalError() }
            guard let appleIDToken = appleIDCredential.identityToken else { return }
            guard let idTokenStr = String(data: appleIDToken, encoding: .utf8) else { return }
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenStr, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    
                } else if let kUser = result?.user {
                    let uid = kUser.uid
                    let email = kUser.email ?? "@Apple"
                    let fullName = kUser.displayName ?? "Apple"
                    let phone = kUser.phoneNumber ?? "No Phone Number"
                    let avatar = kUser.photoURL?.absoluteString ?? nil
                    let userModel = UserModel(uid: uid, email: email, fullName: fullName, phoneNumber: phone, avatarLink: avatar, type: "member")
                    let user = User(userModel: userModel)
                    user.saveUser {
                        self.delegate?.handleAppleSignIn(self)
                    }
                }
                
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign In With Apple Errored: \(error)")
    }
}

//MARK: - ASAuthorizationControllerPresentationContextProviding

@available (iOS 13, *)
extension SignInVC: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

//MARK: - UINavigationControllerDelegate

extension SignInVC: UINavigationControllerDelegate {
    
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

extension SignInVC {
    
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
        titleLbl.textColor = isDarkMode ? .white : .black
        backBtn.tintColor = isDarkMode ? .white : .black
        appDl.window?.tintColor = isDarkMode ? .white : .black
        
        let forgetC: UIColor = isDarkMode ? UIColor(hex: 0x2687FB) : .systemBlue
        let forgetAttr = setupTitleAttri(forgetPassTxt, txtColor: forgetC, size: 13.0)
        forgetPassBtn.setAttributedTitle(forgetAttr, for: .normal)
        
        let logInC: UIColor = isDarkMode ? .black : .white
        let logInAttr = setupTitleAttri(logInTxt, txtColor: logInC, size: 17.0)
        logInBtn.setAttributedTitle(logInAttr, for: .normal)
        logInBtn.backgroundColor = isDarkMode ? .white : .black
        orLbl.textColor = isDarkMode ? .white : .black
        
        let bgTFC: UIColor = isDarkMode ? .black : .white
        let borderTFC: UIColor = isDarkMode ? .darkGray : .lightGray
        emailTF.backgroundColor = bgTFC
        emailTF.layer.borderColor = borderTFC.cgColor
        
        passwordTF.backgroundColor = bgTFC
        passwordTF.layer.borderColor = borderTFC.cgColor
        
        savePasswordBtn.layer.borderColor = isDarkMode ?
            UIColor.lightGray.cgColor : UIColor.gray.cgColor
        savePasswordLbl.textColor = isDarkMode ? .white : .black
        savePasswordBtn.tintColor = isDarkMode ? .white : .black
        savePasswordBtn.tintColor = isDarkMode ? .white : .black
    }
}
