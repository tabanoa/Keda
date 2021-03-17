//
//  User.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import Firebase
import SDWebImage

struct UserModel: Codable {
    let uid: String
    let email: String
    let fullName: String
    let phoneNumber: String
    let avatarLink: String?
    var followers: [String] = []
    var followings: [String] = []
    let type: String
    var orderDate: String = ""
    
    enum CodingKeys: String, CodingKey {
        case uid
        case email
        case fullName
        case phoneNumber
        case avatarLink
        case followers
        case followings
        case type
    }
}

extension UserModel {
    
    init(dictionary: [String: Any]) {
        let uid = dictionary["uid"] as! String
        let email = dictionary["email"] as! String
        let fullName = dictionary["fullName"] as! String
        let phoneNumber = dictionary["phoneNumber"] as! String
        let avatarLink = dictionary["avatarLink"] as? String
        let type = dictionary["type"] as! String
        
        var followers: [String] = []
        if let dict = dictionary["followers"] as? [String: Any] {
            for (key, _) in dict {
                followers.append(key)
            }
        }
        
        var followings: [String] = []
        if let dict = dictionary["followings"] as? [String: Any] {
            for (key, _) in dict {
                followings.append(key)
            }
        }
        
        self.init(uid: uid, email: email, fullName: fullName, phoneNumber: phoneNumber, avatarLink: avatarLink, followers: followers, followings: followings, type: type)
    }
}

class User {
    
    var userModel: UserModel
    
    init(userModel: UserModel) {
        self.userModel = userModel
    }
    
    var uid: String { return userModel.uid }
    var email: String { return userModel.email }
    var fullName: String { return userModel.fullName }
    var phoneNumber: String { return userModel.phoneNumber }
    var avatarLink: String? { return userModel.avatarLink }
    var followers: [String] { return userModel.followers }
    var followings: [String] { return userModel.followings }
    var type: String { return userModel.type }
    var orderDate: String { return userModel.orderDate }
}

//MARK: - SaveUser

extension User {
    
    func saveUser(completion: @escaping () -> Void) {
        let ref = DatabaseRef.user(uid: uid).ref()
        ref.setValue(toDictinary())
        completion()
    }
    
    func toDictinary() -> [String: Any] {
        return [
            "uid": uid,
            "email": email,
            "fullName": fullName,
            "phoneNumber": phoneNumber,
            "avatarLink": avatarLink as Any,
            "followers": [],
            "followings": [],
            "type": type
        ]
    }
    
    func saveAvatar(_ link: String) {
        let ref = DatabaseRef.user(uid: uid).ref()
        ref.updateChildValues(["avatarLink": link])
    }
}

//MARK: - CheckOnline

extension User {
    
    class func connected() {
        let refOnline = DatabaseRef.user(uid: currentUID).ref().child("connection/\(deviceUID)/online")
        refOnline.onDisconnectRemoveValue()
        refOnline.setValue(true)
        
        let refLastTime = DatabaseRef.user(uid: currentUID).ref().child("lastTime")
        refLastTime.setValue(createTime())
        
        refOnline.observe(.value) { (snapshot) in
            guard let connect = snapshot.value as? Bool, connect else { return }
        }
    }
    
    class func disconnected() {
        let refOnline = DatabaseRef.user(uid: currentUID).ref().child("connection/\(deviceUID)")
        refOnline.setValue(["online": false])
        
        let refLastTime = DatabaseRef.user(uid: currentUID).ref().child("lastTime")
        refLastTime.setValue(createTime())
    }
}

//MARK: - FetchUser

extension User {
    
    class func fetchUserFromUID(uid: String = currentUID, completion: @escaping (User) -> Void) {
        let ref = DatabaseRef.user(uid: uid).ref()
        ref.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let model = UserModel(dictionary: dict)
                let user = User(userModel: model)
                completion(user)
            }
        }
    }
    
    class func fetchCurrentUser(completion: @escaping (User) -> Void) {
        let ref = DatabaseRef.user(uid: currentUID).ref()
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let model = UserModel(dictionary: dict)
                let user = User(userModel: model)
                completion(user)
            }
        }
    }
    
    class func fetchAllUsers(completion: @escaping ([User]) -> Void) {
        var users: [User] = []
        let ref = Database.database().reference().child("User")
        ref.observe(.childAdded) { (snapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                let model = UserModel(dictionary: dict)
                let user = User(userModel: model)
                guard !user.type.contains("admin") else { return }
                
                if !users.contains(user) {
                    users.append(user)
                    DispatchQueue.main.async {
                        completion(users)
                    }
                }
            }
        }
    }
    
    func downloadAvatar(link: String, completion: @escaping (UIImage) -> Void) {
        let url = URL(string: link)
        SDWebImageManager.shared.loadImage(
            with: url,
            options: .continueInBackground,
            progress: nil) { (image, data, error, cacheType, finished, url) in
                guard error == nil, let image = image else { return }
                completion(image)
        }
    }
    
    func fetchOnlineTime(completion: @escaping (String, UIColor?) -> Void) {
        let ref = Database.database().reference(withPath: "User/\(uid)")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else { completion("", nil); return }
            
            if let dict = snapshot.value as? [String: Any] {
                guard let lastTime = dict["lastTime"] as? String else { completion("", nil); return }
                var online = ""
                var color: UIColor = .clear
                
                if dict["connection"] == nil {
                    color = UIColor(hex: 0xF33D30)
                    setupOnlineFor(time: lastTime, completion: { (text) in online = text })

                } else if let connection = dict["connection"] as? [String : Any] {
                    for (_, dict) in connection {
                        if let dict = dict as? [String : Any] {
                            if dict["online"] as? Bool ?? false {
                                color = UIColor(hex: 0x34c749)
                                online = NSLocalizedString("Online", comment: "User.swift Online")

                            } else {
                                color = UIColor(hex: 0xfdbc40)
                                setupOnlineFor(time: lastTime, completion: { (text) in online = text })
                            }
                        }
                    }
                }
                
                completion(online, color)
            }
        }
    }
}

//MARK: - Equatable

extension User: Equatable {}
func ==(lhs: User, rhs: User) -> Bool {
    return lhs.uid == rhs.uid
}
