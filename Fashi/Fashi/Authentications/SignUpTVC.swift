//
//  SignUpTVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol SignUpTVCDelegate: class {
    func handleSignUp(_ email: String, fullName: String, phoneNumber: String, password: String)
}

class SignUpTVC: UITableViewController {
    
    //MARK: - Properties
    weak var delegate: SignUpTVCDelegate?
    private let emailTF = UITextField()
    private let fullNameTF = UITextField()
    private let phoneNumberTF = UITextField()
    private let passwordTF = UITextField()
    private let signUpBtn = ShowMoreBtn()
    private var heightConstraint: NSLayoutConstraint!
    private var sv = UIStackView()
    private var charView = UIView()
    private var upperView = UIView()
    private var lowerView = UIView()
    private var numView = UIView()
    private var speCharView = UIView()
    
    private var isShow = false
    private let rightImgView = UIImageView()
    
    private let emailPlTxt = "example@gmail.com"
    private let fullNamePlTxt = NSLocalizedString("Full Name", comment: "SignUpTVC.swift: Full Name")
    private let phoneNPlTxt = NSLocalizedString("Phone Number", comment: "SignUpTVC.swift: Phone Number")
    private let signUpTxt = NSLocalizedString("SIGN UP", comment: "SignUpTVC.swift: SIGN UP")
    
    private var email = ""
    private var fullName = ""
    private var phoneNumber = ""
    private var password = ""
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupDarkMode()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - Configures

extension SignUpTVC {
    
    func updateUI() {
        tableView.backgroundColor = .white
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SignUpTVCell")
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
    }
}

//MARK: - Functions

extension SignUpTVC {
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
            UIView.animate(withDuration: duration) {
                self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: height, right: 0.0)
                self.tableView.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
            UIView.animate(withDuration: duration) {
                self.tableView.contentInset = .zero
                self.tableView.layoutIfNeeded()
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension SignUpTVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpTVCell", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            emailTF.configureFromTF(emailPlTxt, imgName: "icon-email")
            emailTF.keyboardType = .emailAddress
            emailTF.delegate = self
            emailTF.autocapitalizationType = .none
            setupConstraint(emailTF, cell: cell)
        case 1:
            fullNameTF.configureFromTF(fullNamePlTxt, imgName: "icon-fullName")
            fullNameTF.delegate = self
            fullNameTF.addTarget(self, action: #selector(fullNameChanged), for: .editingChanged)
            setupConstraint(fullNameTF, cell: cell)
        case 2:
            phoneNumberTF.configureFromTF(phoneNPlTxt, imgName: "icon-phoneNumber")
            phoneNumberTF.delegate = self
            phoneNumberTF.keyboardType = .numberPad
            setupConstraint(phoneNumberTF, cell: cell)
        case 3:
            setupContainerForPass(cell)
        default:
            signUpBtn.configureLogInSignUpBtn(signUpTxt, txtColor: .white, bgColor: .black, selector: #selector(signUpDidTap), vc: self)
            setupConstraint(signUpBtn, cell: cell)
        }
        
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupDMCell()
            case .dark: setupDMCell(true)
            default: break
            }
        } else {
            setupDMCell()
        }
        
        return cell
    }
    
