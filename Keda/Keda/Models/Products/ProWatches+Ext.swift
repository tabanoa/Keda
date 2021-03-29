//
//  ProWatches+Ext.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

extension Product {
    
    class func watches1() -> Product {
        let uid = "123456-WATCHES-001"
        let name = "Bulova"
        let price: Double = 395.0
        let description = """
● Gender - Shortss
● The Bulova, American Clipper series features a stainless steel 42mm case, with a fixed bezel, a black (skeletal window) dial and a scratch resistant mineral crystal.
● Sub-dials: small seconds.
● The 20mm leather band is fitted with a tang clasp.
● This beautiful wristwatch, powered by automatic movement supporting: hour, minute, second functions.
● This watch has a water resistance of up to 100 feet/30 meters, suitable for short periods of recreational swimming.
● This stylish timepiece is sure to complete any man's collection.
"""
        
        var imgLinks: [String] = []
        watchesIMGLinks1.forEach({ imgLinks.append($0) })
        
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 50.0,
                                            imageLinks: imgLinks,
                                            description: description)
        
        let prSize1 = ProductSize(size: "42MM", prInfoModel: prInfoModel1)
        
        var prSizes: [ProductSize] = []
        prSizes.append(prSize1)
        
        let prColor1 = ProductColor(color: "000000", prSizes: prSizes)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        
        let tags = ["watches men", "watches women", "belts", "apple watch", "watch", "bulova"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Watches.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
    
    /******************************************************************************************/
    
    class func watches2() -> Product {
        let uid = "123456-WATCHES-002"
        let name = "Zeno"
        let price: Double = 950.0
        let description = """
● Gender - Shortss
● The ZenoThe Watch features a stainless steel 48mm case, with a black uni-directional rotating bezel, a black dial and a scratch resistant sapphire crystal.
● The 24mm rubber band is fitted with a tang clasp.
● This beautiful wristwatch, powered by Swiss automatic movement supporting: date, hour, minute, second functions.
● This watch has a water resistance of up to 165 feet/50 meters, suitable for short periods of recreational swimming, but not diving or snorkeling.
● This stylish Swiss-made timepiece is sure to complete any man's collection.
"""
        
        var imgLinks: [String] = []
        watchesIMGLinks2.forEach({ imgLinks.append($0) })
        
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 43.0,
                                            imageLinks: imgLinks,
                                            description: description)
        
        let prSize1 = ProductSize(size: "48MM", prInfoModel: prInfoModel1)
        
        var prSizes: [ProductSize] = []
        prSizes.append(prSize1)
        
        let prColor1 = ProductColor(color: "000000", prSizes: prSizes)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        
        let tags = ["watches men", "watches women", "belts", "apple watch", "watch", "zeno"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Watches.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
    
    /******************************************************************************************/
    
    class func watches3() -> Product {
        let uid = "123456-WATCHES-003"
        let name = "Vulcain"
        let price: Double = 3450.0
        let description = """
● Gender - Womens
● The Vulcain, First Lady series features a stainless steel 37.60mmx32.10mm case, with a fixed bezel, a mother of pearl dial and a scratch resistant sapphire crystal.
● The satin band is fitted with a tang clasp.
● This beautiful wristwatch, powered by a Vulcain Calibre V-61, Swiss automatic movement, supporting: date, hour, minute, second functions.
● This watch has a water resistance of up to 100 feet/30 meters, suitable for short periods of recreational swimming.
● This stylish Swiss-made timepiece is sure to complete any woman's collection.
"""
        
        var imgLinks: [String] = []
        watchesIMGLinks3.forEach({ imgLinks.append($0) })
        
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 63.0,
                                            imageLinks: imgLinks,
                                            description: description)
        
        let prSize1 = ProductSize(size: "37,60MM X 32,10MM", prInfoModel: prInfoModel1)
        
        var prSizes: [ProductSize] = []
        prSizes.append(prSize1)
        
        let prColor1 = ProductColor(color: "FFFFFF", prSizes: prSizes)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        
        let tags = ["watches men", "watches women", "belts", "apple watch", "watch", "vulcain"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Watches.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
    
    /******************************************************************************************/
    
    class func watches4() -> Product {
        let uid = "123456-WATCHES-004"
        let des = """
● GPS
● Always-On Retina display
● 30% larger screen
● Swimproof
● ECG app
● Electrical and optical heart sensors
● Built-in compass
● Elevation
● Emergency SOS
● Fall detection
"""
        
        //TODO: - Gold
        var imgLinks1: [String] = []
        watchesIMGLinks4.forEach({ imgLinks1.append($0) })
        let prInfoModel1 = ProductInfoModel(name: "Apple Watch Series 5 (GPS, 40mm) - Gold Aluminum Case with Pink Sport Band",
                                            price: 399.0,
                                            saleOff: 0.0,
                                            imageLinks: imgLinks1,
                                            description: des)
        let prSize1 = ProductSize(size: "40MM", prInfoModel: prInfoModel1)
        
        let prInfoModel2 = ProductInfoModel(name: "Apple Watch Series 5 (GPS, 44mm) - Gold Aluminum Case with Pink Sport Band",
                                            price: 429.0,
                                            saleOff: 0.0,
                                            imageLinks: imgLinks1,
                                            description: des)
        let prSize2 = ProductSize(size: "44MM", prInfoModel: prInfoModel2)
        
        //TODO: - Black
        var imgLinks2: [String] = []
        watchesIMGLinks5.forEach({ imgLinks2.append($0) })
        let prInfoModel3 = ProductInfoModel(name: "Apple Watch Series 5 (GPS, 40mm) - Space Gray Aluminum Case with Black Sport Band",
                                            price: 399.0,
                                            saleOff: 0.0,
                                            imageLinks: imgLinks2,
                                            description: des)
        let prSize3 = ProductSize(size: "40MM", prInfoModel: prInfoModel3)
        
        let prInfoModel4 = ProductInfoModel(name: "Apple Watch Series 5 (GPS, 44mm) - Space Gray Aluminum Case with Black Sport Band",
                                            price: 429.0,
                                            saleOff: 0.0,
                                            imageLinks: imgLinks2,
                                            description: des)
        let prSize4 = ProductSize(size: "44MM", prInfoModel: prInfoModel4)
        
        //TODO: - White
        var imgLinks3: [String] = []
        watchesIMGLinks6.forEach({ imgLinks3.append($0) })
        let prInfoModel5 = ProductInfoModel(name: "Apple Watch Series 5 (GPS, 40mm) - Silver Aluminum Case with White Sport Band",
                                            price: 399.0,
                                            saleOff: 0.0,
                                            imageLinks: imgLinks3,
                                            description: des)
        let prSize5 = ProductSize(size: "40MM", prInfoModel: prInfoModel5)
        
        let prInfoModel6 = ProductInfoModel(name: "Apple Watch Series 5 (GPS, 44mm) - Silver Aluminum Case with White Sport Band",
                                            price: 429.0,
                                            saleOff: 0.0,
                                            imageLinks: imgLinks3,
                                            description: des)
        let prSize6 = ProductSize(size: "44MM", prInfoModel: prInfoModel6)
        
        var prSizes1: [ProductSize] = []
        prSizes1.append(prSize1)
        prSizes1.append(prSize2)
        
        var prSizes2: [ProductSize] = []
        prSizes2.append(prSize3)
        prSizes2.append(prSize4)
        
        var prSizes3: [ProductSize] = []
        prSizes3.append(prSize5)
        prSizes3.append(prSize6)
        
        let prColor1 = ProductColor(color: "EEC0B4", prSizes: prSizes1)
        let prColor2 = ProductColor(color: "3D3938", prSizes: prSizes2)
        let prColor3 = ProductColor(color: "FFFFFF", prSizes: prSizes3)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        prColors.append(prColor2)
        prColors.append(prColor3)
        
        let tags = ["watches men", "watches women", "belts", "apple watch", "watch", "apple watch 44mm", "apple watch 40mm", "apple watch pink", "apple watch white", "apple watch black", "apple watch series 5 gps, 40mm pink", "apple watch series 5 gps, 44mm pink", "apple watch series 5 gps, 40mm black", "apple watch series 5 gps, 44mm black", "apple watch series 5 gps, 40mm white", "apple watch series 5 gps, 44mm white"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Watches.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
}
