//
//  Buyed.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

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
    
    func saveBuyed(prUID: String) {
        let uid = Database.database().reference().childByAutoId().key!
        let ref = DatabaseRef.buyed(uid: prUID).ref()
        ref.runTransactionBlock { (mutableData) -> TransactionResult in
            var dict = mutableData.value as? [String: Any] ?? [:]
            var buyedDict = dict["buyed"] as? [String: Any] ?? [:]
            buyedDict[uid] = 1
            
            var count = 0
            var j = 0
            for (_, value) in buyedDict {
                if let i = value as? Int {
                    j += i
                }
            }
            
            count = j
            dict["count"] = count
            dict["buyed"] = buyedDict
            dict["prUID"] = prUID
            mutableData.value = dict
            
            return TransactionResult.success(withValue: mutableData)
        }
    }
}

//MARK: - Fetch

extension Buyed {
    
    class func fetchBuyed(prUID: String, completion: @escaping (Buyed?) -> Void) {
        let ref = Database.database().reference(withPath: "Buyede")
        ref.observe(.value) { (snapshot) in
            guard snapshot.exists() else { completion(nil); return }

            let refP = ref.child(prUID)
            refP.observe(.value) { (snapshot) in
                guard snapshot.exists() else { completion(nil); return }

                if let dict = snapshot.value as? [String: Any] {
                    let buyed = Buyed(dictionary: dict)
                    completion(buyed)
                }
            }
        }
    }
}
