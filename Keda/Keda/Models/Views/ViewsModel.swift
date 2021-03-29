//
//  ViewsModel.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import Firebase

class ViewsModel {
    
    var prUID: String = ""
    var count = 0
    
    init() {}
}

extension ViewsModel {
    
    convenience init(dictionary: [String: Any]) {
        self.init()
        self.prUID = dictionary["prUID"] as! String
        self.count = dictionary["count"] as! Int
    }
}

//MARK: - Save

extension ViewsModel {
    
    func saveViews(prUID: String) {
        let uid = Database.database().reference().childByAutoId().key!
        let ref = DatabaseRef.views(uid: prUID).ref()
        ref.runTransactionBlock { (mutableData) -> TransactionResult in
            var dict = mutableData.value as? [String: Any] ?? [:]
            var viewDict = dict["views"] as? [String: Any] ?? [:]
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
            dict["views"] = viewDict
            dict["prUID"] = prUID
            mutableData.value = dict
            
            return TransactionResult.success(withValue: mutableData)
        }
    }
}

//MARK: - Fetch

extension ViewsModel {
    
    class func fetchViews(prUID: String, completion: @escaping (ViewsModel?) -> Void) {
        let ref = Database.database().reference(withPath: "Views")
        ref.observe(.value) { (snapshot) in
            guard snapshot.exists() else { completion(nil); return }

            let refP = ref.child(prUID)
            refP.observe(.value) { (snapshot) in
                guard snapshot.exists() else { completion(nil); return }

                if let dict = snapshot.value as? [String: Any] {
                    let viewsModel = ViewsModel(dictionary: dict)
                    completion(viewsModel)
                }
            }
        }
    }
}
