//
//  Address.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Firebase

struct AddressModel: Codable {
    var uid: String = ""
    let firstName: String
    let lastName: String
    let addrLine1: String
    let addrLine2: String?
    let country: String
    let state: String
    let city: String
    let zipcode: String
    let phoneNumber: String
    let createdTime: String
    var defaults: Bool
    
    enum CodingKeys: String, CodingKey {
        case uid
        case firstName
        case lastName
        case addrLine1
        case addrLine2
        case country
        case state
        case city
        case zipcode
        case phoneNumber
        case createdTime
        case defaults
    }
}

class Address: NSObject {
    
    var model: AddressModel
    
    init(model: AddressModel) {
        self.model = model
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? Address else { return false }
        let lhs = self
        return lhs.createdTime == rhs.createdTime
    }
    
    var uid: String { return model.uid }
    var firstName: String { return model.firstName }
    var lastName: String { return model.lastName }
    var addrLine1: String { return model.addrLine1 }
    var addrLine2: String? { return model.addrLine2 }
    var country: String { return model.country }
    var state: String { return model.state }
    var city: String { return model.city }
    var zipcode: String { return model.zipcode }
    var phoneNumber: String { return model.phoneNumber }
    var createdTime: String { return model.createdTime }
    var defaults: Bool { return model.defaults }
}

extension Address {
    
    convenience init(dictionary: [String: Any]) {
        let uid = dictionary["uid"] as! String
        let firstName = dictionary["firstName"] as! String
        let lastName = dictionary["lastName"] as! String
        let addrLine1 = dictionary["addrLine1"] as! String
        let addrLine2 = dictionary["addrLine2"] as? String
        let country = dictionary["country"] as! String
        let state = dictionary["state"] as! String
        let city = dictionary["city"] as! String
        let zipcode = dictionary["zipcode"] as! String
        let phoneNumber = dictionary["phoneNumber"] as! String
        let createdTime = dictionary["createdTime"] as! String
        let defaults = dictionary["defaults"] as! Bool
        let model = AddressModel(uid: uid, firstName: firstName, lastName: lastName, addrLine1: addrLine1, addrLine2: addrLine2, country: country, state: state, city: city, zipcode: zipcode, phoneNumber: phoneNumber, createdTime: createdTime, defaults: defaults)
        self.init(model: model)
    }
}

//MARK: - Save

extension Address {
    
    func saveAddress(completion: @escaping () -> Void) {
        model.uid = Database.database().reference().childByAutoId().key!
        let ref = DatabaseRef.user(uid: currentUID).ref().child("address/\(uid)")
        ref.setValue(toDictionary())
        completion()
    }
    
    func updateAddress(addr: Address, completion: @escaping () -> Void) {
        model.uid = addr.uid
        let ref = DatabaseRef.user(uid: currentUID).ref().child("address/\(addr.uid)")
        ref.updateChildValues(toDictionary())
        completion()
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "firstName": firstName,
            "lastName": lastName,
            "addrLine1": addrLine1,
            "addrLine2": addrLine2 as Any,
            "country": country,
            "state": state,
            "city": city,
            "zipcode": zipcode,
            "phoneNumber": phoneNumber,
            "createdTime": createdTime,
            "defaults": defaults
        ]
    }
    
    func updateDefaults(addr: Address, completion: @escaping () -> Void) {
        let ref = DatabaseRef.user(uid: currentUID).ref().child("address/\(uid)")
        ref.updateChildValues(["defaults": addr.defaults])
    }
}

//MARK: - Fetch

extension Address {
    
    class func fetchAddress(completion: @escaping ([Address]) -> Void) {
        var addresses: [Address] = []
        let ref = DatabaseRef.user(uid: currentUID).ref().child("address")
        ref.observe(.childAdded) { (snapshot) in
            guard snapshot.exists() else { completion([]); return }
            if let dict = snapshot.value as? [String: Any] {
                let addr = Address(dictionary: dict)
                if !addresses.contains(addr) {
                    addresses.append(addr)
                    DispatchQueue.main.async {
                        completion(addresses)
                    }
                }
            }
        }
    }
}
