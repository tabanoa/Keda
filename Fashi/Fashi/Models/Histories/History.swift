//
//  History.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Firebase

struct HistoryModel {
    var uid: String = ""
    var address: Address! = nil
    let shoppingCart: ShoppingCart
    var delivered: Bool
    let paymentMethod: String
    let codeOrder: String
    var userUID: String
}

class History {
    
    var model: HistoryModel
    
    init(model: HistoryModel) {
        self.model = model
    }
    
    var uid: String { return model.uid }
    var delivered: Bool { return model.delivered }
    var address: Address { return model.address }
    var shoppingCart: ShoppingCart { return model.shoppingCart }
    var paymentMethod: String { return model.paymentMethod }
    var codeOrder: String { return model.codeOrder }
    var userUID: String { return model.userUID }
}

//MARK: - Dictionary

extension History {
    
    convenience init(dictionary: [String: Any]) {
        var address: Address!
        if let addrDict = dictionary["address"] as? [String: Any] {
            address = Address(dictionary: addrDict)
            
        } else {
            address = nil
        }
        
        var shoppingCart = ShoppingCart()
        if let shopDict = dictionary["shoppingCart"] as? [String: Any] {
            shoppingCart = ShoppingCart(dictionary: shopDict)
        }
        
        let uid = dictionary["uid"] as! String
        let delivered = dictionary["delivered"] as! Bool
        let paymentMethod = dictionary["paymentMethod"] as! String
        let codeOrder = dictionary["codeOrder"] as! String
        let userUID = dictionary["userUID"] as! String
        let model = HistoryModel(uid: uid,
                                 address: address,
                                 shoppingCart: shoppingCart,
                                 delivered: delivered,
                                 paymentMethod: paymentMethod,
                                 codeOrder: codeOrder,
                                 userUID: userUID)
        self.init(model: model)
    }
}

//MARK: - Save

extension History {
    
    class func saveHistory(hud: HUD, address: Address?, shoppingCart: ShoppingCart, paymentMethod: String, vc: UIViewController, completion: @escaping () -> Void) {
        var isPush = true
        let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "X", "Y", "Z", "W", ].kShuffled
        let codeOrder = letters.first! + dateFormatterShort().string(from: Date())
        let model = HistoryModel(address: address!, shoppingCart: shoppingCart, delivered: false, paymentMethod: paymentMethod, codeOrder: codeOrder, userUID: currentUID)
        let history = History(model: model)
        history.saveHistory {
            delay(duration: 1.0) {
                UIView.animate(withDuration: 0.5, animations: {
                    hud.alpha = 0.0

                }) { (_) in
                    hud.removeFromSuperview()

                    guard isPush else { return }
                    let receiptVC = ReceiptVC()
                    receiptVC.uid = history.uid
                    receiptVC.isSuccess = true
                    receiptVC.history = history
                    receiptVC.hidesBottomBarWhenPushed = true
                    vc.navigationController?.pushViewController(receiptVC, animated: true)
                    completion()
                    isPush = false
                }
            }
            
            delay(duration: 2.0) { shoppingCart.deleteAllShoppingCart {} }
        }
    }
    
    func saveHistory(completion: @escaping () -> Void) {
        model.uid = createTime()
        let ref = DatabaseRef.histories(uid: userUID).ref().child(uid)
        ref.setValue(toDictionary())
        
        let refAddr = ref.child("address")
        refAddr.updateChildValues(address.toDictionary())
        
        let refShoppingCart = ref.child("shoppingCart")
        refShoppingCart.updateChildValues(toDictShoppingCart())

        for prCart in shoppingCart.productCarts {
            let refPrDict = refShoppingCart.child("products/\(prCart.shopUID)")
            refPrDict.updateChildValues(toDictPrCart(prCart))
            completion()
        }
    }
    
    func saveAddress(uid: String, completion: @escaping () -> Void) {
        let ref = DatabaseRef.histories(uid: currentUID).ref().child("\(uid)/address")
        ref.updateChildValues(address.toDictionary())
    }
    
    private func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "delivered": delivered,
            "paymentMethod": paymentMethod,
            "codeOrder": codeOrder,
            "userUID": userUID
        ]
    }
    
    private func toDictShoppingCart() -> [String: Any] {
        return [
            "subtotal": shoppingCart.subtotal,
            "fee": shoppingCart.fee,
            "tax": shoppingCart.tax,
            "total": shoppingCart.total
        ]
    }
    
    private func toDictPrCart(_ prCart: ProductCart) -> [String: Any] {
        return [
            "prUID": prCart.prUID,
            "name": prCart.name,
            "imageLinks": prCart.imageLinks,
            "price": prCart.price,
            "saleOff": prCart.saleOff,
            "quantity": prCart.quantity,
            "selectColor": prCart.selectColor,
            "selectSize": prCart.selectSize,
            "createdTime": prCart.createdTime
        ]
    }
}

