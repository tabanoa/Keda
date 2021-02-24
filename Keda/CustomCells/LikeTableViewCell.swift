//
//  LikeTableViewCell.swift
//  Keda Profile
//
//  Created by Matthew Mukherjee on 12/22/2020.

import UIKit

class LikeTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupCell(user: FUser) {
        nameLabel.text = user.username
        setAvatar(avatarLink: user.avatarLink)
    }
    
    
    private func setAvatar(avatarLink: String) {
        
        FileStorage.downloadImage(imageUrl: avatarLink) { (avatarImage) in
            self.avatarImageView.image = avatarImage?.circleMasked
        }
    }
}
