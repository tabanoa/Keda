//
//  Seller.swift
//  Fashi
//
//  Created by Jack Ily on 11/05/2020.
//  Copyright © 2020 Jack Ily. All rights reserved.
//

import Foundation
import Firebase

class Buyed {
    
    var prUID: String = ""
    var count = 0
    
    init() {}
}

extension Buyed {
    
    convenience init(dictionary: [String: Any]) {
        self.init()
        self.prUID = dictionary["prUID"] as! String
        self.count = dictionary["count"] as! Int
    }
}

//MARK: - Save

extension Buyed {
    
    func saveViews(prUID: String) {
        let uid = Database.database().reference().childByAutoId().key!
        let ref = DatabaseRef.sells(uid: prUID).ref()
        ref.runTransactionBlock { (mutableData) -> TransactionResult in
            var dict = mutableData.value as? [String: Any] ?? [:]
            var viewDict = dict["sells"] as? [String: Any] ?? [:]
            viewDict[uid] = 1
            
            var count = 0
            
            var j = 0
            for (_, value) in viewDict {
                if let i = value as? Int {
                    j += i
                }
            }
            
            count = j
            dict["count"] = count
            dict["sell"] = viewDict
            dict["prUID"] = prUID
            mutableData.value = dict
            
            return TransactionResult.success(withValue: mutableData)
        }
    }
}

//MARK: - Fetch

extension Buyed {
    
    class func fetchViews(prUID: String, completion: @escaping (Buyed) -> Void) {
        let ref = DatabaseRef.views(uid: prUID).ref()
        ref.observe(.value) { (snapshot) in
            guard snapshot.exists() else { return }
            
            if let dict = snapshot.value as? [String: Any] {
                let seller = Buyed(dictionary: dict)
                completion(seller)
            }
        }
    }
}
