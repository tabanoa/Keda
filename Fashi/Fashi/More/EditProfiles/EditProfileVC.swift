//
//  EditProfileVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Firebase

class EditProfileVC: UIViewController {
    
    //MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let firstNameView = UIView()
    private let lastNameView = UIView()
    private let emailAddressView = UIView()
    private let phoneNumberView = UIView()
    
    private let firstNameLbl = UILabel()
    private let lastNameLbl = UILabel()
    private let emailAddressLbl = UILabel()
    private let phoneNumberLbl = UILabel()
    private let firstNameTF = UITextField()
    private let lastNameTF = UITextField()
    private let emailAddressTF = UITextField()
    private let phoneNumberTF = UITextField()
    
    private let cancelBtn = UIButton()
    private let doneBtn = UIButton()
    
    private let cancelTxt = NSLocalizedString("Cancel", comment: "EditProfileVC.swift: Cancel")
    private let doneTxt = NSLocalizedString("Done", comment: "EditProfileVC.swift: Done")
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    var userUID: String = ""
    var firstName = ""
    var lastName = ""
    var email = ""
    var phoneNumber = ""
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupTV()
        setupDarkMode()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
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

//MARK: - Configures

extension EditProfileVC {
    
    func setupNavi() {
        view.backgroundColor = groupColor
        navigationItem.title = NSLocalizedString("Edit Profile", comment: "EditProfileVC.swift: Edit Profile")
        
        //TODO: - CancelBtn
        let cancelAttributed = setupTitleAttri(cancelTxt, fontN: fontNamed, size: 17.0)
        cancelBtn.setAttributedTitle(cancelAttributed, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelDidTap), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelBtn)
        
        //TODO: - DoneBtn
        let doneAttributed = setupTitleAttri(doneTxt, size: 17.0)
        doneBtn.setAttributedTitle(doneAttributed, for: .normal)
        doneBtn.addTarget(self, action: #selector(doneDidTap), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneBtn)
    }
    
    @objc func cancelDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func doneDidTap(_ sender: UIButton) {
        endEditing()
        
        print("===============//===============")
        print("FirstName: \(self.firstName)")
        print("LastName: \(self.lastName)")
        print("Email: \(self.email)")
        print("PhoneNumber: \(self.phoneNumber)")
        
        touchAnim(sender) {
            guard isInternetAvailable() else {
                internetNotAvailable()
                return
            }
            
            if !self.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                !self.lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                !self.phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                
                let toDictionary = [
                    "fullName": self.firstName + " " + self.lastName,
                    "phoneNumber": self.phoneNumber
                ]
                
                let hud = createdHUD()
                let ref = DatabaseRef.user(uid: self.userUID).ref()
                ref.updateChildValues(toDictionary)
                UIView.animate(withDuration: 0.5, animations: {
                    hud.alpha = 0.0
                }) { (_) in
                    hud.removeFromSuperview()
                    self.navigationController?.popViewController(animated: true)
                }
                
            } else {
                return
            }
        }
    }
    
    func setupTV() {
        tableView.configureTVSepar(groupColor, ds: self, dl: self, view: view)
        tableView.separatorColor = lightSeparatorColor
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EditProfileTVCell")
        tableView.rowHeight = 60.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
    }
    
    @objc func endEditing() {
        tableView.endEditing(true)
    }
}

//MARK: - UITableViewDataSource