    func setupConstraint(_ childView: UIView, cell: UITableViewCell) {
        cell.contentView.addSubview(childView)
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10.0),
            childView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
        ])
    }
    
    func setupContainerForPass(_ cell: UITableViewCell) {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        cell.contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let passPlTxt = "●●●●●●"
        passwordTF.configureFromTFLeftRightView(passPlTxt, imgName: "icon-password", rightImgView: rightImgView)
        passwordTF.delegate = self
        passwordTF.isSecureTextEntry = true
        passwordTF.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        containerView.addSubview(passwordTF)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(eyeDidTap))
        rightImgView.addGestureRecognizer(tap)
        
        let sv = handleAssertPass(containerView)
        
        heightConstraint = containerView.heightAnchor.constraint(equalToConstant: 70.0)
        heightConstraint.priority = UILayoutPriority.defaultLow
        NSLayoutConstraint.activate([
            heightConstraint,
            containerView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            
            passwordTF.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10.0),
            passwordTF.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            sv.leadingAnchor.constraint(equalTo: passwordTF.leadingAnchor, constant: 10.0),
            sv.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 10.0),
        ])
    }
    
    @objc func eyeDidTap() {
        isShow = !isShow
        rightImgView.image = UIImage(named: isShow ? "icon-eyeOn" : "icon-eyeOff")
        passwordTF.isSecureTextEntry = !isShow
    }
    
    func handleAssertPass(_ containerView: UIView) -> UIStackView {
        let charTxt = NSLocalizedString("Minimum 8 characters.", comment: "SignUpTVC.swift: Minimum 8 characters")
        charView = setupSubview()
        let charLbl = setupLbl(charTxt)
        let charSV = setupStackView(charView, lbl: charLbl)
        
        let upperTxt = NSLocalizedString("At least 1 uppercase.", comment: "SignUpTVC.swift: At least 1 uppercase")
        upperView = setupSubview()
        let upperLbl = setupLbl(upperTxt)
        let upperSV = setupStackView(upperView, lbl: upperLbl)
        
        let lowerTxt = NSLocalizedString("At least 1 lowercased.", comment: "SignUpTVC.swift: At least 1 lowercased")
        lowerView = setupSubview()
        let lowerLbl = setupLbl(lowerTxt)
        let lowerSV = setupStackView(lowerView, lbl: lowerLbl)
        
        let numTxt = NSLocalizedString("At least 1 number.", comment: "SignUpTVC.swift: At least 1 number")
        numView = setupSubview()
        let numLbl = setupLbl(numTxt)
        let numSV = setupStackView(numView, lbl: numLbl)
        
        let speCharTxt = NSLocalizedString("At least 1 special character.", comment: "SignUpTVC.swift: At least 1 special character")
        speCharView = setupSubview()
        let speCharLbl = setupLbl(speCharTxt)
        let speCharSV = setupStackView(speCharView, lbl: speCharLbl)
        
        let views = [charSV, upperSV, lowerSV, numSV, speCharSV]
        sv = createdStackView(views, spacing: 1.0, axis: .vertical, distribution: .fill, alignment: .leading)
        sv.isHidden = true
        containerView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }
    
    func setupSubview() -> UIView {
        let insideH: CGFloat = 9.0
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xDCDCDC)
        view.clipsToBounds = true
        view.layer.cornerRadius = insideH/2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: insideH).isActive = true
        view.widthAnchor.constraint(equalToConstant: insideH).isActive = true
        return view
    }
    
    func setupLbl(_ txt: String) -> UILabel {
        let lbl = UILabel()
        lbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 11.0, isTxt: txt, fontN: fontNamed)
        return lbl
    }
    
    func setupStackView(_ subview: UIView, lbl: UILabel) -> UIStackView {
        let sv = createdStackView([subview, lbl], spacing: 8.0, axis: .horizontal, distribution: .fill, alignment: .center)
        return sv
    }
    
    @objc func passwordChanged(_ tf: UITextField) {
        if let text = tf.text {
            handlePassword(text)
        }
    }
    
    func handlePassword(_ text: String) {
        let color = UIColor(hex: 0xDCDCDC)
        charView.backgroundColor = text.count >= 8 ? defaultColor : color
        upperView.backgroundColor = text.isUppercase ? defaultColor : color
        lowerView.backgroundColor = text.isLowercase ? defaultColor : color
        numView.backgroundColor = text.isNumber ? defaultColor : color
        speCharView.backgroundColor = text.isSpecialCharacter ? defaultColor : color
    }
    
    @objc func signUpDidTap(_ sender: UIButton) {
        self.tableView.endEditing(true)
        
        print("===============//===============")
        print("Email: \(self.email)")
        print("FullName: \(self.fullName)")
        print("Phone Number: \(self.phoneNumber)")
        print("Password: \(self.password)")
        
        touchAnim(sender) {
            self.handleError(self.email, view: self.emailTF)
            self.handleError(self.fullName, view: self.fullNameTF)
            self.handleError(self.phoneNumber, view: self.phoneNumberTF)
            self.handleError(self.password, view: self.passwordTF)
            
            guard !self.email.isEmpty,
                !self.fullName.isEmpty,
                !self.phoneNumber.isEmpty,
                !self.password.isEmpty,
                self.password.count > 8 else { return }
            
            guard isInternetAvailable() else {
                internetNotAvailable()
                return
            }
            
            self.delegate?.handleSignUp(self.email, fullName: self.fullName, phoneNumber: self.phoneNumber, password: self.password)
        }
    }
    
    func handleError(_ txt: String, view: UIView) {
        if !txt.isEmpty {
            borderView(view, color: .lightGray)
            
        } else {
            setupAnimBorderView(view)
        }
    }
    
    @objc func fullNameChanged(tf: UITextField) {
        if let text = tf.text {
            tf.text = text.capitalized
        }
    }
}

//MARK: - UITableViewDelegate

extension SignUpTVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 { return tableView.rowHeight }
        return 70.0
    }
}

//MARK: - UITextFieldDelegate

