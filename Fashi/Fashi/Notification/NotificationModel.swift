//
//  NotificationModel.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import Firebase

struct NotificationModel {
    var uid: String = ""
    let title: String
    let body: String
    let prUID: String
    let type: String
    var colorKey: String?
    var sizeKey: String?
}

class NotificationFB {
    
    private var model: NotificationModel
    
    init(model: NotificationModel) {
        self.model = model
    }
    
    var uid: String { return model.uid }
    var title: String { return model.title }
    var body: String { return model.body }
    var prUID: String { return model.prUID }
    var type: String { return model.type }
    var colorKey: String? { return model.colorKey }
    var sizeKey: String? { return model.sizeKey }
}

extension NotificationFB {
    
    convenience init(dictionary: [String: Any]) {
        let uid = dictionary["uid"] as! String
        let title = dictionary["title"] as! String
        let body = dictionary["body"] as! String
        let prUID = dictionary["prUID"] as! String
        let type = dictionary["type"] as! String
        let colorKey = dictionary["colorKey"] as? String
        let sizeKey = dictionary["sizeKey"] as? String
        let model = NotificationModel(uid: uid, title: title, body: body, prUID: prUID, type: type, colorKey: colorKey, sizeKey: sizeKey)
        self.init(model: model)
    }
}

//MARK: - Save

extension NotificationFB {
    
    func saveNotification(completion: @escaping () -> Void) {
        model.uid = createTime()
        let ref = DatabaseRef.notificationFB(uid: uid).ref()
        ref.setValue(toDictionary())
        completion()
    }
    
    private func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "title": title,
            "body": body,
            "prUID": prUID,
            "type": type,
            "colorKey": colorKey as Any,
            "sizeKey": sizeKey as Any
        ]
    }
}

//MARK: - Fetch

extension NotificationFB {
    
    class func fetchNotiFB(uid: String, completion: @escaping (NotificationFB) -> Void) {
        let ref = DatabaseRef.notificationFB(uid: uid).ref()
        ref.observe(.value) { (snapshot) in
            guard snapshot.exists() else { return }
            
            if let dict = snapshot.value as? [String: Any] {
                let notifFB = NotificationFB(dictionary: dict)
                DispatchQueue.main.async {
                    completion(notifFB)
                }
            }
        }
    }
}

//MARK: - Equatable

extension NotificationFB: Equatable {}
func ==(lhs: NotificationFB, rhs: NotificationFB) -> Bool {
    return lhs.uid == rhs.uid
}
