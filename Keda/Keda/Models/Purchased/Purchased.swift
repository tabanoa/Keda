//
//  Purchased.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import Firebase

class Purchased {
    
    var prUID: String = ""
    var count = 0
    
    init() {}
}

extension Purchased {
    
    convenience init(dictionary: [String: Any]) {
        self.init()
        self.prUID = dictionary["prUID"] as! String
        self.count = dictionary["count"] as! Int
    }
}

//MARK: - Save

extension Purchased {
    
    func savePurchased(prUID: String) {
        let uid = Database.database().reference().childByAutoId().key!
        let ref = DatabaseRef.purchased(uid: prUID).ref()
        ref.runTransactionBlock { (mutableData) -> TransactionResult in
            var dict = mutableData.value as? [String: Any] ?? [:]
            var purchasedDict = dict["purchased"] as? [String: Any] ?? [:]
            purchasedDict[uid] = 1
            
            var count = 0
            var j = 0
            for (_, value) in purchasedDict {
                if let i = value as? Int {
                    j += i
                }
            }
            
            count = j
            dict["count"] = count
            dict["purchased"] = purchasedDict
            dict["prUID"] = prUID
            mutableData.value = dict
            
            return TransactionResult.success(withValue: mutableData)
        }
    }
}

//MARK: - Fetch

extension Purchased {
    
    class func fetchPurchased(prUID: String, completion: @escaping (Purchased?) -> Void) {
        let ref = Database.database().reference(withPath: "Purchasede")
        ref.observe(.value) { (snapshot) in
            guard snapshot.exists() else { completion(nil); return }

            let refP = ref.child(prUID)
            refP.observe(.value) { (snapshot) in
                guard snapshot.exists() else { completion(nil); return }

                if let dict = snapshot.value as? [String: Any] {
                    let purchased = Purchased(dictionary: dict)
                    completion(purchased)
                }
            }
        }
    }
}
