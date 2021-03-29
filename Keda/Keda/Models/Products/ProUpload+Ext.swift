//
//  ProUpload+Ext.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import Foundation

let beltsIMGLinks9: [String] = [
    "https://i.imgur.com/KIK0mbz.jpg",
    "https://i.imgur.com/TGgFL2V.jpg",
    "https://i.imgur.com/7mJHm4s.jpg",
    "https://i.imgur.com/E8wJ4c0.jpg"
]

let beltsIMGLinks10: [String] = [
    "https://i.imgur.com/Kx6kbbC.jpg",
    "https://i.imgur.com/BHKrr43.jpg",
    "https://i.imgur.com/Yg8jjfK.jpg",
    "https://i.imgur.com/2YpeZE3.jpg",
    "https://i.imgur.com/vgxySuC.jpg"
]

extension Product {
    
    class func airPod1() -> Product {
        let uid = "123456-ACCESSORIES-009"
        let name1 = "Apple Airpods With Charging Case"
        let price1: Double = 159.0
        let saleOff1: Double = 0.0
        let size1 = "AIDPODS 2"
        let des1 = """
● Automatically on, automatically connected
● Easy setup for all your Apple devices
● Quick access to Siri by saying “Hey Siri”
● Double-tap to play or skip forward
● New Apple H1 headphone chip delivers faster wireless connection to your devices
● Charges quickly in the case
● Case can be charged using the Lightning connector
"""
        let name2 = "Apple AirPods Pro"
        let price2: Double = 249.0
        let saleOff2: Double = 0.0
        let size2 = "AIDPODS PRO"
        let des2 = """
● Active noise cancellation for immersive sound
● Transparency mode for hearing and connecting with the world around you
● Three sizes of soft, tapered silicone tips for a customizable fit
● Sweat and water resistant
● Adaptive EQ automatically tunes music to the shape of your ear
● Easy setup for all your Apple devices
● Quick access to Siri by saying “Hey Siri”
● The Wireless Charging Case delivers more than 24 hours of battery life
"""
        
        //TODO: - White
        var imgLinks1: [String] = []
        beltsIMGLinks9.forEach({ imgLinks1.append($0) })
        let prInfoModel1 = ProductInfoModel(name: name1,
                                            price: price1,
                                            saleOff: saleOff1,
                                            imageLinks: imgLinks1,
                                            description: des1)
        let prSize1 = ProductSize(size: size1, prInfoModel: prInfoModel1)
        
        var imgLinks2: [String] = []
        beltsIMGLinks10.forEach({ imgLinks2.append($0) })
        let prInfoModel2 = ProductInfoModel(name: name2,
                                            price: price2,
                                            saleOff: saleOff2,
                                            imageLinks: imgLinks2,
                                            description: des2)
        let prSize2 = ProductSize(size: size2, prInfoModel: prInfoModel2)
        
        var prSizes1: [ProductSize] = []
        prSizes1.append(prSize1)
        prSizes1.append(prSize2)
        
        let prColor1 = ProductColor(color: "FFFFFF", prSizes: prSizes1)
        
        var prColors: [ProductColor] = []
        prColors.append(prColor1)
        
        let tags: [String] = ["apple airpods", "airpods pro", "belts", "headphone", "headphone bluetooth", "wireless headphones", "apple"]
        let prModel = ProModel(uid: uid,
                               createdTime: createTime(),
                               prColors: prColors,
                               type: Categories.Belts.rawValue,
                               tags: tags,
                               active: false)
        let pr = Product(prModel: prModel)
        return pr
    }
}
