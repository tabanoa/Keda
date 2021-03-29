//
//  ProductCart.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Firebase

struct ProductCartModel {
    let shopUID: String
    let prUID: String
    let name: String
    let imageLinks: [String]
    let price: Double
    let saleOff: Double
    var quantity: Int
    let selectColor: String
    let selectSize: String
    let createdTime: String
}

class ProductCart {
    
    private let model: ProductCartModel
    
    init(model: ProductCartModel) {
        self.model = model
    }
    
    var shopUID: String { return model.shopUID }
    var prUID: String { return model.prUID }
    var name: String { return model.name }
    var imageLinks: [String] { return model.imageLinks }
    var price: Double { return model.price }
    var saleOff: Double { return model.saleOff }
    var quantity: Int { return model.quantity }
    var selectColor: String { return model.selectColor }
    var selectSize: String { return model.selectSize }
    var imageLink: String { return imageLinks.first! }
    var createdTime: String { return model.createdTime }
}

extension ProductCart {
    
    convenience init(shopUID: String, dictionary: [String: Any]) {
        let prUID = dictionary["prUID"] as! String
        let name = dictionary["name"] as! String
        let imageLinks = dictionary["imageLinks"] as! [String]
        let price = dictionary["price"] as! Double
        let saleOff = dictionary["saleOff"] as! Double
        let quantity = dictionary["quantity"] as! Int
        let selectColor = dictionary["selectColor"] as! String
        let selectSize = dictionary["selectSize"] as! String
        let createdTime = dictionary["createdTime"] as! String
        let model = ProductCartModel(shopUID: shopUID, prUID: prUID,name: name, imageLinks: imageLinks, price: price, saleOff: saleOff, quantity: quantity, selectColor: selectColor, selectSize: selectSize, createdTime: createdTime)
        self.init(model: model)
    }
}

extension ProductCart: Equatable {}
func ==(lhs: ProductCart, rhs: ProductCart) -> Bool {
    return lhs.shopUID == rhs.shopUID
}
