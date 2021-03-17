//
//  ChangePasswordTVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Firebase

protocol ChangePasswordTVCDelegate: class {
    func handleSaveChanges(_ currentPassword: String, _ verifyPassword: String, vc: ChangePasswordTVC)
}

class ChangePasswordTVC: UITableViewController {
    
    //MARK: - Properties
    weak var delegate: ChangePasswordTVCDelegate?
    
    private let saveChangesBtn = ShowMoreBtn()
    private let cancelBtn = ShowMoreBtn()
    private var heightConstraint: NSLayoutConstraint!
    private var sv = UIStackView()
    private var charView = UIView()
    private var upperView = UIView()
    private var lowerView = UIView()
    private var numView = UIView()
    private var speCharView = UIView()
    
    private let currentPasswordTF = UITextField()
    private var isCurrentPShow = false
    private let rightCurrentPImgView = UIImageView()
    
    private let newPasswordTF = UITextField()
    private var isNewPShow = false
    private let rightNewPImgView = UIImageView()
    
    private let verifyPasswordTF = UITextField()
    private var isVerifyPShow = false
    private let rightVerifyPImgView = UIImageView()
    
    private var currentPassword = ""
    private var newPassword = ""
    private var verifyPassword = ""
    
    private let saveTxt = NSLocalizedString("Save Changes", comment: "ChangePasswordTVC.swift: Save Changes")
    private let cancelTxt = NSLocalizedString("Cancel", comment: "ChangePasswordTVC.swift: Cancel")
    
    private let iconPassword = "icon-password"
    
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

extension ChangePasswordTVC {
    
    func updateUI() {
        tableView.backgroundColor = groupColor
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChangePasswordTVCell")
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
    }
}

//MARK: - Functions

extension ChangePasswordTVC {
    
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

extension ChangePasswordTVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangePasswordTVCell", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            let txt = NSLocalizedString("Current password", comment: "ChangePasswordTVC.swift: Current password")
            setupPassword(currentPasswordTF, cell, placeholder: txt, rightIMGView: rightCurrentPImgView, imgViewSelector: #selector(currentPasswordEyeDidTap))
        case 1:
            let txt = NSLocalizedString("New password", comment: "ChangePasswordTVC.swift: New password")
            setupNewPassword(cell, placeholder: txt)
        case 2:
            let txt = NSLocalizedString("Verify password", comment: "ChangePasswordTVC.swift: Verify password")
            setupPassword(verifyPasswordTF, cell, placeholder: txt, rightIMGView: rightVerifyPImgView, imgViewSelector: #selector(verifyPasswordEyeDidTap))
        default:
            let width = (screenWidth-30)/2
            saveChangesBtn.configureLogInSignUpBtn(saveTxt, txtColor: .white, bgColor: .black, selector: #selector(saveChangesDidTap), vc: self, width: width)
            setupSaveChangesConstraint(saveChangesBtn, cell: cell)

            cancelBtn.configureLogInSignUpBtn(cancelTxt, txtColor: .white, bgColor: .black, selector: #selector(cancelDidTap), vc: self, width: width)
            setupCancelConstraint(cancelBtn, cell: cell)
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
    
    func setupSaveChangesConstraint(_ childView: UIView, cell: UITableViewCell) {
        cell.contentView.addSubview(childView)
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10.0),
            childView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10.0),
        ])
    }
    
