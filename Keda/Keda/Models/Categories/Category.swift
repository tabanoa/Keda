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
            Category(name: categories[0], imageName: "hoodies"),
            Category(name: categories[1], imageName: "belts"),
            Category(name: categories[2], imageName: "shoes"),
            Category(name: categories[3], imageName: "watches"),
            Category(name: categories[4], imageName: "bags"),
            Category(name: categories[5], imageName: "jackets"),
            Category(name: categories[6], imageName: "shirts"),
            Category(name: categories[7], imageName: "shorts"),
            Category(name: categories[8], imageName: "pants"),
            Category(name: categories[9], imageName: "slides"),
            Category(name: categories[10], imageName: "lounge"),
            Category(name: categories[11], imageName: "collectables"),
        ]
    }
    
    class func fetchDataW() -> [Category] {
        return [
            Category(name: categories[0], imageName: "w-hoodies"),
            Category(name: categories[1], imageName: "w-belts"),
            Category(name: categories[2], imageName: "w-shoes"),
            Category(name: categories[3], imageName: "w-watches"),
            Category(name: categories[4], imageName: "w-bags"),
            Category(name: categories[5], imageName: "w-jackets"),
            Category(name: categories[6], imageName: "w-shirts"),
            Category(name: categories[7], imageName: "w-shorts"),
            Category(name: categories[8], imageName: "w-pants"),
            Category(name: categories[9], imageName: "w-slides"),
            Category(name: categories[10], imageName: "w-lounge"),
            Category(name: categories[11], imageName: "w-collectables"),
        ]
    }
    
    class func fetchCategories() -> [Category] {
        return [
            Category(name: categories[0], imageName: "icon-hoodies"),
            Category(name: categories[1], imageName: "icon-belts"),
            Category(name: categories[2], imageName: "icon-shoes"),
            Category(name: categories[3], imageName: "icon-watches"),
            Category(name: categories[4], imageName: "icon-bags"),
            Category(name: categories[5], imageName: "icon-jackets"),
            Category(name: categories[6], imageName: "icon-shirts"),
            Category(name: categories[7], imageName: "icon-shorts"),
            Category(name: categories[8], imageName: "icon-pants"),
            Category(name: categories[9], imageName: "icon-slides"),
            Category(name: categories[10], imageName: "icon-lounge"),
            Category(name: categories[11], imageName: "icon-collectables"),
        ]
    }
}
