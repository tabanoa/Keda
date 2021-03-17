//
//  NewUser.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

struct NewUserModel {
    let image: UIImage
    let title: String
    let content: String
}

class NewUser {
    
    private let model: NewUserModel
    
    init(model: NewUserModel) {
        self.model = model
    }
    
    var image: UIImage { return model.image }
    var title: String { return model.title }
    var content: String { return model.content }
}

extension NewUser {
    
    static func sharedInstance() -> [NewUser] {
        var newUsers: [NewUser] = []
        
        /****************************************************************************************/
        
        let screenATitle = NSLocalizedString("WELCOME TO FASHI", comment: "NewUser.swift: Screen1 T")
        let screenAContent = ""
        
        let m1 = NewUserModel(image: UIImage(named: "icon-f")!, title: screenATitle, content: screenAContent)
        let n1 = NewUser(model: m1)
        newUsers.append(n1)
        
        /****************************************************************************************/
        
        let screenBTitle = NSLocalizedString("QUICK SEARCH", comment: "NewUser.swift: Screen2 T")
        let screenBContent = NSLocalizedString("Quickly find the products you like the most.", comment: "NewUser.swift: Screen2 C")
        
        let m2 = NewUserModel(image: UIImage(named: "icon-quickSearch")!, title: screenBTitle, content: screenBContent)
        let n2 = NewUser(model: m2)
        newUsers.append(n2)
        
        /****************************************************************************************/
        
        let screenCTitle = NSLocalizedString("SHOPPING BAG", comment: "NewUser.swift: Screen3 T")
        let screenCContent = NSLocalizedString("Add products to your shopping cart, and check them out later.", comment: "NewUser.swift: Screen3 C")
        
        let m3 = NewUserModel(image: UIImage(named: "icon-shoppingBag")!, title: screenCTitle, content: screenCContent)
        let n3 = NewUser(model: m3)
        newUsers.append(n3)
        
        /****************************************************************************************/
        
        let screenDTitle = NSLocalizedString("WISHLIST", comment: "NewUser.swift: Screen4 T")
        let screenDContent = NSLocalizedString("Build a wishlist with your favorite products to buy them later.", comment: "NewUser.swift: Screen4 C")
        
        let m4 = NewUserModel(image: UIImage(named: "icon-wl")!, title: screenDTitle, content: screenDContent)
        let n4 = NewUser(model: m4)
        newUsers.append(n4)
        
        /****************************************************************************************/
        
        let screenETitle = NSLocalizedString("ORDER TRACKING", comment: "NewUser.swift: Screen5 T")
        let screenEContent = NSLocalizedString("Monitor your orders and get updates when something changes.", comment: "NewUser.swift: Screen5 C")
        
        let m5 = NewUserModel(image: UIImage(named: "icon-orderTracking")!, title: screenETitle, content: screenEContent)
        let n5 = NewUser(model: m5)
        newUsers.append(n5)
        
        /****************************************************************************************/
        
        let screenFTitle = NSLocalizedString("NOTIFICATIONS", comment: "NewUser.swift: Screen6 T")
        let screenFContent = NSLocalizedString("Get notifications for new products, promotions and discounts.", comment: "NewUser.swift: Screen6 C")
        
        let m6 = NewUserModel(image: UIImage(named: "icon-notifications")!, title: screenFTitle, content: screenFContent)
        let n6 = NewUser(model: m6)
        newUsers.append(n6)
        
        /****************************************************************************************/
        
        let screenGTitle = NSLocalizedString("STRIPE PAYMENTS", comment: "NewUser.swift: Screen7 T")
        let screenGContent = NSLocalizedString("We support all payment options.", comment: "NewUser.swift: Screen7 C")
        
        let m7 = NewUserModel(image: UIImage(named: "icon-payments")!, title: screenGTitle, content: screenGContent)
        let n7 = NewUser(model: m7)
        newUsers.append(n7)
        
        /****************************************************************************************/
        
        let screenHTitle = NSLocalizedString("APPLE PAY", comment: "NewUser.swift: Screen8 T")
        let screenHContent = NSLocalizedString("Pay with a single click with Apple Pay.", comment: "NewUser.swift: Screen8 C")
        
        let m8 = NewUserModel(image: UIImage(named: "icon-apple")!, title: screenHTitle, content: screenHContent)
        let n8 = NewUser(model: m8)
        newUsers.append(n8)
        
        return newUsers
    }
}