    func setupCancelConstraint(_ childView: UIView, cell: UITableViewCell) {
        cell.contentView.addSubview(childView)
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10.0),
            childView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10.0),
        ])
    }
    
    func setupNewPassword(_ cell: UITableViewCell, placeholder: String) {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        cell.contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        newPasswordTF.configureFromTFLeftRightView(placeholder, imgName: "icon-password", rightImgView: rightNewPImgView)
        newPasswordTF.delegate = self
        newPasswordTF.isSecureTextEntry = true
        newPasswordTF.addTarget(self, action: #selector(newPasswordChanged), for: .editingChanged)
        containerView.addSubview(newPasswordTF)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(newPasswordEyeDidTap))
        rightNewPImgView.addGestureRecognizer(tap)
        
        let sv = handleAssertPass(containerView)
        
        heightConstraint = containerView.heightAnchor.constraint(equalToConstant: 70.0)
        heightConstraint.priority = UILayoutPriority.defaultLow
        NSLayoutConstraint.activate([
            heightConstraint,
            containerView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            
            newPasswordTF.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10.0),
            newPasswordTF.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            sv.leadingAnchor.constraint(equalTo: newPasswordTF.leadingAnchor, constant: 10.0),
            sv.topAnchor.constraint(equalTo: newPasswordTF.bottomAnchor, constant: 10.0),
        ])
    }
    
    func setupPassword(_ tf: UITextField, _ cell: UITableViewCell, placeholder: String, rightIMGView: UIImageView, imgViewSelector: Selector) {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        cell.contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        tf.configureFromTFLeftRightView(placeholder, imgName: "icon-password", rightImgView: rightIMGView)
        tf.delegate = self
        tf.isSecureTextEntry = true
        containerView.addSubview(tf)
        
        let tap = UITapGestureRecognizer(target: self, action: imgViewSelector)
        rightIMGView.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            
            tf.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10.0),
            tf.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    @objc func currentPasswordEyeDidTap() {
        isCurrentPShow = !isCurrentPShow
        rightCurrentPImgView.image = UIImage(named: isCurrentPShow ? "icon-eyeOn" : "icon-eyeOff")
        currentPasswordTF.isSecureTextEntry = !isCurrentPShow
    }
    
    @objc func newPasswordEyeDidTap() {
        isNewPShow = !isNewPShow
        rightNewPImgView.image = UIImage(named: isNewPShow ? "icon-eyeOn" : "icon-eyeOff")
        newPasswordTF.isSecureTextEntry = !isNewPShow
    }
    
    @objc func verifyPasswordEyeDidTap() {
        isVerifyPShow = !isVerifyPShow
        rightVerifyPImgView.image = UIImage(named: isVerifyPShow ? "icon-eyeOn" : "icon-eyeOff")
        verifyPasswordTF.isSecureTextEntry = !isVerifyPShow
    }
    
    func handleAssertPass(_ containerView: UIView) -> UIStackView {
        let charTxt = NSLocalizedString("Minimum 8 characters.", comment: "ChangePasswordTVC.swift: Minimum 8 characters.")
        charView = setupSubview()
        let charLbl = setupLbl(charTxt)
        let charSV = setupStackView(charView, lbl: charLbl)
        
        let upperTxt = NSLocalizedString("At least 1 uppercase.", comment: "ChangePasswordTVC.swift: At least 1 uppercase.")
        upperView = setupSubview()
        let upperLbl = setupLbl(upperTxt)
        let upperSV = setupStackView(upperView, lbl: upperLbl)
        
        let lowerTxt = NSLocalizedString("At least 1 lowercased.", comment: "ChangePasswordTVC.swift: At least 1 lowercased.")
        lowerView = setupSubview()
        let lowerLbl = setupLbl(lowerTxt)
        let lowerSV = setupStackView(lowerView, lbl: lowerLbl)
        
        let numTxt = NSLocalizedString("At least 1 number.", comment: "ChangePasswordTVC.swift: At least 1 number.")
        numView = setupSubview()
        let numLbl = setupLbl(numTxt)
        let numSV = setupStackView(numView, lbl: numLbl)
        
        let speCharTxt = NSLocalizedString("At least 1 special character.", comment: "ChangePasswordTVC.swift: At least 1 special character.")
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
    
    @objc func newPasswordChanged(_ tf: UITextField) {
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
    
    @objc func saveChangesDidTap(_ sender: UIButton) {
        self.tableView.endEditing(true)
        
        print("===============//===============")
        print("Current-P: \(self.currentPassword)")
        print("new-P: \(self.newPassword)")
        print("Verify-P: \(self.verifyPassword)")
        
        touchAnim(sender) {
            self.handleError(self.currentPassword, view: self.currentPasswordTF)
            self.handleError(self.newPassword, view: self.newPasswordTF)
            self.handleError(self.verifyPassword, view: self.verifyPasswordTF)
            
            guard isInternetAvailable() else {
                internetNotAvailable()
                return
            }
            
            guard !self.currentPassword.isEmpty,
                !self.newPassword.isEmpty,
                !self.verifyPassword.isEmpty else {
                    let titleTxt = NSLocalizedString("Whoops!!!", comment: "ChangePasswordTVC.swift: Whoops!!!")
                    let mesTxt = NSLocalizedString("Missing data", comment: "ChangePasswordTVC.swift: Missing data")
                    handleErrorAlert(titleTxt, mes: mesTxt, act: "OK", vc: self)
                    return
            }
            
            guard self.newPassword.elementsEqual(self.verifyPassword) else {
                let titleTxt = NSLocalizedString("Whoops!!!", comment: "ChangePasswordTVC.swift: Whoops!!!")
                let mesTxt = NSLocalizedString("New password and confirmation password are not the same", comment: "ChangePasswordTVC.swift: New password and confirmation password are not the same")
                handleErrorAlert(titleTxt, mes: mesTxt, act: "OK", vc: self)
                return
            }
            
            self.delegate?.handleSaveChanges(self.currentPassword, self.verifyPassword, vc: self)
        }
    }
    
    @objc func cancelDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleError(_ txt: String, view: UIView) {
        if !txt.isEmpty {
            borderView(view, color: .lightGray)
            
        } else {
            setupAnimBorderView(view)
        }
    }
}

//MARK: - UITableViewDelegate

extension ChangePasswordTVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 { return tableView.rowHeight }
        return 70.0
    }
}

