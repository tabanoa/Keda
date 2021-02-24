//
//  MatchObject.swift
//  Keda Profile
//
//  Created by Matthew Mukherjee on 12/22/2020.

import Foundation


struct MatchObject {
    
    let id: String
    let memberIds: [String]
    let date: Date
    
    var dictionary: [String : Any] {
        return [kOBJECTID : id, kMEMBERIDS : memberIds, kDATE : date]
    }
    
    func saveToFireStore() {
        
        FirebaseReference(.Match).document(self.id).setData(self.dictionary)
    }
}
