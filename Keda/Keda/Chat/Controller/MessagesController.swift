//
//  MessagesController.swift
//  Keda
//
//  Created by Laptop on 2021-03-24.
//  Copyright © 2021 Keda Team. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController, UIGestureRecognizerDelegate {
    
    var messages = [Message]()
    var messagesDictionary = [String : Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "write-icon")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellId")
        
//        checkIfUserLoggedIn()
        observeUserMessages()
    }
    
    func observeUserMessages() {
        if let currentUserId = Auth.auth().currentUser?.uid {
            let userMessagesRef = Database.database().reference().child("user-messages")
            userMessagesRef.child(currentUserId).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                let messageRef = Database.database().reference().child("messages")
                messageRef.child(messageId).observe(.value, with: { (snap) in
                    if let dictionary = snap.value as? [String: AnyObject] {
                        let message = Message()
                        message.text = dictionary["text"] as? String
                        message.fromId = dictionary["fromId"] as? String
                        message.toId = dictionary["toId"] as? String
                        message.timestamp = dictionary["timestamp"] as? NSNumber
                        
                        if let toId = message.chatPartnerId() {
                            self.messagesDictionary[toId] = message
                            self.messages = Array(self.messagesDictionary.values)
                            self.messages.sort(by: { (message1, message2) -> Bool in
                                return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                            })
                        }
                        
                        // reload table
                        DispatchQueue.global(qos: .userInteractive).async {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }, withCancel: nil)
            }, withCancel: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = self.messages[indexPath.row]
        guard let toId = message.chatPartnerId() else {
            return
        }
    }
        
//        Database.database().reference().child("users").child(toId).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let dictionary = snapshot.value as? [String : AnyObject] {
//                let user = User.fetchCurrentUser { (user) in
//                    user.uid = toId
//                    user.fullName = dictionary["name"] as? String
//                    user.email = dictionary["email"] as? String
//                    user.avatarLink = dictionary["avatar"] as? String
//                    self.showChatController(user: User)
//                }
//
//            }
//        })
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
//    func checkIfUserLoggedIn() {
//        // user is not logged in
//        if Auth.auth().currentUser?.uid == nil {
//            //perform(#selector(handleLogout), with: nil, afterDelay: 0)
//        } else {
//            //fetchUserAndSetupNavbarTitle()
//            print("not logged in")
//        }
//    }
    
    func setupNavBarWithUser(user: User) {
        self.messages.removeAll()
        self.messagesDictionary.removeAll()
        tableView.reloadData()
        
        // profile image view
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 12.5
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        if user.avatarLink != nil {
            profileImageView.loadImageUsingCacheWithURL(urlString: user.avatarLink!)
        }
        
        // user name label view
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = user.fullName
        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        // container
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(profileImageView)
        container.addSubview(nameLabel)
        
        container.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        profileImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        nameLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        
        self.navigationItem.titleView = container
        
    }
    
    func showChatController(user: User) {
        let chatController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        navigationController?.pushViewController(chatController, animated: true)
    }
//
//    @objc func handleLogout() {
//
//        do {
//            try Auth.auth().signOut()
//        } catch let logoutError {
//            print(logoutError)
//        }
//
//        let loginController = LoginController()
//        loginController.messageController = self
//        //loginController.messageController?.messages.removeAll()
//        //loginController.messageController?.messagesDictionary.removeAll()
//        present(loginController, animated: true, completion: nil)
//    }
    
}
