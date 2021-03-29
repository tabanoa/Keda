//
//  ChatLogController.swift
//  Keda
//
//  Created by Laptop on 2021-03-24.
//  Copyright © 2021 Keda Team. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    var user: User? {
        didSet {
            navigationItem.title = user?.fullName
            observeMessages()
        }
    }
    var messages = [Message]()
    
    func observeMessages() {
        if let currentUserId = Auth.auth().currentUser?.uid {
            let userMessagesRef = Database.database().reference().child("user-messages").child(currentUserId)
            userMessagesRef.observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                print("message ID: " + messageId)
                let messageRef = Database.database().reference().child("messages").child(messageId)
                messageRef.observe(.value, with: { (snap) in
                    if let dictionary = snap.value as? [String : AnyObject] {
                        let message = Message()
                        message.fromId = dictionary["fromId"] as? String
                        message.toId = dictionary["toId"] as? String
                        message.text = dictionary["text"] as? String
                        message.timestamp = dictionary["timestamp"] as? NSNumber
                        
                        if message.chatPartnerId() == self.user?.uid {
                            self.messages.append(message)
                            DispatchQueue.global(qos: .userInteractive).async {
                                DispatchQueue.main.async {
                                    self.collectionView?.reloadData()
                                }
                            }
                        }
                
                    }
                }, withCancel: nil)
            }, withCancel: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: "cellId")
        setupInputComponents()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChatMessageCell
        cell.backgroundColor = UIColor.white
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        setUpCell(cell: cell, message: message)
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 30
        return cell
    }
    
    private func setUpCell(cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.avatarLink {
            cell.profileImageView.loadImageUsingCacheWithURL(urlString: profileImageUrl)
        }
        if message.fromId == Auth.auth().currentUser?.uid {
            // blue bubble text
            cell.bubbleView.backgroundColor = .blue
            cell.profileImageView.isHidden = true
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
        } else {
            // grey bubble text
            cell.bubbleView.backgroundColor = UIColor.lightGray
            cell.bubbleLeftAnchor?.isActive = true
            cell.bubbleRightAnchor?.isActive = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let message = self.messages[indexPath.item]
        if let messageText = message.text {
            height = estimateFrameForText(text: messageText).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let cgSize = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: cgSize, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    let sendButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Send", for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(handleSend), for: UIControl.Event.touchDown)
        return button
    }()
    
    lazy var inputTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter message"
        textfield.delegate = self
        textfield.backgroundColor = UIColor.white
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .white
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    @objc func handleSend() {
        // save text message into firebase database
        let mess_ref = Database.database().reference(fromURL: "https://messageapp-b566d-default-rtdb.firebaseio.com/").child("messages")
        let childmess_ref = mess_ref.childByAutoId()
        
        // IDs of sender and recipient
        let toId = user?.uid
        let fromId = Auth.auth().currentUser?.uid
        // timestamp for message
        let timestamp: NSNumber = NSDate().timeIntervalSince1970 as NSNumber
        
        // dictionary to store into database
        let value = ["text": inputTextField.text!, "toId": toId!, "fromId": fromId!, "timestamp": timestamp] as [String : Any]
        childmess_ref.setValue(value) { (error, ref) in
            if error != nil {
                print (error!)
                return
            }
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId!)
            userMessagesRef.updateChildValues([childmess_ref.key:1])
            let recipientMessagesRef = Database.database().reference().child("user-messages").child(toId!)
            recipientMessagesRef.updateChildValues([childmess_ref.key:1])
        }
        
        // clear input textfield
        inputTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    func setupInputComponents() {
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        view.addSubview(separator)
        
        separator.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separator.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // ios 9 constraints
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // adding send button
        containerView.addSubview(sendButton)
        containerView.addSubview(inputTextField)
        
        // ios 9 constraints
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
    }

}
