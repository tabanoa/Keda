//
//  ShoppingCart.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import Firebase

class ShoppingCart {
    
    var productCarts: [ProductCart] = []
    var subtotal: Double = 0.0
    var fee: Double = 0.0
    var tax: Double = 0.0
    var total: Double = 0.0
    
    init() {}
    
    convenience init(dictionary: [String: Any]) {
        self.init()
        if let dict = dictionary["products"] as? [String: Any] {
            for (key, value) in dict {
                if let dict = value as? [String: Any] {
                    let prCart = ProductCart(shopUID: key, dictionary: dict)
                    self.productCarts.append(prCart)
                }
            }
        }
        
        self.subtotal = dictionary["subtotal"] as! Double
        self.fee = dictionary["fee"] as! Double
        self.tax = dictionary["tax"] as! Double
        self.total = dictionary["total"] as! Double
    }
}

//MARK: - Save

extension ShoppingCart {
    
    func addNewShoppingCart(_ pr: Product, _ selectColor: String, _ selectSize: String, completion: @escaping () -> Void) {
        let shopUID = Database.database().reference().childByAutoId().key!
        let toDict = toDictionary(shopUID,
                                  prUID: pr.uid,
                                  name: pr.name,
                                  imageLinks: pr.imageLinks,
                                  price: pr.price,
                                  saleOff: pr.saleOff,
                                  quantity: 1,
                                  selectColor: selectColor,
                                  selectSize: selectSize,
                                  createdTime: createTime())
        setupTransaction(uid: shopUID, toDictionary: toDict)
        completion()
    }
    
    func updateShoppingCart(prCart: ProductCart, isPrVC: Bool = true, quantity: Int = 1, completion: @escaping () -> Void) {
        let shopUID = prCart.shopUID
        let q = isPrVC ? prCart.quantity + 1 : quantity
        let toDict = toDictionary(shopUID,
                                  prUID: prCart.prUID,
                                  name: prCart.name,
                                  imageLinks: prCart.imageLinks,
                                  price: prCart.price,
                                  saleOff: prCart.saleOff,
                                  quantity: q,
                                  selectColor: prCart.selectColor,
                                  selectSize: prCart.selectSize,
                                  createdTime: prCart.createdTime)
        setupTransaction(uid: shopUID, toDictionary: toDict)
        completion()
    }
    
    func deleteShoppingCart(prCart: ProductCart, completion: @escaping () -> Void) {
        let shopUID = prCart.shopUID
        setupTransaction(uid: shopUID, toDictionary: nil)
        completion()
    }
    
    func deleteAllShoppingCart(completion: @escaping () -> Void) {
        let ref = DatabaseRef.user(uid: currentUID).ref().child("shoppingCart")
        ref.removeValue()
        completion()
    }
    
    private func setupTransaction(uid: String, toDictionary: [String: Any]?) {
        let ref = DatabaseRef.user(uid: currentUID).ref().child("shoppingCart")
        ref.runTransactionBlock { (mutableData) -> TransactionResult in
            var dictionary = mutableData.value as? [String: Any] ?? [:]
            var prDict = dictionary["products"] as? [String: Any] ?? [:]
            prDict[uid] = toDictionary
            
            var subtotal: Double = 0.0
            var fee: Double = 0.0
            var tax: Double = 0.0
            var total: Double = 0.0
            
            var price: Double = 0.0
            for (_, value) in prDict {
                if let dict = value as? [String: Any] {
                    let p = dict["price"] as! Double
                    let s = dict["saleOff"] as! Double
                    let q = (dict["quantity"] as! Int)
                    let saleOff = (100 - s)/100
                    let kPrice = round(100*(p*saleOff))/100
                    price += kPrice*Double(q)
                }
            }
            
            subtotal = price
            fee = subtotal > 50.0 ? 5.0 : 0.0
            tax = round(100*(0.1 * (subtotal+fee)))/100
            total = round(100*(subtotal + fee + tax))/100
            
            dictionary["products"] = prDict
            dictionary["subtotal"] = subtotal
            dictionary["fee"] = fee
            dictionary["tax"] = tax
            dictionary["total"] = total
            mutableData.value = dictionary
            
            return TransactionResult.success(withValue: mutableData)
        }
    }
    
    private func toDictionary(_ shopUID: String,
                              prUID: String,
                              name: String,
                              imageLinks: [String],
                              price: Double,
                              saleOff: Double,
                              quantity: Int,
                              selectColor: String,
                              selectSize: String,
                              createdTime: String) -> [String: Any] {
        return [
            "shopUID": shopUID,
            "prUID": prUID,
            "name": name,
            "imageLinks": imageLinks,
            "price": price,
            "saleOff": saleOff,
            "quantity": quantity,
            "selectColor": selectColor,
            "selectSize": selectSize,
            "createdTime": createdTime,
        ]
    }
}


//MARK: - Fetch

extension ShoppingCart {
    
    class func fetchShoppingCart(completion: @escaping (ShoppingCart?) -> Void) {
        let ref = DatabaseRef.user(uid: currentUID).ref().child("shoppingCart")
        ref.observe(.value) { (snapshot) in
            guard snapshot.exists() else { completion(nil); return }
            
            if let dict = snapshot.value as? [String: Any] {
                let shoppingCart = ShoppingCart(dictionary: dict)
                completion(shoppingCart)
            }
        }
    }
    
    class func fetchProductCart(name: String, selectColor: String, selectSize: String, completion: @escaping (ProductCart?) -> Void) {
        let ref = DatabaseRef.user(uid: currentUID).ref().child("shoppingCart/products")
        ref.observe(.childAdded) { (snapshot) in
            guard snapshot.exists() else { completion(nil); return }
            
            if let dict = snapshot.value as? [String: Any] {
                let prCart = ProductCart(shopUID: snapshot.key, dictionary: dict)
                if prCart.name == name,
                    prCart.selectColor == selectColor,
                    prCart.selectSize == selectSize {
                    DispatchQueue.main.async {
                        completion(prCart)
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }
}
