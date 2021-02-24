//
//  Cart.swift
// kedaCataloguePayment
// By Manjot Sidhu
// February 7th 2021

import Foundation


class Cart {
    
    var id: String!
    var ownerId: String!
    var itemIds: [String]!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as? String
        ownerId = _dictionary[kOWNERID] as? String
        itemIds = _dictionary[kITEMIDS] as? [String]
    }
}


//MARK: - Download items
func downloadCarttFromFirestore(_ ownerId: String, completion: @escaping (_ cart: Cart?)-> Void) {
    
    FirebaseReference(.Cart).whereField(kOWNERID, isEqualTo: ownerId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let cart = Cart(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(cart)
        } else {
            completion(nil)
        }
    }
}


//MARK: - Save to Firebase
func saveCartToFirestore(_ cart: Cart) {
    
    FirebaseReference(.Cart).document(cart.id).setData(cartDictionaryFrom(cart) as! [String: Any])
}


//MARK: Helper functions

func cartDictionaryFrom(_ cart: Cart) -> NSDictionary {
    
    return NSDictionary(objects: [cart.id, cart.ownerId, cart.itemIds], forKeys: [kOBJECTID as NSCopying, kOWNERID as NSCopying, kITEMIDS as NSCopying])
}

//MARK: - Update cart
func updateCartInFirestore(_ cart: Cart, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
    
    
    FirebaseReference(.Cart).document(cart.id).updateData(withValues) { (error) in
        completion(error)
    }
}





