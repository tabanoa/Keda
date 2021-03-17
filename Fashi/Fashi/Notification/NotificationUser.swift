//
//  NotificationUser.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import Firebase

struct NotificationUserModel {
    let notifUID: String
    var value: Int
}

//MARK: - Equatable

extension NotificationUserModel: Equatable {}
func ==(lhs: NotificationUserModel, rhs: NotificationUserModel) -> Bool {
    return lhs.notifUID == rhs.notifUID
}

class NotificationUser {
    
    var userUID: String = ""
    var models: [NotificationUserModel] = []
    var count = 0
    
    init() {}
}

//MARK: - Convenience

extension NotificationUser {
    
    convenience init(dictionary: [String: Any]) {
        self.init()
        self.userUID = dictionary["userUID"] as! String
        self.count = dictionary["count"] as! Int
        
        self.models = []
        if let dict = dictionary["notifications"] as? [String: Any] {
            for (key, value) in dict {
                if let v = value as? Int {
                    let model = NotificationUserModel(notifUID: key, value: v)
                    if !self.models.contains(model) {
                        self.models.append(model)
                    }
                }
            }
        }
    }
}

//MARK: - Save

extension NotificationUser {
    
    func saveNotificationUser(userUID: String, _ model: NotificationUserModel) {
        let ref = DatabaseRef.notificationUser(uid: userUID).ref()
        ref.runTransactionBlock { (mutableData) -> TransactionResult in
            var dict = mutableData.value as? [String: Any] ?? [:]
            var notifDict = dict["notifications"] as? [String: Any] ?? [:]
            notifDict[model.notifUID] = model.value
            
            var count = 0
            var j = 0
            for (_, value) in notifDict {
                if let i = value as? Int {
                    j += i
                }
            }
            
            count = j
            dict["count"] = count
            dict["userUID"] = userUID
            dict["notifications"] = notifDict
            mutableData.value = dict
            
            return TransactionResult.success(withValue: mutableData)
        }
    }
}

//MARK: - Fetch

extension NotificationUser {
    
    class func fetchNotifUIDFromUser(completion: @escaping (NotificationUser?) -> Void) {
        let ref = DatabaseRef.notificationUser(uid: currentUID).ref()
        ref.observe(.value) { (snapshot) in
            guard snapshot.exists() else { completion(nil); return }
            
            if let dict = snapshot.value as? [String: Any] {
                let notifU = NotificationUser(dictionary: dict)
                DispatchQueue.main.async {
                    completion(notifU)
                }
            }
        }
    }
}
