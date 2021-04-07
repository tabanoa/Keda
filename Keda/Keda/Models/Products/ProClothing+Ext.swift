//
//  Prohoodies+Ext.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation

extension Product {
    
    class func hoodies1() -> Product {
        let uid = "123456-hoodies-001"
        let name = "Lace Up Sides Cheeky Shorts"
        let price: Double = 13.99
        let description = """
● Thick ponte knit scupts the hottest hot pants, featuring lace-up details at the sides! Shoe lace weaves through metal grommets at the sides for a lace-up illusion, while an elastic waistband tops the cheeky shape below!
"""
        
        var imgLinks: [String] = []
        clothesIMGLinks1.forEach({ imgLinks.append($0) })
        
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 0.0,
                                            imageLinks: imgLinks,
                                            description: description)
        
        let prSize1 = ProductSize(size: "S", prInfoModel: prInfoModel1)
        let prSize2 = ProductSize(size: "L", prInfoModel: prInfoModel1)
        let prSize3 = ProductSize(size: "M", prInfoModel: prInfoModel1)
        
        var prSizes: [ProductSize] = []
        prSizes.append(prSize1)
        prSizes.append(prSize2)
        prSizes.append(prSize3)
        
        let prColor1 = ProductColor(color: "000000", prSizes: prSizes)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        
        let tags = ["overalls", "hoodies", "shorts", "women", "skort", "lace up sides cheeky shorts"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Hoodies.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
    
    /******************************************************************************************/
    
    class func hoodies2() -> Product {
        let uid = "123456-hoodies-002"
        let name = "Refuge Destroyed Denim Overalls"
        let price: Double = 15.99
        let description = """
● From our Refuge collection! Black denim rocks rips and tears to give these overalls a vintage feel! Metal button-up front attaches to adjustable straps that sweep into a classic back, while skinny legs taper into cute cuffs below. Four patch pockets and a handy coin slot offer a little storage to stash your stuff!
"""
        
        var imgLinks: [String] = []
        clothesIMGLinks2.forEach({ imgLinks.append($0) })
        
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 5.0,
                                            imageLinks: imgLinks,
                                            description: description)
        
        let prSize1 = ProductSize(size: "S", prInfoModel: prInfoModel1)
        let prSize2 = ProductSize(size: "L", prInfoModel: prInfoModel1)
        let prSize3 = ProductSize(size: "M", prInfoModel: prInfoModel1)
        
        var prSizes: [ProductSize] = []
        prSizes.append(prSize1)
        prSizes.append(prSize2)
        prSizes.append(prSize3)
        
        let prColor1 = ProductColor(color: "000000", prSizes: prSizes)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        
        let tags = ["overalls", "hoodies", "shorts", "women", "skort", "refuge destroyed denim overalls"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Hoodies.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
    
    /******************************************************************************************/
    
    class func hoodies3() -> Product {
        let uid = "123456-hoodies-003"
        let name = "Front Tie Asymmetrical Skort"
        let price: Double = 12.99
        let description = """
● Online only! Thick, stretchy fabric forms sexy, short shorts with a twist! A single panel drapes across the front for a chic wrapped skirt illusion, while the narrow elastic waist boasts some serious high-waist style! Thick strings sweep through a metal grommet to form a chic bow adding a flirty touch to the look.
"""
        
        var imgLinks: [String] = []
        clothesIMGLinks3.forEach({ imgLinks.append($0) })
        
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 0.0,
                                            imageLinks: imgLinks,
                                            description: description)
        
        let prSize1 = ProductSize(size: "S", prInfoModel: prInfoModel1)
        let prSize2 = ProductSize(size: "L", prInfoModel: prInfoModel1)
        let prSize3 = ProductSize(size: "M", prInfoModel: prInfoModel1)
        
        var prSizes: [ProductSize] = []
        prSizes.append(prSize1)
        prSizes.append(prSize2)
        prSizes.append(prSize3)
        
        let prColor1 = ProductColor(color: "000000", prSizes: prSizes)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        
        let tags = ["overalls", "hoodies", "shorts", "women", "skort", "front tie asymmetrical skort"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Hoodies.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
    
    /******************************************************************************************/
    
    class func hoodies4() -> Product {
        let uid = "123456-hoodies-004"
        let name = "Pleated Scuba Skater Skirt"
        let price: Double = 13.99
        let description = """
● Online only! Scuba knit sculpts this adorable mini-length skirt! Box pleats flare from a flat waistband into a full, skater silhouette for maximum volume.
"""
        
        var imgLinks: [String] = []
        clothesIMGLinks4.forEach({ imgLinks.append($0) })
        
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 2.0,
                                            imageLinks: imgLinks,
                                            description: description)
        
        let prSize1 = ProductSize(size: "S", prInfoModel: prInfoModel1)
        let prSize2 = ProductSize(size: "L", prInfoModel: prInfoModel1)
        let prSize3 = ProductSize(size: "M", prInfoModel: prInfoModel1)
        
        var prSizes: [ProductSize] = []
        prSizes.append(prSize1)
        prSizes.append(prSize2)
        prSizes.append(prSize3)
        
        let prColor1 = ProductColor(color: "63A0CD", prSizes: prSizes)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        
        let tags = ["overalls", "hoodies", "shorts", "women", "skort", "pleated scuba skater skirt"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Hoodies.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
}
