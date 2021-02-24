//
//  LikeObject.swift
//  Keda Profile
//
//  Created by Matthew Mukherjee on 12/22/2020.

import Foundation

struct LikeObject {
    
    let id: String
    let userId: String
    let likedUserId: String
    let date: Date
    
    var dictionary: [String : Any] {
        return [kOBJECTID : id, kUSERID : userId, kLIKEDUSERID : likedUserId, kDATE : date]
    }
    
    func saveToFireStore() {
        
        FirebaseReference(.Like).document(self.id).setData(self.dictionary)
    }
}
