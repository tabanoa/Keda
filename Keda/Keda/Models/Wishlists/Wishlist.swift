//
//  Wishlist.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class Wishlist {
    
    var prUID: String
    
    init(prUID: String) {
        self.prUID = prUID
    }
}

//TODO: - Save

extension Wishlist {
    
    func saveWishlist(completion: @escaping () -> Void) {
        let toDictionary: [String: Any] = [prUID: true]
        let ref = DatabaseRef.wishlist.ref().child(currentUID)
        ref.updateChildValues(toDictionary)
        completion()
    }
    
    func removeWishlist(completion: @escaping () -> Void) {
        let ref = DatabaseRef.wishlist.ref().child(currentUID).child(prUID)
        ref.removeValue()
        completion()
    }
}

//TODO: - Fetch

extension Wishlist {
    
    class func fetchProductsUID(completion: @escaping ([String]) -> Void) {
        var prUIDs: [String] = []
        let ref = DatabaseRef.wishlist.ref()
        ref.observe(.childAdded) { (snapshot) in
            if snapshot.key == currentUID {
                if let dict = snapshot.value as? [String: Any] {
                    for (key, _) in dict {
                        if !prUIDs.contains(key) {
                            prUIDs.append(key)
                            completion(prUIDs)
                        }
                    }
                }
                
            } else {
                completion([])
            }
        }
    }
    
    class func fetchPrFromWishlist(userUID: String = currentUID, completion: @escaping ([Product]) -> Void) {
        var products: [Product] = []
        let ref = DatabaseRef.wishlist.ref().child(userUID)
        ref.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                for (key, _) in dict {
                    let ref = DatabaseRef.product(uid: key).ref()
                    ref.observe(.value) { (snapshot) in
                        guard let dictPr = snapshot.value as? [String: Any] else { return }
                        let uid = dictPr["uid"] as! String
                        let createdTime = dictPr["createdTime"] as! String
                        let type = dictPr["type"] as! String
                        let tags = dictPr["tags"] as! [String]

                        var prColors: [ProductColor] = []
                        
                        if let dictColor = dictPr["colors"] as? [String: Any] {
                            for (color, value) in dictColor {
                                var prSizes: [ProductSize] = []
                                
                                if let dict = value as? [String: Any] {
                                    if let dictSize = dict["sizes"] as? [String: Any] {
                                        for (size, value) in dictSize {
                                            if let dict = value as? [String: Any] {
                                                let prInfoModel = ProductInfoModel(dictionary: dict)
                                                let prSize = ProductSize(size: size, prInfoModel: prInfoModel)
                                                if !prSizes.contains(prSize) {
                                                    prSizes.append(prSize)
                                                    prSizes.sort(by: { $0.size < $1.size })
                                                }
                                            }
                                        }
                                    }
                                }

                                let prColor = ProductColor(color: color, prSizes: prSizes)
                                if !prColors.contains(prColor) {
                                    prColors.append(prColor)
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            let prModel = ProModel(uid: uid, createdTime: createdTime, prColors: prColors, type: type, tags: tags)
                            let pro = Product(prModel: prModel)
                            if !products.contains(pro) {
                                products.append(pro)
                                completion(products)
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


//TODO: - Equatable

extension Wishlist: Equatable {}
func ==(lhs: Wishlist, rhs: Wishlist) -> Bool {
    return lhs.prUID == rhs.prUID
}