extension SignUpTVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            if let text = emailTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.isValidEmail {
                    borderView(emailTF, color: .lightGray)
                    email = text
                    fullNameTF.becomeFirstResponder()
                    
                } else {
                    setupAnimBorderView(emailTF)
                    email = ""
                    emailTF.becomeFirstResponder()
                }
            }
            
        } else if textField == fullNameTF {
            if let text = fullNameTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.containsOnlyLetters,
                    text.count < 30 {
                    borderView(fullNameTF, color: .lightGray)
                    fullName = text
                    phoneNumberTF.becomeFirstResponder()
                    
                } else {
                    setupAnimBorderView(fullNameTF)
                    fullName = ""
                    fullNameTF.becomeFirstResponder()
                }
            }
            
        } else if textField == phoneNumberTF {
            if let text = textField.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.containsOnlyDigits,
                    text.count < 15 {
                    borderView(phoneNumberTF, color: .lightGray)
                    phoneNumber = text
                    passwordTF.becomeFirstResponder()
                    
                } else {
                    setupAnimBorderView(phoneNumberTF)
                    phoneNumber = ""
                    phoneNumberTF.becomeFirstResponder()
                }
            }
            
        } else if textField == passwordTF {
            /*
            ● Minimum 8 characters
            ● At least 1 uppercase alphabet
            ● At least 1 lowercased alphabet
            ● At least 1 number
            ● At least 1 special character
            */
            if let text = passwordTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.isPassword {
                    borderView(passwordTF, color: .lightGray)
                    password = text
                    signUpDidTap(signUpBtn)
                    
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
            
        } else if textField == fullNameTF {
            if let text = fullNameTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.containsOnlyLetters,
                    text.count < 30 {
                    borderView(fullNameTF, color: .lightGray)
                    fullName = text
                } else {
                    setupAnimBorderView(fullNameTF)
                    fullName = ""
                }
            }
            
        } else if textField == phoneNumberTF {
            if let text = phoneNumberTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.containsOnlyDigits,
                    text.count < 15 {
                    borderView(phoneNumberTF, color: .lightGray)
                    phoneNumber = text
                    
                } else {
                    setupAnimBorderView(phoneNumberTF)
                    phoneNumber = ""
                }
            }
            
        } else if textField == passwordTF {
            /*
            ● Minimum 8 characters
            ● At least 1 uppercase alphabet
            ● At least 1 lowercased alphabet
            ● At least 1 number
            ● At least 1 special character
            */
            if let text = passwordTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.isPassword {
                    borderView(passwordTF, color: .lightGray)
                    password = text
                    handlePassword(text)
                    
                } else {
                    setupAnimBorderView(passwordTF)
                    password = ""
                }
            }
            
            isHiddenSV()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passwordTF {
            if let text = textField.text {
                handlePassword(text)
            }
            
            tableView.beginUpdates()
            heightConstraint.constant = 140.0
            
            UIView.animate(withDuration: 0.25) {
                self.sv.isHidden = false
            }
            
            tableView.endUpdates()
            
        } else {
            isHiddenSV()
        }
    }
    
    func isHiddenSV() {
        UIView.animate(withDuration: 0.1, animations: {
            self.sv.isHidden = true
        }) { (_) in
            self.tableView.beginUpdates()
            self.heightConstraint.constant = 70.0
            self.tableView.endUpdates()
        }
    }
}

//MARK: - DarkMode

extension SignUpTVC {
    
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
        tableView.backgroundColor = isDarkMode ? .black : .white
        appDl.window?.tintColor = isDarkMode ? .white : .black
        setupDMCell(isDarkMode)
    }
    
    func setupDMCell(_ isDarkMode: Bool = false) {
        let signUpC: UIColor = isDarkMode ? .black : .white
        let signUpAttr = setupTitleAttri(signUpTxt, txtColor: signUpC, size: 17.0)
        signUpBtn.setAttributedTitle(signUpAttr, for: .normal)
        signUpBtn.backgroundColor = isDarkMode ? .white : .black
        
        let bgTFC: UIColor = isDarkMode ? .black : .white
        let borderTFC: UIColor = isDarkMode ? .darkGray : .lightGray
        emailTF.backgroundColor = bgTFC
        emailTF.layer.borderColor = borderTFC.cgColor
        
        fullNameTF.backgroundColor = bgTFC
        fullNameTF.layer.borderColor = borderTFC.cgColor
        
        phoneNumberTF.backgroundColor = bgTFC
        phoneNumberTF.layer.borderColor = borderTFC.cgColor
        
        passwordTF.backgroundColor = bgTFC
        passwordTF.layer.borderColor = borderTFC.cgColor
        isShow = !passwordTF.isSecureTextEntry
    }
}
