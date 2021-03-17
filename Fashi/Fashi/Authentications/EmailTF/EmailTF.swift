//
//  EmailTF.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import CoreData

class EmailTF: UITextField {
    
    private let tableView = UITableView(frame: .zero)
    private var searchItem: [SearchItem] = []
    private var emailsList: [EmailList] = []
    
    var signInVC: SignInVC!
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView.removeFromSuperview()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        tableView.isHidden = true
        
        addTarget(self, action: #selector(tfEditingChanged), for: .editingChanged)
        addTarget(self, action: #selector(tfEditingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(tfEditingDidEnd), for: .editingDidEnd)
        addTarget(self, action: #selector(tfEditingDidEndOnExit), for: .editingDidEndOnExit)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildSearchTV()
    }
}

//MARK: - Configures

extension EmailTF {
    
    func buildSearchTV() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SignInTVCell")
        tableView.dataSource = self
        tableView.delegate = self
        window?.addSubview(tableView)
        
        updateSearchTV()
    }
    
    func updateSearchTV() {
        superview?.bringSubviewToFront(tableView)
        
        var tableHeight: CGFloat = 0.0
        tableHeight = tableView.contentSize.height
        if tableHeight < tableView.contentSize.height { tableHeight -= 10.0 }
        
        var rect = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: tableHeight)
        rect.origin = convert(rect.origin, to: nil)
        rect.origin.y += frame.size.height+5
        
        UIView.animate(withDuration: 0.2) { self.tableView.frame = rect }
        if isFirstResponder { superview?.bringSubviewToFront(self) }
        
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        tableView.separatorColor = lightSeparatorColor
        tableView.backgroundColor = .lightGray
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 5.0
        tableView.reloadData()
    }
    
    fileprivate func filter() {
        let predicate = NSPredicate(format: "email CONTAINS[cd] %@", text!)
        let request: NSFetchRequest<EmailList> = EmailList.fetchRequest()
        request.predicate = predicate
        
        do {
            emailsList = try signInVC.coreDataStack.managedObjectContext.fetch(request)
            
        } catch {}
        
        searchItem = []
        for i in 0..<emailsList.count {
            let emailList = emailsList[i]
            let item = SearchItem(email: emailList.email, password: emailList.password)
            let emailFilterRange = (item.email as NSString).range(of: text!, options: [.diacriticInsensitive, .caseInsensitive])
            
            if emailFilterRange.location != NSNotFound {
                item.attributedEmail = NSMutableAttributedString(string: item.email)
                item.attributedEmail!.setAttributes([.font : UIFont(name: fontNamed, size: 13.0)!], range: emailFilterRange)
                searchItem.append(item)
            }
        }
        
        tableView.reloadData()
    }
    
    @objc func tfEditingChanged(_ tf: UITextField) {
        filter()
        updateSearchTV()
    }
    
    @objc func tfEditingDidBegin(_ tf: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.tableView.isHidden = self.signInVC.emails.count == 0
        }
    }
    
    @objc func tfEditingDidEnd(_ tf: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.tableView.isHidden = true
        }
    }
    
    @objc func tfEditingDidEndOnExit(_ tf: UITextField) {
        print("*** tfEditingDidEndOnExit")
    }
}

//MARK: - UITableViewDataSource

extension EmailTF: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignInTVCell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        setupSelectedCell(selectC: UIColor(hex: 0xE5E5E5, alpha: 0.7)) { (selectedView) in
            cell.selectedBackgroundView = selectedView
        }
        
        let label = cell.textLabel!
        label.font = UIFont(name: fontNamed, size: 13.0)
        label.textColor = .white
        label.attributedText = searchItem[indexPath.row].getFormatterText()
        return cell
    }
}

//MARK: - UITableViewDelegate

extension EmailTF: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let email = searchItem[indexPath.item].getEmail()
        text = email
        
        let password = searchItem[indexPath.item].password
        let decrypt = try! password.aesDecrypt(key: passwordKey, iv: passwordIV)
        signInVC.passwordTF.text = decrypt
        signInVC.password = decrypt
        
        endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}
