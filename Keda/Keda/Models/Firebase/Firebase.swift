//
//  Firebase.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Firebase

enum DatabaseRef {
    case product(uid: String)
    case user(uid: String)
    case wishlist
    case histories(uid: String)
    case rating(uid: String)
    case review(uid: String)
    case views(uid: String)
    case purchased(uid: String)
    case notificationFB(uid: String)
    case notificationUser(uid: String)
    
    func ref() -> DatabaseReference {
        return rootRef().child(path)
    }
    
    private func  rootRef() -> DatabaseReference {
        return Database.database().reference()
    }
    
    private var path: String {
        switch self {
        case .product(let uid): return "Product/\(uid)"
        case .user(let uid): return "User/\(uid)"
        case .wishlist: return "Wishlist"
        case .histories(let uid): return "Histories/\(uid)"
        case .rating(let uid): return "Rating/\(uid)"
        case .review(let uid): return "Review/\(uid)"
        case .views(let uid): return "Views/\(uid)"
        case .purchased(let uid): return "Purchased/\(uid)"
        case .notificationFB(let uid): return "NotificationFB/\(uid)"
        case .notificationUser(let uid): return "NotificationUser/\(uid)"
        }
    }
}
