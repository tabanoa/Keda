//
//  ProShoes+Ext.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import Foundation

extension Product {
    
    class func shoes1() -> Product {
        let uid = "123456-SHOES-001"
        let name = "Nike Air Max 270"
        let price: Double = 150.99
        let description = """
● The Nike Air Max 270 Shorts's Shoe is inspired by two icons of big Air: the Air Max 180 and Air Max 93. It features Nike’s biggest heel Air unit yet for a super-soft ride that feels as impossible as it looks.
"""
        let size1 = "EU 35,5"
        let size2 = "EU 36"
        let size3 = "EU 36,5"
        let size4 = "EU 37,5"
        
        var imgLinks1: [String] = []
        shoesIMGLinks1.forEach({ imgLinks1.append($0) })
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 5.0,
                                            imageLinks: imgLinks1,
                                            description: description)
        let prSize1_1 = ProductSize(size: size1, prInfoModel: prInfoModel1)
        let prSize1_2 = ProductSize(size: size2, prInfoModel: prInfoModel1)
        let prSize1_3 = ProductSize(size: size3, prInfoModel: prInfoModel1)
        let prSize1_4 = ProductSize(size: size4, prInfoModel: prInfoModel1)
        
        var imgLinks2: [String] = []
        shoesIMGLinks2.forEach({ imgLinks2.append($0) })
        let prInfoModel2 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 0.0,
                                            imageLinks: imgLinks2,
                                            description: description)
        let prSize2_1 = ProductSize(size: size1, prInfoModel: prInfoModel2)
        let prSize2_2 = ProductSize(size: size2, prInfoModel: prInfoModel2)
        let prSize2_3 = ProductSize(size: size3, prInfoModel: prInfoModel2)
        let prSize2_4 = ProductSize(size: size4, prInfoModel: prInfoModel2)
        
        var prSizes1: [ProductSize] = []
        prSizes1.append(prSize1_1)
        prSizes1.append(prSize1_2)
        prSizes1.append(prSize1_3)
        prSizes1.append(prSize1_4)
        
        var prSizes2: [ProductSize] = []
        prSizes2.append(prSize2_1)
        prSizes2.append(prSize2_2)
        prSizes2.append(prSize2_3)
        prSizes2.append(prSize2_4)
        
        let prColor1 = ProductColor(color: "2757A9", prSizes: prSizes1)
        let prColor2 = ProductColor(color: "FFFFFF", prSizes: prSizes2)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        prColors.append(prColor2)
        
        let tags = ["shoes", "nike", "men", "nike air max 270"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Shoes.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
    
    /******************************************************************************************/
    
    class func shoes2() -> Product {
        let uid = "123456-SHOES-002"
        let name = "Nike Epic React Flyknit"
        let price: Double = 150.0
        let description = """
● The Nike Epic React Flyknit Shorts's Running Shoe provides crazy comfort that lasts as long as you can run. Its Nike React foam cushioning is responsive yet lightweight, durable yet soft. This attraction of opposites creates a sensation that not only enhances the feeling of moving forward, but makes running feel fun, too.
"""
        let size1 = "EU 35,5"
        let size2 = "EU 36"
        let size3 = "EU 36,5"
        let size4 = "EU 37,5"
        
        var imgLinks1: [String] = []
        shoesIMGLinks3.forEach({ imgLinks1.append($0) })
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 0.0,
                                            imageLinks: imgLinks1,
                                            description: description)
        let prSize1_1 = ProductSize(size: size1, prInfoModel: prInfoModel1)
        let prSize1_2 = ProductSize(size: size2, prInfoModel: prInfoModel1)
        let prSize1_3 = ProductSize(size: size3, prInfoModel: prInfoModel1)
        let prSize1_4 = ProductSize(size: size4, prInfoModel: prInfoModel1)
        
        var prSizes1: [ProductSize] = []
        prSizes1.append(prSize1_1)
        prSizes1.append(prSize1_2)
        prSizes1.append(prSize1_3)
        prSizes1.append(prSize1_4)
        
        let prColor1 = ProductColor(color: "46B2D6", prSizes: prSizes1)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        
        let tags = ["shoes", "nike", "men", "nike epic react flyknit"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Shoes.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
    
    /******************************************************************************************/
    
    class func shoes3() -> Product {
        let uid = "123456-SHOES-003"
        let name = "Nike Free Rn Flyknit"
        let price: Double = 150.0
        let description = """
 ● The Nike Epic React Flyknit Shorts's Running Shoe provides crazy comfort that lasts as long as you can run. Its Nike React foam cushioning is responsive yet lightweight, durable yet soft. This attraction of opposites creates a sensation that not only enhances the feeling of moving forward, but makes running feel fun, too.
"""
        let size1 = "EU 35,5"
        let size2 = "EU 36"
        let size3 = "EU 36,5"
        let size4 = "EU 37,5"
        
        var imgLinks1: [String] = []
        shoesIMGLinks4.forEach({ imgLinks1.append($0) })
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 5.0,
                                            imageLinks: imgLinks1,
                                            description: description)
        let prSize1_1 = ProductSize(size: size1, prInfoModel: prInfoModel1)
        let prSize1_2 = ProductSize(size: size2, prInfoModel: prInfoModel1)
        let prSize1_3 = ProductSize(size: size3, prInfoModel: prInfoModel1)
        let prSize1_4 = ProductSize(size: size4, prInfoModel: prInfoModel1)
        
        var prSizes1: [ProductSize] = []
        prSizes1.append(prSize1_1)
        prSizes1.append(prSize1_2)
        prSizes1.append(prSize1_3)
        prSizes1.append(prSize1_4)
        
        let prColor1 = ProductColor(color: "A1A0A8", prSizes: prSizes1)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        
        let tags = ["shoes", "nike", "men", "nike free rn flyknit"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Shoes.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
}
