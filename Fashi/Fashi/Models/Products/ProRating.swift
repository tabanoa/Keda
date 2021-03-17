//
//  ProductRating.swift
//  Fashi
//
//  Created by Jack Ily on 06/05/2020.
//  Copyright © 2020 Jack Ily. All rights reserved.
//

import Firebase

class ProductRating {
    
    var prUID: String
    var average: Int
    
    init(prUID: String, average: Int) {
        self.prUID = prUID
        self.average = average
    }
}

extension ProductRating: Equatable {}
func ==(lhs: ProductRating, rhs: ProductRating) -> Bool {
    return lhs.prUID == rhs.prUID
}

extension ProductRating {
    
    class func fetchProRating(completion: @escaping ([ProductRating]) -> Void) {
        var prRatings: [ProductRating] = []
        var ratings: [Rating] = []
        let ref = Database.database().reference()
        ref.observe(.childAdded) { (snapshot) in
            DispatchQueue.global(qos: .background).async {
                if snapshot.key == "Rating" {
                    if let d1 = snapshot.value as? [String: Any] {
                        for (prUID, value) in d1 {
                            if let d2 = value as? [String: Any] {
                                for (userUID, value) in d2 {
                                    if let r = value as? Int {
                                        let model = RatingModel(userUID: userUID, rating: r)
                                        let rating = Rating(model: model)
                                        if !ratings.contains(rating) {
                                            DispatchQueue.main.async {
                                                ratings.append(rating)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            var rating1 = 0
                            var rating2 = 0
                            var rating3 = 0
                            var rating4 = 0
                            var rating5 = 0
                            
                            var ratings1: [String] = []
                            var ratings2: [String] = []
                            var ratings3: [String] = []
                            var ratings4: [String] = []
                            var ratings5: [String] = []
                            
                            var total = 0
                            var average: Double = 0.0
                            
                            calculateRating(ratings,
                                            rating1: &rating1,
                                            rating2: &rating2,
                                            rating3: &rating3,
                                            rating4: &rating4,
                                            rating5: &rating5,
                                            ratings1: &ratings1,
                                            ratings2: &ratings2,
                                            ratings3: &ratings3,
                                            ratings4: &ratings4,
                                            ratings5: &ratings5,
                                            total: &total,
                                            average: &average)
                            
                            let prRating = ProductRating(prUID: prUID, average: Int(average))
                            if !prRatings.contains(prRating) {
                                prRatings.append(prRating)
                                DispatchQueue.main.async {
                                    completion(prRatings)
                                }
                            }
                        }
                    }
                    
                } else {
                    completion([])
                }
            }
        }
    }
}