extension EditProfileVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTVCell", for: indexPath)
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let txt = NSLocalizedString("First Name", comment: "EditProfileVC.swift: First Name")
                setupContainerView(firstNameView, cell: cell)
                setupTitle(firstNameLbl, text: txt, view: firstNameView)
                setupTF(firstNameTF, view: firstNameView, placeholder: "Thanh", txt: firstName)
                firstNameTF.addTarget(self, action: #selector(firstNameChanged), for: .editingChanged)
            default:
                let txt = NSLocalizedString("Last Name", comment: "EditProfileVC.swift: Last Name")
                setupContainerView(lastNameView, cell: cell)
                setupTitle(lastNameLbl, text: txt, view: lastNameView)
                setupTF(lastNameTF, view: lastNameView, placeholder: "Nguyễn", txt: lastName)
                lastNameTF.addTarget(self, action: #selector(lastNameChanged), for: .editingChanged)
            }
            
        } else {
            switch indexPath.row {
            case 0:
                let txt = NSLocalizedString("E-mail Address", comment: "EditProfileVC.swift: E-mail Address")
                setupContainerView(emailAddressView, cell: cell)
                setupTitle(emailAddressLbl, text: txt, view: emailAddressView)
                setupTF(emailAddressTF, view: emailAddressView, placeholder: "jack@gmail.com", keyboardType: .emailAddress, txt: "")
                emailAddressTF.isUserInteractionEnabled = false
                emailAddressTF.textColor = .gray
                
                if let index = email.firstIndex(of: "@") {
                    let start = email.distance(from: email.startIndex, to: index)
                    let end = email.distance(from: index, to: email.endIndex)
                    let count = email.count
                    let prefix = email.prefix(2)
                    let suffix = email.suffix(1)
                    let startStr = String(repeating: "•", count: count-end-2)
                    let endStr = String(repeating: "•", count: count-start-2)
                    let left = "\(prefix + startStr + "\(email[index])")"
                    let right = "\(endStr + suffix)"
                    emailAddressTF.text = "\(left + right)"
                    
                } else {
                    emailAddressTF.text = email
                }
                
                let titleTxt: String
                let txtColor: UIColor
                if Auth.auth().currentUser!.isEmailVerified {
                    titleTxt = NSLocalizedString("Verified", comment: "EditProfileVC.swift: Verified")
                    
                    txtColor = UIColor(hex: 0x5ED112)
                    
                } else {
                    titleTxt = NSLocalizedString("Verify", comment: "EditProfileVC.swift: Verify")
                    
                    txtColor = UIColor(hex: 0xE72A2A)
                }
                
                let verifyBtn = UIButton()
                let attri = setupTitleAttri(titleTxt, txtColor: txtColor, fontN: fontNamedBold, size: 12.0)
                verifyBtn.setAttributedTitle(attri, for: .normal)
                verifyBtn.contentEdgeInsets = UIEdgeInsets(top: 2.0, left: 7.0, bottom: 2.0, right: 7.0)
                verifyBtn.clipsToBounds = true
                verifyBtn.layer.cornerRadius = 3.0
                verifyBtn.layer.borderColor = txtColor.cgColor
                verifyBtn.layer.borderWidth = 1.0
                verifyBtn.addTarget(self, action: #selector(verifyDidTap), for: .touchUpInside)
                cell.contentView.insertSubview(verifyBtn, aboveSubview: emailAddressTF)
                verifyBtn.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    verifyBtn.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10.0),
                    verifyBtn.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 5.0)
                ])
                
            default:
//                let txt = "Số Điện Thoại"
                let txt = NSLocalizedString("Phone Number", comment: "EditProfileVC.swift: Phone Number")
                setupContainerView(phoneNumberView, cell: cell)
                setupTitle(phoneNumberLbl, text: txt, view: phoneNumberView)
                setupTF(phoneNumberTF, view: phoneNumberView, placeholder: "84987123456", keyboardType: .numberPad, txt: phoneNumber)
            }
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
    
    @objc func verifyDidTap(_ sender: UIButton) {
        guard !Auth.auth().currentUser!.isEmailVerified else { return }
        touchAnim(sender) {
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                guard error == nil else {
                    let titleTxt = NSLocalizedString("Whoops!!!", comment: "EditProfileVC.swift: Whoops!!!")
                    let mesTxt = NSLocalizedString("Email address is not invalid", comment: "EditProfileVC.swift: Email address is not invalid")
                    
                    handleErrorAlert(titleTxt, mes: mesTxt, act: "OK", vc: self)
                    return
                }
                
                self.tableView.reloadData()
            })
        }
    }
    
    func setupContainerView(_ view: UIView, cell: UITableViewCell) {
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.white.cgColor
        cell.contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 5.0),
            view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 5.0),
            view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -5.0),
            view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -5.0),
        ])
    }
    
    func setupTitle(_ lbl: UILabel, text: String, view: UIView) {
        lbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: text, fontN: fontNamed)
        view.addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
            lbl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func setupTF(_ textField: UITextField, view: UIView, placeholder: String, keyboardType: UIKeyboardType = .default, txt: String) {
        textField.font = UIFont(name: fontNamed, size: 17.0)
        textField.text = txt
        textField.placeholder = placeholder
        textField.textAlignment = .right
        textField.keyboardType = keyboardType
        textField.delegate = self
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let width = screenWidth/2 - 60.0
        NSLayoutConstraint.activate([
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0),
            textField.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: width),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc func firstNameChanged(tf: UITextField) {
        if let text = tf.text {
            tf.text = text.capitalized
        }
    }
    
    @objc func lastNameChanged(tf: UITextField) {
        if let text = tf.text {
            tf.text = text.capitalized
        }
    }
}

