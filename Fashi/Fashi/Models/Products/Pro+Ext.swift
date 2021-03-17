//
//  Pro+Ext.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Firebase

extension Product {
    
    class func clothing(_ prs: [Product]) -> [Product] {
        var products = [Product]()
        for pr in prs {
            if pr.type == Categories.Clothing.rawValue {
                if !products.contains(pr) {
                    products.append(pr)
                }
            }
        }
        
        return products.kShuffled
    }
    
    class func accessories(_ prs: [Product]) -> [Product] {
        var products = [Product]()
        for pr in prs {
            if pr.type == Categories.Accessories.rawValue {
                if !products.contains(pr) {
                    products.append(pr)
                }
            }
        }
        
        return products.kShuffled
    }
    
    class func shoes(_ prs: [Product]) -> [Product] {
        var products = [Product]()
        for pr in prs {
            if pr.type == Categories.Shoes.rawValue {
                if !products.contains(pr) {
                    products.append(pr)
                }
            }
        }
        
        return products.kShuffled
    }
    
    class func watches(_ prs: [Product]) -> [Product] {
        var products = [Product]()
        for pr in prs {
            if pr.type == Categories.Watches.rawValue {
                if !products.contains(pr) {
                    products.append(pr)
                }
            }
        }
        
        return products.kShuffled
    }
    
    class func bags(_ prs: [Product]) -> [Product] {
        var products = [Product]()
        for pr in prs {
            if pr.type == Categories.Bags.rawValue {
                if !products.contains(pr) {
                    products.append(pr)
                }
            }
        }
        
        return products.kShuffled
    }
    
    class func dresses(_ prs: [Product]) -> [Product] {
        var products = [Product]()
        for pr in prs {
            if pr.type == Categories.Dresses.rawValue {
                if !products.contains(pr) {
                    products.append(pr)
                }
            }
        }
        
        return products.kShuffled
    }
    
    class func lingerie(_ prs: [Product]) -> [Product] {
        var products = [Product]()
        for pr in prs {
            if pr.type == Categories.Lingerie.rawValue {
                if !products.contains(pr) {
                    products.append(pr)
                }
            }
        }
        
        return products.kShuffled
    }
    
    class func men(_ prs: [Product]) -> [Product] {
        var products = [Product]()
        for pr in prs {
            if pr.type == Categories.Men.rawValue {
                if !products.contains(pr) {
                    products.append(pr)
                }
            }
        }
        
        return products.kShuffled
    }
    
    class func kids(_ prs: [Product]) -> [Product] {
        var products = [Product]()
        for pr in prs {
            if pr.type == Categories.Kids.rawValue {
                if !products.contains(pr) {
                    products.append(pr)
                }
            }
        }
        
        return products.kShuffled
    }
    
    class func skirts(_ prs: [Product]) -> [Product] {
        var products = [Product]()
        for pr in prs {
            if pr.type == Categories.Skirts.rawValue {
                if !products.contains(pr) {
                    products.append(pr)
                }
            }
        }
        
        return products.kShuffled
    }
    
    class func sleepwear(_ prs: [Product]) -> [Product] {
        var products = [Product]()
        for pr in prs {
            if pr.type == Categories.Sleepwear.rawValue {
                if !products.contains(pr) {
                    products.append(pr)
                }
            }
        }
        
        return products.kShuffled
    }
    
    class func swimwear(_ prs: [Product]) -> [Product] {
        var products = [Product]()
        for pr in prs {
            if pr.type == Categories.Swimwear.rawValue {
                if !products.contains(pr) {
                    products.append(pr)
                }
            }
        }
        
        return products.kShuffled
    }
    
    class func wishlists(_ prs: [Product]) -> [Product] {
        var products = [Product]()
        for pr in prs {
            if !products.contains(pr) {
                if products.count < 10 { products.append(pr) }
            }
        }
        
        return products.kShuffled
    }
    
    static var tags: [String] = []
    static var recentlyViewed: [Product] = []
    static var filters: [Product] = []
    
    static func suggestions(_ products: [Product]) -> [String] {
        var suggestions: [String] = []
        for pr in products.kShuffled {
            for tag in pr.tags {
                let tag = tag.byWords.prefix(4).joined(separator: " ").lowercased()
                if !suggestions.contains(tag) {
                    if suggestions.count < 10 {
                        suggestions.append(tag)
                    }
                }
            }
        }
        
        return suggestions
    }
    
    static func filterByColor(_ color: String, prs: [Product], completion: @escaping ([Product]) -> Void) {
        var products: [Product] = []
        for pr in prs {
            pr.colors.forEach({
                if $0 == color {
                    if !products.contains(pr) {
                        products.append(pr)
                        completion(products)
                    }
                }
            })
        }
    }
    
    static func filterByRating(_ rating: Int, prs: [Product], completion: @escaping ([Product]) -> Void) {
        var products: [Product] = []
        Rating.fillterPrUIDFromRating(selectRating: rating) { (prsUID) in
            for prUID in prsUID {
                for pr in prs {
                    if prUID == pr.uid {
                        if !products.contains(pr) {
                            products.append(pr)
                            completion(products)
                        }
                    }
                }
            }
        }
    }
    
    static func filterByColorAndRating(_ color: String, _ rating: Int, prs: [Product], completion: @escaping ([Product]) -> Void) {
        var products: [Product] = []
        filterByRating(rating, prs: prs) { (prsRating) in
            filterByColor(color, prs: prs) { (prsColor) in
                for r in prsRating {
                    for c in prsColor {
                        if r.uid == c.uid {
                            if !products.contains(r) {
                                products.append(r)
                                completion(products)
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func allColors(_ prs: [Product]) -> [String] {
        var colors: [String] = []
        for pr in prs {
            pr.colors.forEach({
                if !colors.contains($0) { colors.append($0) }
            })
        }
        
        return colors
    }
    
    static func searchTapItems(_ prs: [Product], _ tag: String) -> [Product] {
        var products: [Product] = []
        for p in prs {
            for t in p.tags {
                let t1 = tag.byWords.prefix(2).joined(separator: " ").lowercased()
                if t.contains(t1) {
                    if !products.contains(p) {
                        products.append(p)
                    }
                }
            }
        }
        
        return products.kShuffled
    }
    
    /*
    static func recentlyViewAll(_ viewAll: [Product], prs: [Product]) -> [Product] {
        var recentlyViewAll: [Product] = []
        for pr in viewAll {
            for tag in pr.tags {
                for p in prs {
                    for t in p.tags {
                        let t1 = tag.byWords.prefix(2).joined(separator: " ").lowercased()
                        if t.contains(t1) {
                            if !recentlyViewAll.contains(p) {
                                recentlyViewAll.append(p)
                            }
                        }
                    }
                }
            }
        }
        
        return recentlyViewAll.kShuffled
    }
    */
}
