//
//  Message.swift
//  Keda
//
//  Created by Laptop on 2021-03-24.
//  Copyright © 2021 Keda Team. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromId: String?
    var timestamp: NSNumber?
    var text: String?
    var toId: String?
    
    func chatPartnerId() -> String? {
        if self.fromId == Auth.auth().currentUser?.uid {
            return toId
        } else {
            return fromId
        }
    }
}
