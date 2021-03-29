//
//  PrRating.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import Firebase

class PrRating {
    
    var prUID: String
    
    var ratings: [String] = []
    var ratings1: [String] = []
    var ratings2: [String] = []
    var ratings3: [String] = []
    var ratings4: [String] = []
    var ratings5: [String] = []
    
    init(prUID: String) {
        self.prUID = prUID
    }
}

//MARK: - Convenience

extension PrRating {
    
    convenience init(prUID: String, dictionary: [String: Any]) {
        self.init(prUID: prUID)
        ratings1 = getRating(value: 1, dictionary: dictionary)
        ratings2 = getRating(value: 2, dictionary: dictionary)
        ratings3 = getRating(value: 3, dictionary: dictionary)
        ratings4 = getRating(value: 4, dictionary: dictionary)
        ratings5 = getRating(value: 5, dictionary: dictionary)
        
        for (_, value) in dictionary {
            if let dict = value as? [String: Any] {
                for (key, _) in dict {
                    if !ratings.contains(key) { ratings.append(key) }
                }
            }
        }
    }
    
    private func getRating(value: Int, dictionary: [String: Any]) -> [String] {
        var ratings: [String] = []
        if let raDict = dictionary["rating\(value)"] as? [String: Any] {
            for (key, _) in raDict {
                if !ratings.contains(key) { ratings.append(key) }
            }
        }
        
        return ratings
    }
}

//MARK: - Save

extension PrRating {
    
    func saveRating(_ value: Int, userUID: String = currentUID, completion: @escaping () -> Void) {
        let ref = DatabaseRef.rating(uid: prUID).ref().child("rating\(value)")
        ref.updateChildValues([userUID: true])
    }
    
    func calculateAverage(completion: @escaping (Int, Int, Int, Int, Int, Int, Double) -> Void) {
        let r1 = ratings1.count
        let r2 = ratings2.count
        let r3 = ratings3.count
        let r4 = ratings4.count
        let r5 = ratings5.count
        let total = [r1, r2, r3, r4, r5].reduce(0, +)
        let sum = Double([r1*1, r2*2, r3*3, r4*4, r5*5].reduce(0, +))
        let average = total != 0 ? (sum/Double(total)) : 0
        guard !average.isNaN else { return }
        completion(r1, r2, r3, r4, r5, total, average)
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
}

//MARK: - Fetch

extension PrRating {
    
    class func fetchRatings(prUID: String, completion: @escaping (PrRating) -> Void) {
        let ref = DatabaseRef.rating(uid: prUID).ref()
        ref.observe(.value) { (snapshot) in
            guard snapshot.exists() else { return }
            
            if let dict = snapshot.value as? [String: Any] {
                let prRating = PrRating(prUID: snapshot.key, dictionary: dict)
                DispatchQueue.main.async {
                    completion(prRating)
                }
            }
        }
    }
    
    class func fillterPrUIDFromRating(selectRating: Int, completion: @escaping ([String]) -> Void) {
        var prsUID: [String] = []
        let ref = Database.database().reference(withPath: "Rating")
        ref.observe(.childAdded) { (snapshot) in
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

//MARK: - Equatable

extension PrRating: Equatable {}
func ==(lhs: PrRating, rhs: PrRating) -> Bool {
    return lhs.prUID == rhs.prUID
}
