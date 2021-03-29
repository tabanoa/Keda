//
//  Copies.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class Copies {
    
    var images: [UIImage]
    var name: String
    var price: Double
    var description: String
    var saleOff: Double
    var tags: [String]
    
    init(images: [UIImage], name: String, price: Double, description: String, saleOff: Double, tags: [String]) {
        self.images = images
        self.name = name
        self.price = price
        self.description = description
        self.saleOff = saleOff
        self.tags = tags
    }
}
