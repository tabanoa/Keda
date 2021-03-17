//
//  ProductCart.swift
//  Fashi
//
//  Created by Jack Ily on 20/04/2020.
//  Copyright © 2020 Jack Ily. All rights reserved.
//

import UIKit
import Firebase

struct ProductCartModel {
    let prUID: String
    let name: String
    let imageLinks: [String]
    let price: Double
    let saleOff: Double
    var quantity: Int
    let selectColor: String
    let selectSize: String
}

class ProductCart: Hashable {
    
    private let model: ProductCartModel
    
    init(model: ProductCartModel) {
        self.model = model
    }
    
    var prUID: String { return model.prUID }
    var name: String { return model.name }
    var imageLinks: [String] { return model.imageLinks }
    var price: Double { return model.price }
    var saleOff: Double { return model.saleOff }
    var quantity: Int { return model.quantity }
    var selectColor: String { return model.selectColor }
    var selectSize: String { return model.selectSize }
    var imageLink: String { return imageLinks.first! }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(prUID)
    }
}

extension ProductCart {
    
}

//MARK: - Fetch

extension ProductCart {
    
    
}

extension ProductCart: Equatable {}
func ==(lhs: ProductCart, rhs: ProductCart) -> Bool {
    return lhs.prUID == rhs.prUID
}