//MARK: - UITableViewDelegate

extension EditProfileVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: firstNameTF.becomeFirstResponder()
            default: lastNameTF.becomeFirstResponder()
            }
            
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0: emailAddressTF.becomeFirstResponder()
            default: phoneNumberTF.becomeFirstResponder()
            }
        }
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
        
        if section == 0 {
            let publicLbl = UILabel()
            let txt = NSLocalizedString("PUBLIC PROFILE", comment: "EditProfileVC.swift: PUBLIC PROFILE")
            publicLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
            publicLbl.configureHeaderTitle(kView)
            
        } else if section == 1 {
            let privateLbl = UILabel()
            let txt = NSLocalizedString("PRIVATE DETAILS", comment: "EditProfileVC.swift: PRIVATE DETAILS")
            privateLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
            privateLbl.configureHeaderTitle(kView)
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

extension EditProfileVC: UINavigationControllerDelegate {
    
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

//MARK: - UITextFieldDelegate

extension EditProfileVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTF {
            if let text = firstNameTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.containsOnlyLetters, text.count < 20 {
                    borderView(firstNameView)
                    firstName = text
                    lastNameTF.becomeFirstResponder()
                    
                } else {
                    setupAnimBorderView(firstNameView)
                    firstName = ""
                    firstNameTF.becomeFirstResponder()
                }
            }
            
        } else if textField == lastNameTF {
            if let text = lastNameTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.containsOnlyLetters, text.count < 20 {
                    borderView(lastNameView)
                    lastName = text
                    emailAddressTF.becomeFirstResponder()
                    
                } else {
                    setupAnimBorderView(lastNameView)
                    lastName = ""
                    lastNameTF.becomeFirstResponder()
                }
            }
            
        } else if textField == phoneNumberTF {
            if let text = textField.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.containsOnlyDigits {
                    borderView(phoneNumberView)
                    phoneNumber = text
                    phoneNumberTF.resignFirstResponder()
                    
                } else {
                    setupAnimBorderView(phoneNumberView)
                    phoneNumber = ""
                    phoneNumberTF.becomeFirstResponder()
                }
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == firstNameTF {
            if let text = firstNameTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.containsOnlyLetters, text.count < 20 {
                    borderView(firstNameView)
                    firstName = text
                    
                } else {
                    setupAnimBorderView(firstNameView)
                    firstName = ""
                }
            }
            
        } else if textField == lastNameTF {
            if let text = lastNameTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.containsOnlyLetters, text.count < 20 {
                    borderView(lastNameView)
                    lastName = text
                    
                } else {
                    setupAnimBorderView(lastNameView)
                    lastName = ""
                }
            }
            
        } else if textField == phoneNumberTF {
            if let text = textField.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.containsOnlyDigits {
                    borderView(phoneNumberView)
                    phoneNumber = text
                    
                } else {
                    setupAnimBorderView(phoneNumberView)
                    phoneNumber = ""
                }
            }
        }
    }
}

//MARK: - DarkMode

extension EditProfileVC {
    
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
        appDl.window?.tintColor = isDarkMode ? .white : .black
    }
    
    private func setupDMLbl(_ isDarkMode: Bool = false) {
        let txtC: UIColor = isDarkMode ? .white : .black
        firstNameLbl.textColor = txtC
        lastNameLbl.textColor = txtC
        emailAddressLbl.textColor = txtC
        phoneNumberLbl.textColor = txtC
        
        let tfC: UIColor = isDarkMode ? darkColor : .white
        firstNameTF.textColor = txtC
        firstNameTF.backgroundColor = tfC
        
        lastNameTF.textColor = txtC
        lastNameTF.backgroundColor = tfC
        
        emailAddressTF.textColor = isDarkMode ? .lightGray : .gray
        emailAddressTF.backgroundColor = tfC
        
        phoneNumberTF.textColor = txtC
        phoneNumberTF.backgroundColor = tfC
        
        let vC: UIColor = isDarkMode ? darkColor : .white
        firstNameView.backgroundColor = vC
        firstNameView.layer.borderColor = vC.cgColor
        
        lastNameView.backgroundColor = vC
        lastNameView.layer.borderColor = vC.cgColor
        
        emailAddressView.backgroundColor = vC
        emailAddressView.layer.borderColor = vC.cgColor
        
        phoneNumberView.backgroundColor = vC
        phoneNumberView.layer.borderColor = vC.cgColor
    }
}
