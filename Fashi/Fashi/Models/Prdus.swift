//
//  Product.swift
//  Fashi
//
//  Created by Jack Ily on 29/03/2020.
//  Copyright © 2020 Jack Ily. All rights reserved.
//

import UIKit

enum Categories: String {
    case Clothing = "Clothing"
    case Accessories = "Accessories"
    case Shoes = "Shoes"
    case Watches = "Watches"
    case Bags = "Bags"
    case Dresses = "Dresses"
    case Lingerie = "Lingerie"
    case Men = "Men"
    case Kids = "Kids"
    case Skirts = "Skirts"
    case Sleepwear = "Sleepwear"
    case Swimwear = "Swimwear"
}

class Product {
    
    private let prModel: ProdModel
    
    var colorModelIndex = 0
    var sizeModelIndex = 0
    
    init(prModel: ProdModel) {
        self.prModel = prModel
    }
    
    var uid: String { return prModel.uid }
    var type: String { return prModel.type }
    var rating: Rating { return prModel.rating }
    var hashtag: [String] { return prModel.hashtag }
    
    var createdTime: String {
        let date = dateFormatter().date(from: prModel.createdTime)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy/HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    var colors: [UIColor] {
        var colors: [UIColor] = []
        prModel.colorModels.forEach({ colors.append($0.color) })
        return colors
    }
    
    var sizeModels: [SizeModel] {
        return prModel.colorModels[colorModelIndex].sizeModel
    }
    
    var sizes: [String] {
        var sizes: [String] = []
        sizeModels.forEach({ sizes.append($0.size) })
        return sizes
    }
    
    var name: String { return sizeModels[sizeModelIndex].prModel.name }
    var price: Double { return sizeModels[sizeModelIndex].prModel.price }
    var saleOff: Double { return sizeModels[sizeModelIndex].prModel.saleOff }
    var description: String { return sizeModels[sizeModelIndex].prModel.description }
    var images: [UIImage] { return sizeModels[sizeModelIndex].prModel.images }
    var shuffledImages: [UIImage] { return images.shuffled() }
    
    //MARK: - Clothing
    
    private class func clothing1() -> Product {
        let uid = "123456-CLOTHING-100"
        
        var imgs1 = [UIImage]()
        for i in 1...3 { imgs1.append(UIImage(named: "clothes1-\(i)")!) }
        let prModelS1 = PrModel(name: "Lace Up Sides Cheeky Shorts",
                                    price: 13.99,
                                    saleOff: 0.0,
                                    description: """
● Thick ponte knit scupts the hottest hot pants, featuring lace-up details at the sides! Shoe lace weaves through metal grommets at the sides for a lace-up illusion, while an elastic waistband tops the cheeky shape below!
""",
                                    images: imgs1)
        let sizeModel1 = SizeModel(size: "S", prModel: prModelS1)
        let sizeModel2 = SizeModel(size: "L", prModel: prModelS1)
        let sizeModel3 = SizeModel(size: "M", prModel: prModelS1)
        
        var sizeModels: [SizeModel] = []
        sizeModels.append(sizeModel1)
        sizeModels.append(sizeModel2)
        sizeModels.append(sizeModel3)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: .black, sizeModel: sizeModels)
        colorModels.append(colorModel1)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["overalls", "clothing", "shorts", "women", "skort", "lace up sides cheeky shorts"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Clothing.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    private class func clothing2() -> Product {
        let uid = "123456-CLOTHING-200"
        
        var imgs1 = [UIImage]()
        for i in 1...2 { imgs1.append(UIImage(named: "clothes2-\(i)")!) }
        let prModelS1 = PrModel(name: "Refuge Destroyed Denim Overalls",
                                    price: 15.99,
                                    saleOff: 5.0,
                                    description: """
● From our Refuge collection! Black denim rocks rips and tears to give these overalls a vintage feel! Metal button-up front attaches to adjustable straps that sweep into a classic back, while skinny legs taper into cute cuffs below. Four patch pockets and a handy coin slot offer a little storage to stash your stuff!
""",
                                    images: imgs1)
        let sizeModel1 = SizeModel(size: "S", prModel: prModelS1)
        let sizeModel2 = SizeModel(size: "L", prModel: prModelS1)
        let sizeModel3 = SizeModel(size: "M", prModel: prModelS1)
        
        var sizeModels: [SizeModel] = []
        sizeModels.append(sizeModel1)
        sizeModels.append(sizeModel2)
        sizeModels.append(sizeModel3)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: .black, sizeModel: sizeModels)
        colorModels.append(colorModel1)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["overalls", "clothing", "shorts", "women", "skort", "refuge destroyed denim overalls"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Clothing.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    private class func clothing3() -> Product {
        let uid = "123456-CLOTHING-300"
        
        var imgs1 = [UIImage]()
        for i in 1...2 { imgs1.append(UIImage(named: "clothes3-\(i)")!) }
        let prModelS1 = PrModel(name: "Front Tie Asymmetrical Skort",
                                    price: 12.99,
                                    saleOff: 0.0,
                                    description: """
● Online only! Thick, stretchy fabric forms sexy, short shorts with a twist! A single panel drapes across the front for a chic wrapped skirt illusion, while the narrow elastic waist boasts some serious high-waist style! Thick strings sweep through a metal grommet to form a chic bow adding a flirty touch to the look.
""",
                                    images: imgs1)
        let sizeModel1 = SizeModel(size: "S", prModel: prModelS1)
        let sizeModel2 = SizeModel(size: "L", prModel: prModelS1)
        let sizeModel3 = SizeModel(size: "M", prModel: prModelS1)
        
        var sizeModels: [SizeModel] = []
        sizeModels.append(sizeModel1)
        sizeModels.append(sizeModel2)
        sizeModels.append(sizeModel3)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: .black, sizeModel: sizeModels)
        colorModels.append(colorModel1)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["overalls", "clothing", "shorts", "women", "skort", "front tie asymmetrical skort"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Clothing.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    private class func clothing4() -> Product {
        let uid = "123456-CLOTHING-400"
        
        var imgs1 = [UIImage]()
        for i in 1...2 { imgs1.append(UIImage(named: "clothes4-\(i)")!) }
        let prModelS1 = PrModel(name: "Pleated Scuba Skater Skirt",
                                    price: 13.99,
                                    saleOff: 2.0,
                                    description: """
● Online only! Scuba knit sculpts this adorable mini-length skirt! Box pleats flare from a flat waistband into a full, skater silhouette for maximum volume.
""",
                                    images: imgs1)
        let sizeModel1 = SizeModel(size: "S", prModel: prModelS1)
        let sizeModel2 = SizeModel(size: "L", prModel: prModelS1)
        let sizeModel3 = SizeModel(size: "M", prModel: prModelS1)
        
        var sizeModels: [SizeModel] = []
        sizeModels.append(sizeModel1)
        sizeModels.append(sizeModel2)
        sizeModels.append(sizeModel3)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: UIColor(hex: 0x63A0CD), sizeModel: sizeModels)
        colorModels.append(colorModel1)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["overalls", "clothing", "shorts", "women", "skort", "pleated scuba skater skirt"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Clothing.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    //MARK: - Accessories
    
    private class func accessories1() -> Product {
        let uid = "123456-ACCESSORIES-100"
        
        var imgs1 = [UIImage]()
        for i in 1...3 { imgs1.append(UIImage(named: "accessories1-\(i)")!) }
        let prModelS1 = PrModel(name: "1 CT Diamond Swirl Stud Earrings",
                                    price: 1049.00,
                                    saleOff: 10.0,
                                    description: """
● These swirled studs are sure to stun! Crafted in 10K white gold, round-cut diamonds, totaling 1 ct, surround a central diamond for unforgettable shine. Pieces measure 7/16 by 7/16 inches.
""",
                                    images: imgs1)
        let sizeModel1 = SizeModel(size: "ONE SIZE", prModel: prModelS1)
        
        var sizeModels: [SizeModel] = []
        sizeModels.append(sizeModel1)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: UIColor(hex: 0x63A0CD), sizeModel: sizeModels)
        colorModels.append(colorModel1)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["diamond earrings", "accessories", "1 ct diamond swirl stud earrings"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Accessories.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    private class func accessories2() -> Product {
        let uid = "123456-ACCESSORIES-200"
        
        var imgs1 = [UIImage]()
        for i in 1...3 { imgs1.append(UIImage(named: "accessories2-\(i)")!) }
        let prModelS1 = PrModel(name: "12-16 MM Pink Ming Pearl Strand Necklace, 20 Inch",
                                price: 696.75,
                                saleOff: 5.0,
                                description: """
● A bold, yet subdued, pearl strand to elevate any outfit in your closet! Pink Ming freshwater pearls, ranging in size from 12 mm to 16 mm, decorate the strand while a 14K gold bead featuring a box-with-tongue clasp holds the piece together. Piece measures 20 inches by 1/2 inches.
""",
                                images: imgs1)
        let sizeModel1 = SizeModel(size: "ONE SIZE", prModel: prModelS1)
        
        var sizeModels: [SizeModel] = []
        sizeModels.append(sizeModel1)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: UIColor(hex: 0xD1AFA4), sizeModel: sizeModels)
        colorModels.append(colorModel1)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["diamond earrings", "accessories", "pink pearl strand necklace", "12-16 mm pink ming pearl strand necklace, 20 inch"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Accessories.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    private class func accessories3() -> Product {
        let uid = "123456-ACCESSORIES-300"
        
        var imgs1 = [UIImage]()
        for i in 1...3 { imgs1.append(UIImage(named: "accessories3-\(i)")!) }
        let prModelS1 = PrModel(name: "Teardrop Fringe Drop Earrings",
                                price: 179.25,
                                saleOff: 5.0,
                                description: """
● Get in on the statement earring trend with these beaded drops. Crafted in a classic teardrop shape, multiple beads suspend from each base and open center of either earring, designed in 10K gold. Pieces measure 2 by 3/4 inches.
""",
                                images: imgs1)
        let sizeModel1 = SizeModel(size: "ONE SIZE", prModel: prModelS1)
        
        var sizeModels: [SizeModel] = []
        sizeModels.append(sizeModel1)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: UIColor(hex: 0xD1AFA4), sizeModel: sizeModels)
        colorModels.append(colorModel1)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["diamond earrings", "accessories", " teardrop drop earrings", "teardrop drop", "teardrop fringe drop earrings"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Accessories.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    private class func accessories4() -> Product {
        let uid = "123456-ACCESSORIES-400"
        
        var imgs1 = [UIImage]()
        for i in 1...3 { imgs1.append(UIImage(named: "accessories4-\(i)")!) }
        let prModelS1 = PrModel(name: "6 CT Swiss Blue Topaz & 1/5 CT Diamond Earrings",
                                price: 201.75,
                                saleOff: 0.0,
                                description: """
● Beaming with diamonds and crisp blue topaz, these drops are destined to brighten up any day. Crafted in cool 10K white gold, two pear-cut natural Swiss blue topaz totaling 6 ct are wrapped in round-cut diamonds totaling 1/5 ct. Pieces measure 7/8 by 1/4 inches.
""",
                                images: imgs1)
        let sizeModel1 = SizeModel(size: "ONE SIZE", prModel: prModelS1)
        
        var sizeModels: [SizeModel] = []
        sizeModels.append(sizeModel1)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: UIColor(hex: 0x65C8E5), sizeModel: sizeModels)
        colorModels.append(colorModel1)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["diamond earrings", "accessories", "teardrop drop earrings", "teardrop drop", "blue diamond earrings", "6 ct swiss blue topaz & 1/5 ct diamond earrings"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Accessories.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    private class func accessories5() -> Product {
        let uid = "123456-ACCESSORIES-500"
        
        var imgs1 = [UIImage]()
        for i in 1...5 { imgs1.append(UIImage(named: "accessories5-\(i)")!) }
        let prModelS1 = PrModel(name: "Stay All Day Shimmer Liquid Lipstick",
                                price: 20.40,
                                saleOff: 0.0,
                                description: """
● A metallic liquid lipstick.
● Formulated with the same staying power, Stay All Day Shimmer Liquid Lipstick is a twist on Stila’s iconic Stay All Day Liquid Lipstick. With a metallic, shimmering finish, colour lips with a light wash of comfortable, non-drying sparkle.
""",
                                images: imgs1)
        let sizeModel1 = SizeModel(size: "NO", prModel: prModelS1)
        
        var sizeModels: [SizeModel] = []
        sizeModels.append(sizeModel1)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: UIColor(hex: 0xDD1B21), sizeModel: sizeModels)
        let colorModel2 = ColorModel(color: UIColor(hex: 0xBA7470), sizeModel: sizeModels)
        let colorModel3 = ColorModel(color: UIColor(hex: 0xAB346A), sizeModel: sizeModels)
        colorModels.append(colorModel1)
        colorModels.append(colorModel2)
        colorModels.append(colorModel3)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["lipstick", "accessories", "stay all day shimmer liquid lipstick"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Accessories.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    private class func accessories6() -> Product {
        let uid = "123456-ACCESSORIES-600"
        
        var imgs1 = [UIImage]()
        for i in 1...5 { imgs1.append(UIImage(named: "accessories6-\(i)")!) }
        let prModelS1 = PrModel(name: "Little Twin Stars Liquid Lip Colour Set",
                                price: 47.70,
                                saleOff: 10.0,
                                description: """
● Two super soft, creamy lip colours.
● Infused with celestial gold sparkles, Little Twin Stars Liquid Lip Colour Set is a unique duo ideal for adding a pop of colour to your look. Inspired by Japanese cartoon Little Twin Stars, this sparkling duo is guaranteed to have you shining as bright as Lala and Kiki.
""",
                                images: imgs1)
        let sizeModel1 = SizeModel(size: "NO", prModel: prModelS1)
        
        var sizeModels: [SizeModel] = []
        sizeModels.append(sizeModel1)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: UIColor(hex: 0xE5649D), sizeModel: sizeModels)
        let colorModel2 = ColorModel(color: UIColor(hex: 0x19C2BF), sizeModel: sizeModels)
        colorModels.append(colorModel1)
        colorModels.append(colorModel2)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["lipstick", "accessories", "liquid lip", "little twin stars liquid lip colour set"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Accessories.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    private class func accessories7() -> Product {
        let uid = "123456-ACCESSORIES-700"
        
        var imgs1 = [UIImage]()
        for i in 1...5 { imgs1.append(UIImage(named: "accessories7-\(i)")!) }
        let prModelS1 = PrModel(name: "Velour Liquid Lipstick Holiday Collection",
                                price: 19.30,
                                saleOff: 0.0,
                                description: """
● A long-lasting liquid lipstick.
● With the same best-selling formula, Velour Liquid Lipstick Holiday Collection contains a choice of 8 seasonal colours. Applying smoothly and evenly, each shade dries to an opaque matte or metallic finish that lasts boldly throughout the day.
""",
                                images: imgs1)
        let sizeModel1 = SizeModel(size: "NO", prModel: prModelS1)
        
        var sizeModels: [SizeModel] = []
        sizeModels.append(sizeModel1)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: UIColor(hex: 0x752C52), sizeModel: sizeModels)
        let colorModel2 = ColorModel(color: UIColor(hex: 0x9E8567), sizeModel: sizeModels)
        colorModels.append(colorModel1)
        colorModels.append(colorModel2)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["lipstick", "accessories", "liquid lip", "velour liquid lipstick holiday collection"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Accessories.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    private class func accessories8() -> Product {
        let uid = "123456-ACCESSORIES-800"
        
        var imgs1 = [UIImage]()
        for i in 1...4 { imgs1.append(UIImage(named: "accessories8-\(i)")!) }
        let prModelS1 = PrModel(name: "Red Mini Bundle Sets",
                                price: 63.90,
                                saleOff: 0.0,
                                description: """
● A collection of red and pink mini lipsticks.
● Packaged in a large matte box, Jeffree Star Red Mini Bundle Set features eight top-selling pink and red shades in handy travel sizes. Drying completely matte and lasting for hours, these lightweight lipsticks are highly pigmented and effortless to apply.
""",
                                images: imgs1)
        let sizeModel1 = SizeModel(size: "NO", prModel: prModelS1)
        
        var sizeModels: [SizeModel] = []
        sizeModels.append(sizeModel1)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: UIColor(hex: 0x520903), sizeModel: sizeModels)
        let colorModel2 = ColorModel(color: UIColor(hex: 0x8F0006), sizeModel: sizeModels)
        let colorModel3 = ColorModel(color: UIColor(hex: 0xC8150E), sizeModel: sizeModels)
        let colorModel4 = ColorModel(color: UIColor(hex: 0xCB1456), sizeModel: sizeModels)
        let colorModel5 = ColorModel(color: UIColor(hex: 0xDB2E4C), sizeModel: sizeModels)
        let colorModel6 = ColorModel(color: UIColor(hex: 0x7C0A09), sizeModel: sizeModels)
        let colorModel7 = ColorModel(color: UIColor(hex: 0x8D303B), sizeModel: sizeModels)
        let colorModel8 = ColorModel(color: UIColor(hex: 0x993C57), sizeModel: sizeModels)
        colorModels.append(colorModel1)
        colorModels.append(colorModel2)
        colorModels.append(colorModel3)
        colorModels.append(colorModel4)
        colorModels.append(colorModel5)
        colorModels.append(colorModel6)
        colorModels.append(colorModel7)
        colorModels.append(colorModel8)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["lipstick", "accessories", "liquid lip", "red mini bundle sets"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Accessories.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    //MARK: - Shoes
    
    private class func shoes1() -> Product {
        let uid = "123456-SHOES-100"
        let price: Double = 150.99
        let name = "Nike Air Max 270"
        let description = """
● The Nike Air Max 270 Men's Shoe is inspired by two icons of big Air: the Air Max 180 and Air Max 93. It features Nike’s biggest heel Air unit yet for a super-soft ride that feels as impossible as it looks.
"""
        var imgs1 = [UIImage]()
        for i in 1...4 { imgs1.append(UIImage(named: "shoes1-\(i)")!) }
        let prModelS1 = PrModel(name: name,
                                price: price,
                                saleOff: 5.0,
                                description: description,
                                images: imgs1)
        let sizeModel1_1 = SizeModel(size: "EU 35.5", prModel: prModelS1)
        let sizeModel1_2 = SizeModel(size: "EU 36", prModel: prModelS1)
        let sizeModel1_3 = SizeModel(size: "EU 36.5", prModel: prModelS1)
        let sizeModel1_4 = SizeModel(size: "EU 37.5", prModel: prModelS1)
        
        var imgs2 = [UIImage]()
        for i in 1...4 { imgs2.append(UIImage(named: "shoes2-\(i)")!) }
        let prModelS2 = PrModel(name: name,
                                price: price,
                                saleOff: 0.0,
                                description: description,
                                images: imgs2)
        let sizeModel2_1 = SizeModel(size: "EU 35.5", prModel: prModelS2)
        let sizeModel2_2 = SizeModel(size: "EU 36", prModel: prModelS2)
        let sizeModel2_3 = SizeModel(size: "EU 36.5", prModel: prModelS2)
        let sizeModel2_4 = SizeModel(size: "EU 37.5", prModel: prModelS2)
        
        var sizeModels1: [SizeModel] = []
        sizeModels1.append(sizeModel1_1)
        sizeModels1.append(sizeModel1_2)
        sizeModels1.append(sizeModel1_3)
        sizeModels1.append(sizeModel1_4)
        
        var sizeModels2: [SizeModel] = []
        sizeModels2.append(sizeModel2_1)
        sizeModels2.append(sizeModel2_2)
        sizeModels2.append(sizeModel2_3)
        sizeModels2.append(sizeModel2_4)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: UIColor(hex: 0x2757A9), sizeModel: sizeModels1)
        let colorModel2 = ColorModel(color: .white, sizeModel: sizeModels2)
        colorModels.append(colorModel1)
        colorModels.append(colorModel2)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["shoes", "nike", "men", "nike air max 270"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Shoes.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    private class func shoes2() -> Product {
        let uid = "123456-SHOES-200"
        var imgs1 = [UIImage]()
        for i in 1...6 { imgs1.append(UIImage(named: "shoes3-\(i)")!) }
        let prModelS1 = PrModel(name: "Nike Epic React Flyknit",
                                price: 150.0,
                                saleOff: 0.0,
                                description: """
● The Nike Epic React Flyknit Men's Running Shoe provides crazy comfort that lasts as long as you can run. Its Nike React foam cushioning is responsive yet lightweight, durable yet soft. This attraction of opposites creates a sensation that not only enhances the feeling of moving forward, but makes running feel fun, too.
""",
                                images: imgs1)
        let sizeModel1_1 = SizeModel(size: "EU 35.5", prModel: prModelS1)
        let sizeModel1_2 = SizeModel(size: "EU 36", prModel: prModelS1)
        let sizeModel1_3 = SizeModel(size: "EU 36.5", prModel: prModelS1)
        let sizeModel1_4 = SizeModel(size: "EU 37.5", prModel: prModelS1)
        
        var sizeModels1: [SizeModel] = []
        sizeModels1.append(sizeModel1_1)
        sizeModels1.append(sizeModel1_2)
        sizeModels1.append(sizeModel1_3)
        sizeModels1.append(sizeModel1_4)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: UIColor(hex: 0x46B2D6), sizeModel: sizeModels1)
        colorModels.append(colorModel1)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["shoes", "nike", "men", "nike epic react flyknit"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Shoes.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    private class func shoes3() -> Product {
        let uid = "123456-SHOES-300"
        var imgs1 = [UIImage]()
        for i in 1...7 { imgs1.append(UIImage(named: "shoes4-\(i)")!) }
        let prModelS1 = PrModel(name: "Nike Free Rn Flyknit",
                                price: 150.0,
                                saleOff: 0.0,
                                description: """
● The Nike Free RN Flyknit 2017 Men's Running Shoe brings you miles of comfort with an exceptionally flexible outsole for the ultimate natural ride. Flyknit fabric wraps your foot for a snug, supportive fit while a tri-star outsole expands and flexes to let your foot move naturally.
""",
                                images: imgs1)
        let sizeModel1_1 = SizeModel(size: "EU 35.5", prModel: prModelS1)
        let sizeModel1_2 = SizeModel(size: "EU 36", prModel: prModelS1)
        let sizeModel1_3 = SizeModel(size: "EU 36.5", prModel: prModelS1)
        let sizeModel1_4 = SizeModel(size: "EU 37.5", prModel: prModelS1)
        
        var sizeModels1: [SizeModel] = []
        sizeModels1.append(sizeModel1_1)
        sizeModels1.append(sizeModel1_2)
        sizeModels1.append(sizeModel1_3)
        sizeModels1.append(sizeModel1_4)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: UIColor(hex: 0xA1A0A8), sizeModel: sizeModels1)
        colorModels.append(colorModel1)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["shoes", "nike", "men", "nike free rn flyknit"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Shoes.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    //MARK: - Watches
    
    private class func watches1() -> Product {
        let uid = "123456-WATCHES-100"
        
        var imgs1 = [UIImage]()
        for i in 1...3 { imgs1.append(UIImage(named: "watches1-\(i)")!) }
        let prModelS1 = PrModel(name: "Bulova",
                                price: 395.00,
                                saleOff: 50.0,
                                description: """
● Gender - Mens
● The Bulova, American Clipper series features a stainless steel 42mm case, with a fixed bezel, a black (skeletal window) dial and a scratch resistant mineral crystal.
● Sub-dials: small seconds.
● The 20mm leather band is fitted with a tang clasp.
● This beautiful wristwatch, powered by automatic movement supporting: hour, minute, second functions.
● This watch has a water resistance of up to 100 feet/30 meters, suitable for short periods of recreational swimming.
● This stylish timepiece is sure to complete any man's collection.
""",
                                images: imgs1)
        let sizeModel1 = SizeModel(size: "42MM", prModel: prModelS1)
        
        var sizeModels: [SizeModel] = []
        sizeModels.append(sizeModel1)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: .black, sizeModel: sizeModels)
        colorModels.append(colorModel1)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["watches men", "watches women", "accessories", "apple watch", "watch", "bulova"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Watches.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    private class func watches2() -> Product {
        let uid = "123456-WATCHES-200"
        
        var imgs1 = [UIImage]()
        imgs1.append(UIImage(named: "watches2-1")!)
        let prModelS1 = PrModel(name: "Zeno",
                                price: 950.00,
                                saleOff: 43.0,
                                description: """
● Gender - Mens
● The ZenoThe Watch features a stainless steel 48mm case, with a black uni-directional rotating bezel, a black dial and a scratch resistant sapphire crystal.
● The 24mm rubber band is fitted with a tang clasp.
● This beautiful wristwatch, powered by Swiss automatic movement supporting: date, hour, minute, second functions.
● This watch has a water resistance of up to 165 feet/50 meters, suitable for short periods of recreational swimming, but not diving or snorkeling.
● This stylish Swiss-made timepiece is sure to complete any man's collection.
""",
                                images: imgs1)
        let sizeModel1 = SizeModel(size: "48MM", prModel: prModelS1)
        
        var sizeModels: [SizeModel] = []
        sizeModels.append(sizeModel1)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: .black, sizeModel: sizeModels)
        colorModels.append(colorModel1)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["watches men", "watches women", "accessories", "apple watch", "watch", "zeno"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Watches.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    private class func watches3() -> Product {
        let uid = "123456-WATCHES-300"
        
        var imgs1 = [UIImage]()
        for i in 1...3 { imgs1.append(UIImage(named: "watches3-\(i)")!) }
        let prModelS1 = PrModel(name: "Vulcain",
                                price: 3450.00,
                                saleOff: 63.0,
                                description: """
● Gender - Womens
● The Vulcain, First Lady series features a stainless steel 37.60mmx32.10mm case, with a fixed bezel, a mother of pearl dial and a scratch resistant sapphire crystal.
● The satin band is fitted with a tang clasp.
● This beautiful wristwatch, powered by a Vulcain Calibre V-61, Swiss automatic movement, supporting: date, hour, minute, second functions.
● This watch has a water resistance of up to 100 feet/30 meters, suitable for short periods of recreational swimming.
● This stylish Swiss-made timepiece is sure to complete any woman's collection.
""",
                                images: imgs1)
        let sizeModel1 = SizeModel(size: "37.60MM X 32.10MM", prModel: prModelS1)
        
        var sizeModels: [SizeModel] = []
        sizeModels.append(sizeModel1)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: .black, sizeModel: sizeModels)
        colorModels.append(colorModel1)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["watches men", "watches women", "accessories", "apple watch", "watch", "vulcain"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Watches.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    private class func watches4() -> Product {
        let uid = "123456-WATCHES-400"
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
        
        var imgs1 = [UIImage]()
        for i in 1...3 { imgs1.append(UIImage(named: "watches4-40g-\(i)")!) }
        let prModelS1 = PrModel(name: "Apple Watch Series 5 (GPS, 40mm) - Gold Aluminum Case with Pink Sport Band",
                                price: 399.0,
                                saleOff: 0.0,
                                description: des,
                                images: imgs1)
        let sizeModel1 = SizeModel(size: "40MM", prModel: prModelS1)
        
        let prModelS2 = PrModel(name: "Apple Watch Series 5 (GPS, 44mm) - Gold Aluminum Case with Pink Sport Band",
                                price: 429.00,
                                saleOff: 0.0,
                                description: des,
                                images: imgs1)
        let sizeModel2 = SizeModel(size: "44MM", prModel: prModelS2)
        
        var imgs2 = [UIImage]()
        for i in 1...3 { imgs2.append(UIImage(named: "watches4-40sg-\(i)")!) }
        let prModelS3 = PrModel(name: "Apple Watch Series 5 (GPS, 40mm) - Space Gray Aluminum Case with Black Sport Band",
                                price: 399.0,
                                saleOff: 0.0,
                                description: des,
                                images: imgs2)
        let sizeModel3 = SizeModel(size: "40MM", prModel: prModelS3)
        
        let prModelS4 = PrModel(name: "Apple Watch Series 5 (GPS, 44mm) - Space Gray Aluminum Case with Black Sport Band",
                                price: 429.00,
                                saleOff: 0.0,
                                description: des,
                                images: imgs2)
        let sizeModel4 = SizeModel(size: "44MM", prModel: prModelS4)
        
        var imgs3 = [UIImage]()
        for i in 1...3 { imgs3.append(UIImage(named: "watches4-40w-\(i)")!) }
        let prModelS5 = PrModel(name: "Apple Watch Series 5 (GPS, 40mm) - Silver Aluminum Case with White Sport Band",
                                price: 399.0,
                                saleOff: 0.0,
                                description: des,
                                images: imgs3)
        let sizeModel5 = SizeModel(size: "40MM", prModel: prModelS5)
        
        let prModelS6 = PrModel(name: "Apple Watch Series 5 (GPS, 44mm) - Silver Aluminum Case with White Sport Band",
                                price: 429.00,
                                saleOff: 0.0,
                                description: des,
                                images: imgs3)
        let sizeModel6 = SizeModel(size: "44MM", prModel: prModelS6)
        
        var sizeModels1: [SizeModel] = []
        sizeModels1.append(sizeModel1)
        sizeModels1.append(sizeModel2)
        
        var sizeModels2: [SizeModel] = []
        sizeModels2.append(sizeModel3)
        sizeModels2.append(sizeModel4)
        
        var sizeModels3: [SizeModel] = []
        sizeModels3.append(sizeModel5)
        sizeModels3.append(sizeModel6)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: UIColor(hex: 0xEEC0B4), sizeModel: sizeModels1)
        let colorModel2 = ColorModel(color: UIColor(hex: 0x3D3938), sizeModel: sizeModels2)
        let colorModel3 = ColorModel(color: .white, sizeModel: sizeModels3)
        colorModels.append(colorModel1)
        colorModels.append(colorModel2)
        colorModels.append(colorModel3)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["watches men", "watches women", "accessories", "apple watch", "watch", "apple watch 44mm", "apple watch 40mm", "apple watch pink", "apple watch white", "apple watch black", "apple watch series 5 gps, 40mm pink", "apple watch series 5 gps, 44mm pink", "apple watch series 5 gps, 40mm black", "apple watch series 5 gps, 44mm black", "apple watch series 5 gps, 40mm white", "apple watch series 5 gps, 44mm white"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Watches.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    private class func bags1() -> Product {
        let uid = "123456-BAGS-100"
        
        var imgs1 = [UIImage]()
        for i in 1...6 { imgs1.append(UIImage(named: "bags1-\(i)")!) }
        let prModelS1 = PrModel(name: "Salvatore Ferragamo",
                                price: 2200.0,
                                saleOff: 28.0,
                                description: """
● Ferragamo Studio Bag crafted in calfskin leather with gold-tone metal hardware.
● This shoulder bag features 1 main compartment, removable pouch, gold metal feet studs and crossbody straps.
● DiMen'sions: H:9.8" x L:11.4" x W:5.7".
● Style: Shoulder Bag
""",
                                images: imgs1)
        let size = """
H:9.8" X L:11.4" X W:5.7"
"""
        let sizeModel1 = SizeModel(size: size, prModel: prModelS1)
        var sizeModels: [SizeModel] = []
        sizeModels.append(sizeModel1)
        
        var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: UIColor(hex: 0xAC6060), sizeModel: sizeModels)
        colorModels.append(colorModel1)
        
        var ratingModels = [RatingModel]()
        appendRating(&ratingModels,
                     ran1: Int.random(10)+1,
                     ran2: Int.random(10)+1,
                     ran3: Int.random(50)+1,
                     ran4: Int.random(1000)+1,
                     ran5: Int.random(1000)+1)
        let rating = Rating(prUID: uid, ratingModels: ratingModels)
        let hashtag = ["bags woment", "bags", "accessories", "salvatore ferragamo"]
        
        let productModel = ProdModel(uid: uid,
                                     colorModels: colorModels,
                                     createdTime: createTime(),
                                     type: Categories.Bags.rawValue,
                                     hashtag: hashtag,
                                     rating: rating)
        let product = Product(prModel: productModel)
        return product
    }
    
    private class func bags2() -> Product {
            let uid = "123456-BAGS-200"
            
            var imgs1 = [UIImage]()
            for i in 1...5 { imgs1.append(UIImage(named: "bags2-\(i)")!) }
            let prModelS1 = PrModel(name: "Chloe",
                                    price: 1880.98,
                                    saleOff: 0.0,
                                    description: """
● Chloe Small Aby Day shoulder bag crafted in grained / shiny calfskin with cotton canvas lining and gold-tone metal hardware.
● This shoulder bag features 2 main compartments, 1 center zip pocket, 1 flat leather pocket and a adjustable / removable long leather strap with a 18.9"- 21.7" drop.
● Short strap length: 14 cm / 5.5".
● DiMen'sions: W: 9.4" x H: 8.7" x D: 4.3".
● Style: Shoulder Bag
""",
                                    images: imgs1)
            let size = """
W:9.4" X H:8.7" X D:4.3"
"""
            let sizeModel1 = SizeModel(size: size, prModel: prModelS1)
            var sizeModels: [SizeModel] = []
            sizeModels.append(sizeModel1)
            
            var colorModels: [ColorModel] = []
        let colorModel1 = ColorModel(color: .white, sizeModel: sizeModels)
            colorModels.append(colorModel1)
            
            var ratingModels = [RatingModel]()
            appendRating(&ratingModels,
                         ran1: Int.random(10)+1,
                         ran2: Int.random(10)+1,
                         ran3: Int.random(50)+1,
                         ran4: Int.random(1000)+1,
                         ran5: Int.random(1000)+1)
            let rating = Rating(prUID: uid, ratingModels: ratingModels)
            let hashtag = ["bags woment", "bags", "accessories", "chloe"]
            
            let productModel = ProdModel(uid: uid,
                                         colorModels: colorModels,
                                         createdTime: createTime(),
                                         type: Categories.Bags.rawValue,
                                         hashtag: hashtag,
                                         rating: rating)
            let product = Product(prModel: productModel)
            return product
        }
    
    class func sharedInstance() -> [Product] {
        var prdus: [Product] = []
        prdus.append(clothing1())
        prdus.append(clothing2())
        prdus.append(clothing3())
        prdus.append(clothing4())
        
        prdus.append(accessories1())
        prdus.append(accessories2())
        prdus.append(accessories3())
        prdus.append(accessories4())
        prdus.append(accessories5())
        prdus.append(accessories6())
        prdus.append(accessories7())
        prdus.append(accessories8())
        
        prdus.append(shoes1())
        prdus.append(shoes2())
        prdus.append(shoes3())
        
        prdus.append(watches1())
        prdus.append(watches2())
        prdus.append(watches3())
        prdus.append(watches4())
        
        prdus.append(bags1())
        prdus.append(bags2())
        
        return prdus
    }
}

func appendRating(_ ratingModels: inout [RatingModel], ran1: Int, ran2: Int, ran3: Int, ran4: Int, ran5: Int) {
    let ratingRan1 = RatingModel(userCount: ran1, rating: 1)
    let ratingRan2 = RatingModel(userCount: ran2, rating: 2)
    let ratingRan3 = RatingModel(userCount: ran3, rating: 3)
    let ratingRan4 = RatingModel(userCount: ran4, rating: 4)
    let ratingRan5 = RatingModel(userCount: ran5, rating: 5)
    ratingModels.append(ratingRan1)
    ratingModels.append(ratingRan2)
    ratingModels.append(ratingRan3)
    ratingModels.append(ratingRan4)
    ratingModels.append(ratingRan5)
}

func generateRandomDate() -> Date? {
    let day = Int.random(29)
    let month = Int.random(3)
    let hour = Int.random(23)
    let minute = Int.random(59)
    let second = Int.random(59)
    
    let today = Date(timeIntervalSinceNow: 0)
    let gregorian = NSCalendar(calendarIdentifier: .gregorian)
    let calendar = NSCalendar.current
    let component = calendar.dateComponents([.year], from: Date())
    var offsetComponents = DateComponents()
    offsetComponents.day = -1 * Int(day)
    offsetComponents.month = -1 * Int(month)
    offsetComponents.year = component.year
    offsetComponents.hour = -1 * Int(hour)
    offsetComponents.minute = -1 * Int(minute)
    offsetComponents.second = -1 * Int(second)
    return gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0))
}

func createTime() -> String {
    return dateFormatter().string(from: generateRandomDate()!)
}

extension Product: Equatable {}
func ==(lhs: Product, rhs: Product) -> Bool {
    return lhs.uid == rhs.uid
}
