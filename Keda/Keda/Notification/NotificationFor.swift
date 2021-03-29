//
//  NotificationFor.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import Firebase

class NotificationFor {
    
    static let sharedInstance = NotificationFor()
    let dict: [String: Any] = [currentUID: true]
    let updatingOrders = "NotifUpdatingOrders"
    let newArrival = "NotifNewArrival"
    let promotion = "NotifPromotion"
    let saleOff = "NotifSaleOff"
    
    func addNotificationWith(child: String, completion: @escaping () -> Void) {
        let ref = Database.database().reference().child(child)
        ref.updateChildValues(dict)
        completion()
    }
    
    func addNotification() {
        let shared = NotificationFor.sharedInstance
        configureNotification { (state) in
            switch state {
            case .authorized:
                shared.addNotificationWith(child: shared.updatingOrders) {}
                shared.addNotificationWith(child: shared.newArrival) {}
                shared.addNotificationWith(child: shared.promotion) {}
                shared.addNotificationWith(child: shared.saleOff) {}
            default: break
            }
        }
    }
}

//MARK: - Fetch

extension NotificationFor {
    
    func fetchNotificationFrom(child: String, completion: @escaping ([String]) -> Void) {
        var userUIDs: [String] = []
        let ref = Database.database().reference().child(child)
        ref.observe(.childAdded) { (snapshot) in
            let key = snapshot.key
            if !userUIDs.contains(key) {
                userUIDs.append(key)
                DispatchQueue.main.async {
                    completion(userUIDs)
                }
            }
        }
    }
}

//MARK: - Remove

extension NotificationFor {
    
    func removeNotificationFrom(child: String, completion: @escaping () -> Void) {
        let ref = Database.database().reference().child(child).child(currentUID)
        ref.removeValue()
        completion()
    }
}
