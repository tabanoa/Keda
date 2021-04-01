//
//  ProductInfo.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Firebase

//MARK: - ProductInfo

struct ProductInfoModel: Codable {
    let name: String
    let price: Double
    let saleOff: Double
    var imageLinks: [String]
    let description: String
    var images: [UIImage] = []
    
    enum CodingKeys: String, CodingKey {
        case name
        case price
        case saleOff
        case imageLinks
        case description
    }
}

extension ProductInfoModel {
    
    init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String
        let price = dictionary["price"] as! Double
        let saleOff = dictionary["saleOff"] as! Double
        let imageLinks = (dictionary["imageLinks"] as? [String]) ?? []
        let description = dictionary["description"] as! String
        self.init(name: name, price: price, saleOff: saleOff, imageLinks: imageLinks, description: description)
    }
}

class ProductSize {
    
    var size: String
    var prInfoModel: ProductInfoModel
    
    init(size: String, prInfoModel: ProductInfoModel) {
        self.size = size
        self.prInfoModel = prInfoModel
    }
    
    class func fetchProductSize(prUID: String, colorUID: String, completion: @escaping (ProductSize) -> Void) {
        let ref = DatabaseRef.product(uid: prUID).ref().child("colors/\(colorUID)/sizes")
        ref.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let info = ProductInfoModel(dictionary: dict)
                let prSize = ProductSize(size: snapshot.key, prInfoModel: info)
                completion(prSize)
            }
        }
    }
    
    class func saveImageLinks(prUID: String, color: String, size: String, imgLinks: [String], completion: @escaping () -> Void) {
        let ref = DatabaseRef.product(uid: prUID).ref().child("colors/\(color)/sizes/\(size)")
        ref.updateChildValues(["imageLinks": imgLinks])
        completion()
    }
}

extension ProductSize: Equatable {}
func ==(lhs: ProductSize, rhs: ProductSize) -> Bool {
    return lhs.size == rhs.size
}

//MARK: - ProductColor

class ProductColor {
    
    var color: String
    var prSizes: [ProductSize]
    
    init(color: String, prSizes: [ProductSize]) {
        self.color = color
        self.prSizes = prSizes
    }
    
    class func fetchProductColor(prUID: String, completion: @escaping (ProductColor) -> Void) {
        let ref = DatabaseRef.product(uid: prUID).ref().child("colors")
        ref.observe(.childAdded) { (snapshot) in
            ProductSize.fetchProductSize(prUID: prUID, colorUID: snapshot.key) { (prSize) in
                var prSizes: [ProductSize] = []
                
                if !prSizes.contains(prSize) {
                    prSizes.append(prSize)
                    
                    let prColor = ProductColor(color: snapshot.key, prSizes: prSizes)
                    completion(prColor)
                }
            }
        }
    }
}

extension ProductColor: Equatable {}
func ==(lhs: ProductColor, rhs: ProductColor) -> Bool {
    return lhs.color == rhs.color
}
