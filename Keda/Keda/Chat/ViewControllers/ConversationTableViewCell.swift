//
//  ConversationTableViewCell.swift
//  Keda
//
//  Created by Ben Jenkyn on 2021-04-06.
//  Copyright © 2021 Keda Team. All rights reserved.
//

import UIKit
import SDWebImage

class ConversationTableViewCell: UITableViewCell {
    
    static let identifier = "ConversationTableViewCell"
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    
    private let userMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessageLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.frame = CGRect(x: 10,
                                     y: 10,
                                     width: 100,
                                     height: 100)
        
        userNameLabel.frame = CGRect(x: userImageView.msgRight + 10,
                                     y: 10,
                                     width: contentView.msgWidth - 20 - userImageView.msgWidth,
                                     height: (contentView.msgHeight-20)/2)
        
        userMessageLabel.frame = CGRect(x: userImageView.msgRight + 10,
                                        y: userNameLabel.msgBottom + 10,
                                        width: contentView.msgWidth - 20 - userImageView.msgWidth,
                                        height: (contentView.msgHeight-20)/2)
        
    }
    
    public func configure(with model: Conversation){
        self.userMessageLabel.text = model.latestMessage.text
        self.userNameLabel.text = model.name
        
        //let path = "\(model.otherUserUid)_profile_picture.png"
        //Return here time 28:00
        
        let fileUrl = URL(string: "https://i.imgur.com/c4nAiua.jpg")
        
        DispatchQueue.main.async {
            self.userImageView.sd_setImage(with: fileUrl, completed: nil)
        }
    }
}
