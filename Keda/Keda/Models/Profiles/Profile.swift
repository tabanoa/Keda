//
//  Profile.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class Profile {
    
    var title: String
    var image: UIImage?
    
    init(title: String, image: UIImage?) {
        self.title = title
        self.image = image
    }
    
    class func fetchDataForMember() -> [Profile] {
        return [
            Profile(title: NSLocalizedString("Account Details", comment: "Profile.swift: Account Details"), image: UIImage(named: "icon-acc")),
            Profile(title: NSLocalizedString("Order History", comment: "Profile.swift: Order History"), image: UIImage(named: "icon-history")),
            Profile(title: NSLocalizedString("Settings", comment: "Profile.swift: Settings"), image: UIImage(named: "icon-settings")),
            Profile(title: NSLocalizedString("Contact Us", comment: "Profile.swift: Contact Us"), image: UIImage(named: "icon-contact")),
            Profile(title: NSLocalizedString("Clear Watch History", comment: "Profile.swift: Clear Watch History"), image: UIImage(named: "icon-watchHistory")),
            Profile(title: NSLocalizedString("Clear Search History", comment: "Profile.swift: Clear Search History"), image: UIImage(named: "icon-searchHistory")),
            //Make a new chat icon
            Profile(title: NSLocalizedString("Chats", comment: "Profile.swift: Chat"), image: UIImage(named: "icon-searchHistory")),
            Profile(title: NSLocalizedString("Notifications", comment: "Profile.swift: Notifications"), image: UIImage(named: "icon-notifi")),
        ]
    }
    
    class func fetchDataForAdmin() -> [Profile] {
        return [
            Profile(title: NSLocalizedString("Account Details", comment: "Profile.swift: Account Details"), image: UIImage(named: "icon-acc")),
            Profile(title: NSLocalizedString("Members", comment: "Profile.swift: Members"), image: UIImage(named: "icon-member")),
            Profile(title: NSLocalizedString("Settings", comment: "Profile.swift: Settings"), image: UIImage(named: "icon-settings")),
            Profile(title: NSLocalizedString("Contact Us", comment: "Profile.swift: Contact Us"), image: UIImage(named: "icon-contact")),
            Profile(title: NSLocalizedString("Clear Watch History", comment: "Profile.swift: Clear Watch History"), image: UIImage(named: "icon-watchHistory")),
            Profile(title: NSLocalizedString("Clear Search History", comment: "Profile.swift: Clear Search History"), image: UIImage(named: "icon-searchHistory")),
            //Make a new chat icon
            Profile(title: NSLocalizedString("Chats", comment: "Profile.swift: Chat"), image: UIImage(named: "icon-searchHistory")),
            Profile(title: NSLocalizedString("Notifications", comment: "Profile.swift: Notifications"), image: UIImage(named: "icon-notifi")),
        ]
    }
}