//MARK: - Save

extension History {
    
    func updateDelivered(completion: @escaping () -> Void) {
        let ref = DatabaseRef.histories(uid: userUID).ref().child("\(uid)/delivered")
        ref.setValue(true)
        completion()
    }
}

//MARK: - Fetch

extension History {
    
    //MARK: - All Histories
    class func fetchHistories(completion: @escaping ([History]) -> Void) {
        var histories: [History] = []
        let ref = Database.database().reference().child("Histories")
        ref.observe(.value) { (snapshot) in
            guard snapshot.exists() else { completion([]); return }
            
            let refC = ref.child(currentUID)
            refC.observe(.value) { (snapshot) in
                guard snapshot.exists() else { completion([]); return }
                
                if let dict = snapshot.value as? [String: Any] {
                    for(_, value) in dict {
                        if let dict = value as? [String: Any] {
                            let his = History(dictionary: dict)
                            if !histories.contains(his) {
                                histories.append(his)
                                DispatchQueue.main.async {
                                    completion(histories)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - OrderPlaced
    class func fetchOrderPlacedFrom(userUID: String, completion: @escaping ([History]) -> Void) {
        var histories: [History] = []
        let ref = Database.database().reference().child("Histories/\(userUID)")
        ref.observe(.value) { (snapshot) in
            guard snapshot.exists() else { completion([]); return }
            
            ref.observe(.childAdded) { (snapshot) in
                guard snapshot.exists() else { completion([]); return }
                
                if let dict = snapshot.value as? [String: Any],
                    let delivered = dict["delivered"] as? Bool {
                    guard !delivered else { return }
                    
                    let his = History(dictionary: dict)
                    if !histories.contains(his) {
                        histories.append(his)
                        DispatchQueue.main.async {
                            completion(histories)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Delivered
    class func fetchDeliveredFrom(userUID: String, completion: @escaping ([History]) -> Void) {
        var histories: [History] = []
        let ref = Database.database().reference().child("Histories/\(userUID)")
        ref.observe(.value) { (snapshot) in
            guard snapshot.exists() else { completion([]); return }
            
            ref.observe(.childAdded) { (snapshot) in
                guard snapshot.exists() else { completion([]); return }
                
                if let dict = snapshot.value as? [String: Any],
                    let delivered = dict["delivered"] as? Bool {
                    guard delivered else { return }
                    
                    let his = History(dictionary: dict)
                    if !histories.contains(his) {
                        histories.append(his)
                        DispatchQueue.main.async {
                            completion(histories)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - OrderPlaced
    class func fetchUsersFromOrderPlaced(completion: @escaping ([User]) -> Void) {
        var usersOrderPlaced: [User] = []
        let ref = Database.database().reference().child("Histories")
        ref.observe(.value) { (snapshot) in
            guard snapshot.exists() else { completion([]); return }
            
            ref.observe(.childAdded) { (snapshot) in
                guard snapshot.exists() else { completion([]); return }
                let userUID = snapshot.key
                
                let refO = ref.child(userUID)
                refO.observe(.childAdded) { (snapshotO) in
                    
                    User.fetchUserFromUID(uid: userUID) { (user) in
                        user.userModel.orderDate = snapshotO.key
                        
                        if let dict = snapshotO.value as? [String: Any],
                            let delivered = dict["delivered"] as? Bool {
                            guard !delivered else { return }
                            
                            if !usersOrderPlaced.contains(user) {
                                usersOrderPlaced.append(user)
                                DispatchQueue.main.async {
                                    completion(usersOrderPlaced)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    class func fetchHistory(uid: String, completion: @escaping (History) -> Void) {
        let ref = DatabaseRef.histories(uid: currentUID).ref().child(uid)
        ref.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let his = History(dictionary: dict)
                completion(his)
            }
        }
    }
    
    class func fetchOrderPlacedFrom(completion: @escaping (Bool?) -> Void) {
        let ref = Database.database().reference().child("Histories")
        ref.observe(.value) { (snapshot) in
            guard snapshot.exists() else { completion(false); return }
            
            ref.observe(.childAdded) { (snapshot) in
                guard snapshot.exists() else { completion(false); return }
                let userUID = snapshot.key
                
                let refH = ref.child(userUID)
                refH.observe(.childAdded) { (snapshot) in
                    if let dict = snapshot.value as? [String: Any],
                        let delivered = dict["delivered"] as? Bool {
                        guard !delivered else { completion(nil); return }
                        
                        DispatchQueue.main.async {
                            completion(true)
                        }
                    }
                }
            }
        }
    }
}

//MARK: - Equatable

extension History: Equatable {}
func ==(lhs: History, rhs: History) -> Bool {
    return lhs.uid == rhs.uid
}
