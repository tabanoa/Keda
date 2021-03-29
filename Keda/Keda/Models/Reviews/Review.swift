//
//  Review.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import Firebase

struct ReviewModel {
    var uid: String = ""
    var userUID: String
    let description: String?
    let imageLinks: [String]
    var createdTime: String = ""
    let type: String
    var show: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case uid
        case userUID
        case description
        case imageLinks
        case createdTime
        case type
        case show
    }
}

class Review {
    
    private var model: ReviewModel
    
    init(model: ReviewModel) {
        self.model = model
    }
    
    var uid: String { return model.uid }
    var userUID: String { return model.userUID }
    var description: String? { return model.description }
    var imageLinks: [String] { return model.imageLinks }
    var createdTime: String { return model.createdTime }
    var type: String { return model.type }
    var show: Bool { return model.show }
}

//MARK: - Convenience

extension Review {
    
    convenience init(dictionary: [String: Any]) {
        var imageLinks: [String] = []
        if let arr = dictionary["imageLinks"] as? [String] {
            imageLinks = arr
        }
        
        let uid = dictionary["uid"] as! String
        let userUID = dictionary["userUID"] as! String
        let description = dictionary["description"] as? String
        let createdTime = dictionary["createdTime"] as! String
        let type = dictionary["type"] as! String
        let show = dictionary["show"] as! Bool
        let model = ReviewModel(uid: uid, userUID: userUID, description: description, imageLinks: imageLinks, createdTime: createdTime, type: type, show: show)
        self.init(model: model)
    }
}

//MARK: - Save

extension Review {
    
    func saveReview(prUID: String, completion: @escaping () -> Void) {
        model.uid = Database.database().reference().childByAutoId().key!
        model.userUID = currentUID
        let ref = DatabaseRef.review(uid: prUID).ref().child(userUID).child(model.uid)
        ref.setValue(toDictionary())
        completion()
    }
    
    class func saveImageLinks(prUID: String, rUID: String, imageLinks: [String], completion: @escaping () -> Void) {
        let toDict: [String: Any] = [
            "imageLinks": imageLinks,
            "show": true
        ]
        
        let ref = DatabaseRef.review(uid: prUID).ref().child(currentUID).child(rUID)
        ref.updateChildValues(toDict)
        completion()
    }
    
    func toDictionary() -> [String: Any] {
        model.createdTime = createTime()
        
        return [
            "uid": uid,
            "userUID": userUID,
            "description": description as Any,
            "imageLinks": imageLinks,
            "createdTime": createdTime,
            "type": type,
            "show": show
        ]
    }
}

//MARK: - Fetch

extension Review {
    
    class func fetchReviews(prUID: String, completion: @escaping ([Review]) -> Void) {
        var reviews: [Review] = []
        let ref = DatabaseRef.review(uid: prUID).ref()
        ref.observe(.childAdded) { (snapshot) in
            guard snapshot.exists() else { completion([]); return }
            
            if let d1 = snapshot.value as? [String: Any] {
                for (_, value) in d1 {
                    if let d2 = value as? [String: Any] {
                        let review = Review(dictionary: d2)
                        if !reviews.contains(review) {
                            reviews.append(review)
                            DispatchQueue.main.async {
                                completion(reviews)
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: - Equatable

extension Review: Equatable {}
func ==(lhs: Review, rhs: Review) -> Bool {
    return lhs.uid == rhs.uid
}
