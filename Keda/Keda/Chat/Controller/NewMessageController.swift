//
//  NewMessageController.swift
//  Keda
//
//  Created by Laptop on 2021-03-24.
//  Copyright © 2021 Keda Team. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    let cellID = "cellID"
    var users = [User]()
    var messagesController: MessagesController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        self.navigationItem.title = "Friends list"
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
        //fetchUser()
    }
    
//    func fetchUser() {
//        Database.database().reference().child("users").observe(.childAdded, andPreviousSiblingKeyWith: { (snapshot, error) in
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                let user: () = User.fetchCurrentUser(completion: )
//                user.fullName = dictionary["fullName"] as? String
//                user.email = dictionary["email"] as? String
//                user.avatarLink = dictionary["avatarLink"] as? String
//                user.uid = snapshot.key
//                //user.setValuesForKeys(dictionary)
//                self.users.append(user)
//                
//                // this will crash because of background thread, so lets use dispatch_async to fix
//                DispatchQueue.global(qos: .userInteractive).async {
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                }
//            }
//        }, withCancel: nil)
//    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        let user = self.users[indexPath.row]
        cell.textLabel?.text = user.fullName
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.avatarLink {
            cell.profileImageView.loadImageUsingCacheWithURL(urlString: profileImageUrl)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        
        self.dismiss(animated: true) {
            self.messagesController?.showChatController(user: user)
        }
    }
}