//MARK: - UITextFieldDelegate

extension ChangePasswordTVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == currentPasswordTF {
            if let text = currentPasswordTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                    borderView(currentPasswordTF, color: .lightGray)
                    currentPassword = text
                    newPasswordTF.becomeFirstResponder()
                    
                } else {
                    setupAnimBorderView(currentPasswordTF)
                    currentPassword = ""
                    currentPasswordTF.becomeFirstResponder()
                }
            }
            
        } else if textField == newPasswordTF {
            /*
            ● Minimum 8 characters
            ● At least 1 uppercase alphabet
            ● At least 1 lowercased alphabet
            ● At least 1 number
            ● At least 1 special character
            */
            if let text = newPasswordTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.isPassword {
                    borderView(newPasswordTF, color: .lightGray)
                    newPassword = text
                    verifyPasswordTF.becomeFirstResponder()
                    
                } else {
                    setupAnimBorderView(newPasswordTF)
                    newPassword = ""
                    newPasswordTF.becomeFirstResponder()
                }
            }
            
        } else if textField == verifyPasswordTF {
            /*
            ● Minimum 8 characters
            ● At least 1 uppercase alphabet
            ● At least 1 lowercased alphabet
            ● At least 1 number
            ● At least 1 special character
            */
            if let text = verifyPasswordTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.isPassword {
                    borderView(verifyPasswordTF, color: .lightGray)
                    verifyPassword = text
                    saveChangesDidTap(saveChangesBtn)
                    
                } else {
                    setupAnimBorderView(verifyPasswordTF)
                    verifyPassword = ""
                    verifyPasswordTF.becomeFirstResponder()
                }
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == currentPasswordTF {
            if let text = currentPasswordTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                    borderView(currentPasswordTF, color: .lightGray)
                    currentPassword = text
                    
                } else {
                    setupAnimBorderView(currentPasswordTF)
                    currentPassword = ""
                }
            }
            
        } else if textField == newPasswordTF {
            /*
            ● Minimum 8 characters
            ● At least 1 uppercase alphabet
            ● At least 1 lowercased alphabet
            ● At least 1 number
            ● At least 1 special character
            */
            if let text = newPasswordTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.isPassword {
                    borderView(newPasswordTF, color: .lightGray)
                    newPassword = text
                    handlePassword(text)
                    
                } else {
                    setupAnimBorderView(newPasswordTF)
                    newPassword = ""
                }
            }
            
            isHiddenSV()
            
        } else if textField == verifyPasswordTF {
            /*
            ● Minimum 8 characters
            ● At least 1 uppercase alphabet
            ● At least 1 lowercased alphabet
            ● At least 1 number
            ● At least 1 special character
            */
            if let text = verifyPasswordTF.text {
                if !text.trimmingCharacters(in: .whitespaces).isEmpty,
                    text.isPassword {
                    borderView(verifyPasswordTF, color: .lightGray)
                    verifyPassword = text
                    handlePassword(text)
                    
                } else {
                    setupAnimBorderView(verifyPasswordTF)
                    verifyPassword = ""
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == newPasswordTF {
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

extension ChangePasswordTVC {
    
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
        let btnC: UIColor = isDarkMode ? .black : .white
        let saveAttr = setupTitleAttri(saveTxt, txtColor: btnC, size: 17.0)
        saveChangesBtn.setAttributedTitle(saveAttr, for: .normal)
        saveChangesBtn.backgroundColor = isDarkMode ? .white : .black
        
        let cancelAttr = setupTitleAttri(cancelTxt, txtColor: btnC, size: 17.0)
        cancelBtn.setAttributedTitle(cancelAttr, for: .normal)
        cancelBtn.backgroundColor = isDarkMode ? .white : .black
        
        let bgTFC: UIColor = isDarkMode ? .black : .white
        let borderTFC: UIColor = isDarkMode ? .darkGray : .lightGray
        currentPasswordTF.backgroundColor = bgTFC
        currentPasswordTF.layer.borderColor = borderTFC.cgColor
        isCurrentPShow = !currentPasswordTF.isSecureTextEntry
        
        newPasswordTF.backgroundColor = bgTFC
        newPasswordTF.layer.borderColor = borderTFC.cgColor
        isNewPShow = !newPasswordTF.isSecureTextEntry
        
        verifyPasswordTF.backgroundColor = bgTFC
        verifyPasswordTF.layer.borderColor = borderTFC.cgColor
        isVerifyPShow = !verifyPasswordTF.isSecureTextEntry
    }
}
