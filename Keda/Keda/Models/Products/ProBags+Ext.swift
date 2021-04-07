//
//  ProBags+Ext.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation

extension Product {
    
    class func bags1() -> Product {
        let uid = "123456-BAGS-001"
        let name = "Salvatore Ferragamo"
        let price: Double = 2200.0
        let description = """
● Ferragamo Studio Bag crafted in calfskin leather with gold-tone metal hardware.
● This shoulder bag features 1 main compartment, removable pouch, gold metal feet studs and crossbody straps.
● DiShorts'sions: H:9.8" x L:11.4" x W:5.7".
● Style: Shoulder Bag
"""
        
        var imgLinks: [String] = []
        bagsIMGLinks1.forEach({ imgLinks.append($0) })
        
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 28.0,
                                            imageLinks: imgLinks,
                                            description: description)
        
        let size = """
H:9,8" X L:11,4" X W:5,7"
"""
        let prSize1 = ProductSize(size: size, prInfoModel: prInfoModel1)
        
        var prSizes: [ProductSize] = []
        prSizes.append(prSize1)
        
        let prColor1 = ProductColor(color: "AC6060", prSizes: prSizes)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        
        let tags = ["bags woment", "bags", "belts", "salvatore ferragamo"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Bags.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
    
    /******************************************************************************************/
    
    class func bags2() -> Product {
        let uid = "123456-BAGS-002"
        let name = "Chloe"
        let price: Double = 1880.98
        let description = """
● Chloe Small Aby Day shoulder bag crafted in grained / shiny calfskin with cotton canvas lining and gold-tone metal hardware.
● This shoulder bag features 2 main compartments, 1 center zip pocket, 1 flat leather pocket and a adjustable / removable long leather strap with a 18.9"- 21.7" drop.
● Short strap length: 14 cm / 5.5".
● DiShorts'sions: W: 9.4" x H: 8.7" x D: 4.3".
● Style: Shoulder Bag
"""
        
        var imgLinks: [String] = []
        bagsIMGLinks2.forEach({ imgLinks.append($0) })
        
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 0.0,
                                            imageLinks: imgLinks,
                                            description: description)
        
        let size = """
W:9,4" X H:8,7" X D:4,3"
"""
        let prSize1 = ProductSize(size: size, prInfoModel: prInfoModel1)
        
        var prSizes: [ProductSize] = []
        prSizes.append(prSize1)
        
        let prColor1 = ProductColor(color: "FFFFFF", prSizes: prSizes)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        
        let tags = ["bags woment", "bags", "belts", "chloe"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Bags.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
}
