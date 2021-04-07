//
//  ProBelts+Ext.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import Foundation

extension Product {
    
    class func belts1() -> Product {
        let uid = "123456-ACCESSORIES-001"
        let name = "1 CT Diamond Swirl Stud Earrings"
        let price: Double = 1049.0
        let description = """
● These swirled studs are sure to stun! Crafted in 10K white gold, round-cut diamonds, totaling 1 ct, surround a central diamond for unforgettable shine. Pieces measure 7/16 by 7/16 inches.
"""
        
        var imgLinks: [String] = []
        beltsIMGLinks1.forEach({ imgLinks.append($0) })
        
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 10.0,
                                            imageLinks: imgLinks,
                                            description: description)
        
        let prSize1 = ProductSize(size: "ONE SIZE", prInfoModel: prInfoModel1)
        
        var prSizes: [ProductSize] = []
        prSizes.append(prSize1)
        
        let prColor1 = ProductColor(color: "BEBEBE", prSizes: prSizes)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        
        let tags = ["diamond earrings", "belts", "diamond swirl stud earrings"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Belts.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
    
    /******************************************************************************************/
    
    class func belts2() -> Product {
        let uid = "123456-ACCESSORIES-002"
        let name = "12-16 MM Pink Ming Pearl Strand Necklace, 20 Inch"
        let price: Double = 696.75
        let description = """
● A bold, yet subdued, pearl strand to elevate any outfit in your closet! Pink Ming freshwater pearls, ranging in size from 12 mm to 16 mm, decorate the strand while a 14K gold bead featuring a box-with-tongue clasp holds the piece together. Piece measures 20 inches by 1/2 inches.
"""
        
        var imgLinks: [String] = []
        beltsIMGLinks2.forEach({ imgLinks.append($0) })
        
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 5.0,
                                            imageLinks: imgLinks,
                                            description: description)
        
        let prSize1 = ProductSize(size: "ONE SIZE", prInfoModel: prInfoModel1)
        
        var prSizes: [ProductSize] = []
        prSizes.append(prSize1)
        
        let prColor1 = ProductColor(color: "D1AFA4", prSizes: prSizes)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        
        let tags = ["diamond earrings", "belts", "pink pearl strand necklace", "pink ming pearl strand necklace"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Belts.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
    
    /******************************************************************************************/
    
    class func belts3() -> Product {
        let uid = "123456-ACCESSORIES-003"
        let name = "Teardrop Fringe Drop Earrings"
        let price: Double = 179.25
        let description = """
● Get in on the statement earring trend with these beaded drops. Crafted in a classic teardrop shape, multiple beads suspend from each base and open center of either earring, designed in 10K gold. Pieces measure 2 by 3/4 inches.
"""
        
        var imgLinks: [String] = []
        beltsIMGLinks3.forEach({ imgLinks.append($0) })
        
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 5.0,
                                            imageLinks: imgLinks,
                                            description: description)
        
        let prSize1 = ProductSize(size: "ONE SIZE", prInfoModel: prInfoModel1)
        
        var prSizes: [ProductSize] = []
        prSizes.append(prSize1)
        
        let prColor1 = ProductColor(color: "F5CB5C", prSizes: prSizes)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        
        let tags = ["diamond earrings", "belts", "teardrop drop earrings", "teardrop drop", "teardrop fringe drop earrings"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Belts.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
    
    /******************************************************************************************/
    
    class func belts4() -> Product {
        let uid = "123456-ACCESSORIES-004"
        let name = "6 CT Swiss Blue Topaz & 1/5 CT Diamond Earrings"
        let price: Double = 201.75
        let description = """
● Beaming with diamonds and crisp blue topaz, these drops are destined to brighten up any day. Crafted in cool 10K white gold, two pear-cut natural Swiss blue topaz totaling 6 ct are wrapped in round-cut diamonds totaling 1/5 ct. Pieces measure 7/8 by 1/4 inches.
"""
        
        var imgLinks: [String] = []
        beltsIMGLinks4.forEach({ imgLinks.append($0) })
        
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 0.0,
                                            imageLinks: imgLinks,
                                            description: description)
        
        let prSize1 = ProductSize(size: "ONE SIZE", prInfoModel: prInfoModel1)
        
        var prSizes: [ProductSize] = []
        prSizes.append(prSize1)
        
        let prColor1 = ProductColor(color: "65C8E5", prSizes: prSizes)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        
        let tags = ["diamond earrings", "belts", "teardrop drop earrings", "teardrop drop", "blue diamond earrings", "swiss blue topaz, diamond earrings"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Belts.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
    
    /******************************************************************************************/
    
    class func belts5() -> Product {
        let uid = "123456-ACCESSORIES-005"
        let name = "Stay All Day Shimmer Liquid Lipstick"
        let price: Double = 20.40
        let description = """
● A metallic liquid lipstick.
● Formulated with the same staying power, Stay All Day Shimmer Liquid Lipstick is a twist on Stila’s iconic Stay All Day Liquid Lipstick. With a metallic, shimmering finish, colour lips with a light wash of comfortable, non-drying sparkle.
"""
        
        var imgLinks: [String] = []
        beltsIMGLinks5.forEach({ imgLinks.append($0) })
        
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 0.0,
                                            imageLinks: imgLinks,
                                            description: description)
        
        let prSize1 = ProductSize(size: "NO", prInfoModel: prInfoModel1)
        
        var prSizes: [ProductSize] = []
        prSizes.append(prSize1)
        
        let prColor1 = ProductColor(color: "DD1B21", prSizes: prSizes)
        let prColor2 = ProductColor(color: "BA7470", prSizes: prSizes)
        let prColor3 = ProductColor(color: "AB346A", prSizes: prSizes)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        prColors.append(prColor2)
        prColors.append(prColor3)
        
        let tags = ["lipstick", "belts", "stay all day shimmer liquid lipstick"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Belts.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
    
    /******************************************************************************************/
    
    class func belts6() -> Product {
        let uid = "123456-ACCESSORIES-006"
        let name = "Little Twin Stars Liquid Lip Colour Set"
        let price: Double = 47.7
        let description = """
● Two super soft, creamy lip colours.
● Infused with celestial gold sparkles, Little Twin Stars Liquid Lip Colour Set is a unique duo ideal for adding a pop of colour to your look. Inspired by Japanese cartoon Little Twin Stars, this sparkling duo is guaranteed to have you shining as bright as Lala and Kiki.
"""
        
        var imgLinks: [String] = []
        beltsIMGLinks6.forEach({ imgLinks.append($0) })
        
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 10.0,
                                            imageLinks: imgLinks,
                                            description: description)
        
        let prSize1 = ProductSize(size: "NO", prInfoModel: prInfoModel1)
        
        var prSizes: [ProductSize] = []
        prSizes.append(prSize1)
        
        let prColor1 = ProductColor(color: "E5649D", prSizes: prSizes)
        let prColor2 = ProductColor(color: "19C2BF", prSizes: prSizes)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        prColors.append(prColor2)
        
        let tags = ["lipstick", "belts", "liquid lip", "little twin stars liquid lip colour set"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Belts.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
    
    /******************************************************************************************/
    
    class func belts7() -> Product {
        let uid = "123456-ACCESSORIES-007"
        let name = "Velour Liquid Lipstick Holiday Collection"
        let price: Double = 19.3
        let description = """
● A long-lasting liquid lipstick.
● With the same best-selling formula, Velour Liquid Lipstick Holiday Collection contains a choice of 8 seasonal colours. Applying smoothly and evenly, each shade dries to an opaque matte or metallic finish that lasts boldly throughout the day.
"""
        
        var imgLinks: [String] = []
        beltsIMGLinks7.forEach({ imgLinks.append($0) })
        
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 0.0,
                                            imageLinks: imgLinks,
                                            description: description)
        
        let prSize1 = ProductSize(size: "NO", prInfoModel: prInfoModel1)
        
        var prSizes: [ProductSize] = []
        prSizes.append(prSize1)
        
        let prColor1 = ProductColor(color: "752C52", prSizes: prSizes)
        let prColor2 = ProductColor(color: "9E8567", prSizes: prSizes)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        prColors.append(prColor2)
        
        let tags = ["lipstick", "belts", "liquid lip", "velour liquid lipstick holiday collection"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Belts.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
    
    /******************************************************************************************/
    
    class func belts8() -> Product {
        let uid = "123456-ACCESSORIES-008"
        let name = "Red Mini Bundle Sets"
        let price: Double = 63.9
        let description = """
● A collection of red and pink mini lipsticks.
● Packaged in a large matte box, Jeffree Star Red Mini Bundle Set features eight top-selling pink and red shades in handy travel sizes. Drying completely matte and lasting for hours, these lightweight lipsticks are highly pigmented and effortless to apply.
"""
        
        var imgLinks: [String] = []
        beltsIMGLinks8.forEach({ imgLinks.append($0) })
        
        let prInfoModel1 = ProductInfoModel(name: name,
                                            price: price,
                                            saleOff: 0.0,
                                            imageLinks: imgLinks,
                                            description: description)
        
        let prSize1 = ProductSize(size: "NO", prInfoModel: prInfoModel1)
        
        var prSizes: [ProductSize] = []
        prSizes.append(prSize1)
        
        let prColor1 = ProductColor(color: "520903", prSizes: prSizes)
        let prColor2 = ProductColor(color: "8F0006", prSizes: prSizes)
        let prColor3 = ProductColor(color: "C8150E", prSizes: prSizes)
        let prColor4 = ProductColor(color: "CB1456", prSizes: prSizes)
        let prColor5 = ProductColor(color: "DB2E4C", prSizes: prSizes)
        let prColor6 = ProductColor(color: "7C0A09", prSizes: prSizes)
        let prColor7 = ProductColor(color: "8D303B", prSizes: prSizes)
        let prColor8 = ProductColor(color: "993C57", prSizes: prSizes)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        prColors.append(prColor2)
        prColors.append(prColor3)
        prColors.append(prColor4)
        prColors.append(prColor5)
        prColors.append(prColor6)
        prColors.append(prColor7)
        prColors.append(prColor8)
        
        let tags = ["lipstick", "belts", "liquid lip", "red mini bundle sets"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Belts.rawValue,
                               tags: tags,
                               active: true)
        let pr = Product(prModel: prModel)
        return pr
    }
}
