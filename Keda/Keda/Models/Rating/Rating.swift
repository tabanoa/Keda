//
//  Rating.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import Firebase

class Rating {
    
    var prUID: String = ""
    
    var ratings: [String] = []
    var ratings1: [String] = []
    var ratings2: [String] = []
    var ratings3: [String] = []
    var ratings4: [String] = []
    var ratings5: [String] = []
    
    var rating1: Int = 0
    var rating2: Int = 0
    var rating3: Int = 0
    var rating4: Int = 0
    var rating5: Int = 0
    
    init() {}
}

extension Rating {
    
    convenience init(dictionary: [String: Any]) {
        self.init()
        getRating(1, dict: dictionary, prUID: &prUID, count: &rating1, ratings: &ratings1)
        getRating(2, dict: dictionary, prUID: &prUID, count: &rating2, ratings: &ratings2)
        getRating(3, dict: dictionary, prUID: &prUID, count: &rating3, ratings: &ratings3)
        getRating(4, dict: dictionary, prUID: &prUID, count: &rating4, ratings: &ratings4)
        getRating(5, dict: dictionary, prUID: &prUID, count: &rating5, ratings: &ratings5)
        
        for (_, value) in dictionary {
            if let dict = value as? [String: Any], let rDict = dict["ratings"] as? [String: Any] {
                for (key, _) in rDict {
                    if !ratings.contains(key) {
                        ratings.append(key)
                    }
                }
            }
        }
    }
    
    private func getRating(_ value: Int, dict: [String: Any], prUID: inout String, count: inout Int, ratings: inout [String]) {
        if let ratingDict = dict["rating\(value)"] as? [String: Any] {
            prUID = ratingDict["prUID"] as! String
            count = ratingDict["count"] as! Int
            
            if let rDict = ratingDict["ratings"] as? [String: Any] {
                for (key, _) in rDict {
                    if !ratings.contains(key) {
                        ratings.append(key)
                    }
                }
            }
        }
    }
}

//MARK: - Save

extension Rating {
    
    func saveRating(_ prUID: String, _ value: Int, _ userUID: String = currentUID) {
        let ref = DatabaseRef.rating(uid: prUID).ref().child("rating\(value)")
        ref.runTransactionBlock { (mutableData) -> TransactionResult in
            var dict = mutableData.value as? [String: Any] ?? [:]
            var rating = dict["ratings"] as? [String: Any] ?? [:]
            rating[userUID] = 1
            
            var count = 0
            var j = 0
            for (_, value) in rating {
                if let i = value as? Int {
                    j += i
                }
            }
            
            count = j
            dict["count"] = count
            dict["ratings"] = rating
            dict["prUID"] = prUID
            mutableData.value = dict
            
            return TransactionResult.success(withValue: mutableData)
        }
    }
    
    func containerUserUID(_ userUID: String = currentUID) -> Int {
        switch true {
        case ratings1.contains(userUID): return 1
        case ratings2.contains(userUID): return 2
        case ratings3.contains(userUID): return 3
        case ratings4.contains(userUID): return 4
        case ratings5.contains(userUID): return 5
        default: return 0
        }
    }
    
    func calculateAverage(completion: @escaping (Int, Int, Int, Int, Int, Int, Double) -> Void) {
        let total = [rating1, rating2, rating3, rating4, rating5].reduce(0, +)
        let sum = Double([rating1*1, rating2*2, rating3*3, rating4*4, rating5*5].reduce(0, +))
        let average = total != 0 ? (sum/Double(total)) : 0
        guard !average.isNaN else { return }
        completion(rating1, rating2, rating3, rating4, rating5, total, average)
    }
}

//MARK: - Fetch

extension Rating {
    
    class func fetchRatings(prUID: String, completion: @escaping (Rating?) -> Void) {
        let ref = DatabaseRef.rating(uid: prUID).ref()
        ref.observe(.value) { (snapshot) in
            guard snapshot.exists() else { completion(nil); return }
            
            if let dict = snapshot.value as? [String: Any] {
                let rating = Rating(dictionary: dict)
                DispatchQueue.main.async {
                    completion(rating)
                }
            }
        }
    }
    
    class func fillterPrUIDFromRating(selectRating: Int, completion: @escaping ([String]) -> Void) {
        var prsUID: [String] = []
        let ref = Database.database().reference(withPath: "Rating")
        ref.observe(.value) { (snapshot) in
            guard snapshot.exists() else { completion([]); return }
            
            ref.observe(.childAdded) { (snapshot) in
                guard snapshot.exists() else { completion([]); return }
                let prUID = snapshot.key
                
                if let dict = snapshot.value as? [String: Any] {
                    if let _ = dict["rating\(selectRating)"] as? [String: Any] {
                        if !prsUID.contains(prUID) {
                            prsUID.append(prUID)
                            DispatchQueue.main.async {
                                completion(prsUID)
                            }
                        }
                    }
                }
            }
        }
    }
}
