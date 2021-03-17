//
//  Category.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class Category {
    
    var name: String
    var imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
    
    class func fetchDataC() -> [Category] {
        return [
            Category(name: categories[0], imageName: "clothing"),
            Category(name: categories[1], imageName: "accessories"),
            Category(name: categories[2], imageName: "shoes"),
            Category(name: categories[3], imageName: "watches"),
            Category(name: categories[4], imageName: "bags"),
            Category(name: categories[5], imageName: "dresses"),
            Category(name: categories[6], imageName: "lingerie"),
            Category(name: categories[7], imageName: "men"),
            Category(name: categories[8], imageName: "kids"),
            Category(name: categories[9], imageName: "skirts"),
            Category(name: categories[10], imageName: "sleepwear"),
            Category(name: categories[11], imageName: "swimwear"),
        ]
    }
    
    class func fetchDataW() -> [Category] {
        return [
            Category(name: categories[0], imageName: "w-clothing"),
            Category(name: categories[1], imageName: "w-accessories"),
            Category(name: categories[2], imageName: "w-shoes"),
            Category(name: categories[3], imageName: "w-watches"),
            Category(name: categories[4], imageName: "w-bags"),
            Category(name: categories[5], imageName: "w-dresses"),
            Category(name: categories[6], imageName: "w-lingerie"),
            Category(name: categories[7], imageName: "w-men"),
            Category(name: categories[8], imageName: "w-kids"),
            Category(name: categories[9], imageName: "w-skirts"),
            Category(name: categories[10], imageName: "w-sleepwear"),
            Category(name: categories[11], imageName: "w-swimwear"),
        ]
    }
    
    class func fetchCategories() -> [Category] {
        return [
            Category(name: categories[0], imageName: "icon-clothing"),
            Category(name: categories[1], imageName: "icon-accessories"),
            Category(name: categories[2], imageName: "icon-shoes"),
            Category(name: categories[3], imageName: "icon-watches"),
            Category(name: categories[4], imageName: "icon-bags"),
            Category(name: categories[5], imageName: "icon-dresses"),
            Category(name: categories[6], imageName: "icon-lingerie"),
            Category(name: categories[7], imageName: "icon-men"),
            Category(name: categories[8], imageName: "icon-kids"),
            Category(name: categories[9], imageName: "icon-skirts"),
            Category(name: categories[10], imageName: "icon-sleepwear"),
            Category(name: categories[11], imageName: "icon-swimwear"),
        ]
    }
}
