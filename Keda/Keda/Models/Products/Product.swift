//
//  Product.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Firebase
import SDWebImage

enum Categories: String {
    case Hoodies = "Hoodies"
    case Belts = "Belts"
    case Shoes = "Shoes"
    case Watches = "Watches"
    case Bags = "Bags"
    case Jackets = "Jackets"
    case Shirts = "Shirts"
    case Shorts = "Shorts"
    case Pants = "Pants"
    case Slides = "Slides"
    case Lounge = "Lounge"
    case Collectables = "Collectables"
}

//MARK: - ProductModel

struct ProModel {
    let uid: String
    let createdTime: String
    var prColors: [ProductColor] = []
    let type: String
    let tags: [String]
    var viewed: Int = 0
    var buyed: Int = 0
    var active = false
}

class Product: Hashable {
    
    var proModel: ProModel
    
    var colorModelIndex = 0
    var sizeModelIndex = 0
    
    init(prModel: ProModel) {
        self.proModel = prModel
    }
    
    var uid: String { return proModel.uid }
    var type: String { return proModel.type }
    var tags: [String] { return proModel.tags }
    var createdTime: String { return proModel.createdTime }
    
    var prColors: [ProductColor] { return proModel.prColors }
    
    var colors: [String] {
        var colors: [String] = []
        proModel.prColors.forEach({ colors.append($0.color) })
        return colors
    }
    
    var prSizes: [ProductSize] {
        if(proModel.prColors.count < colorModelIndex || proModel.prColors.count == 0){
            return []
        }
        return proModel.prColors[colorModelIndex].prSizes
    }
    
    var sizes: [String] {
        var sizes: [String] = []
        prSizes.forEach({ sizes.append($0.size) })
        return sizes
    }
    
    var name: String {if(prSizes.count < sizeModelIndex || prSizes.count == 0){
        return ""
    }
    return prSizes[sizeModelIndex].prInfoModel.name }
    
    var price: Double { if(prSizes.count < sizeModelIndex || prSizes.count == 0){
        return 0.0
    }
    return prSizes[sizeModelIndex].prInfoModel.price }
    
    var saleOff: Double {if(prSizes.count < sizeModelIndex || prSizes.count == 0){
        return 0.0
    }
    return prSizes[sizeModelIndex].prInfoModel.saleOff }
    
    var description: String {if(prSizes.count < sizeModelIndex || prSizes.count == 0){
        return ""
    }
    return prSizes[sizeModelIndex].prInfoModel.description }
    
    var imageLinks: [String] {
        if(prSizes.count < sizeModelIndex || prSizes.count == 0){
            return []
        }
        return prSizes[sizeModelIndex].prInfoModel.imageLinks }
        
    var imageLink: String { return imageLinks.first ?? "https://i.imgur.com/YNoZzmJ.png"}
    var viewed: Int { return proModel.viewed }
    var buyed: Int { return proModel.buyed }
    var active: Bool { return proModel.active }
    var images: [UIImage] {
        if(prSizes.count < sizeModelIndex || prSizes.count == 0){
            return []
        }
        return prSizes[sizeModelIndex].prInfoModel.images }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}

//MARK: - Save

extension Product {
    
    func saveProduct(completion: @escaping () -> Void) {
        let ref = DatabaseRef.product(uid: uid).ref()
        ref.setValue(toDictionary())
    }
    
    private func toDictionary() -> [String: Any] {
        return [
            "createdTime": createdTime,
            "type": type,
            "uid": uid,
            "active": active,
            "tags": tags,
        ]
    }
    
    func updateActiveForPr(completion: @escaping () -> Void) {
        let ref = DatabaseRef.product(uid: uid).ref()
        ref.updateChildValues(["active": true])
        completion()
    }
}

//MARK: - Fetch

extension Product {
    
    class func fetchProducts(completion: @escaping ([Product]) -> Void) {
        var products: [Product] = []
        
        let ref = Database.database().reference().child("Product")
        ref.observe(.childAdded) { (snapshot) in
            guard let dictPr = snapshot.value as? [String: Any] else { return }
            let uid = dictPr["uid"] as! String
            let createdTime = dictPr["createdTime"] as! String
            let type = dictPr["type"] as! String
            let tags = (dictPr["tags"] as? [String]) ?? []
            let active = dictPr["active"] as! Bool
            
            var prColors: [ProductColor] = []
            
            if let dictColor = dictPr["colors"] as? [String: Any] {
                for (color, value) in dictColor {
                    var prSizes: [ProductSize] = []
                    
                    if let dict = value as? [String: Any] {
                        if let dictSize = dict["sizes"] as? [String: Any] {
                            for (size, value) in dictSize {
                                if let dict = value as? [String: Any] {
                                    let prInfoModel = ProductInfoModel(dictionary: dict)
                                    let prSize = ProductSize(size: size, prInfoModel: prInfoModel)
                                    if !prSizes.contains(prSize) {
                                        prSizes.append(prSize)
                                        prSizes.sort(by: { $0.size < $1.size })
                                    }
                                }
                            }
                        }
                    }

                    let prColor = ProductColor(color: color, prSizes: prSizes)
                    if !prColors.contains(prColor) {
                        prColors.append(prColor)
                    }
                }
            }
            
            let prModel = ProModel(uid: uid, createdTime: createdTime, prColors: prColors, type: type, tags: tags, active: active)
            let pro = Product(prModel: prModel)
            guard pro.active else { return }
            
            if !products.contains(pro) {
                products.append(pro)
                DispatchQueue.main.async {
                    completion(products)
                }
            }
        }
    }
    
    class func fetchProductsNotActive(completion: @escaping ([Product]) -> Void) {
        var products: [Product] = []
        
        let ref = Database.database().reference().child("Product")
        ref.observe(.childAdded) { (snapshot) in
            guard let dictPr = snapshot.value as? [String: Any] else { return }
            let uid = dictPr["uid"] as! String
            let createdTime = dictPr["createdTime"] as! String
            let type = dictPr["type"] as! String
            let tags = (dictPr["tags"] as? [String]) ?? []
            let active = dictPr["active"] as! Bool
            
            var prColors: [ProductColor] = []
            
            if let dictColor = dictPr["colors"] as? [String: Any] {
                for (color, value) in dictColor {
                    var prSizes: [ProductSize] = []
                    
                    if let dict = value as? [String: Any] {
                        if let dictSize = dict["sizes"] as? [String: Any] {
                            for (size, value) in dictSize {
                                if let dict = value as? [String: Any] {
                                    let prInfoModel = ProductInfoModel(dictionary: dict)
                                    let prSize = ProductSize(size: size, prInfoModel: prInfoModel)
                                    if !prSizes.contains(prSize) {
                                        prSizes.append(prSize)
                                        prSizes.sort(by: { $0.size < $1.size })
                                    }
                                }
                            }
                        }
                    }

                    let prColor = ProductColor(color: color, prSizes: prSizes)
                    if !prColors.contains(prColor) {
                        prColors.append(prColor)
                    }
                }
            }
            
            let prModel = ProModel(uid: uid, createdTime: createdTime, prColors: prColors, type: type, tags: tags, active: active)
            let pro = Product(prModel: prModel)
            guard !pro.active else { return }
            
            if !products.contains(pro) {
                products.append(pro)
                DispatchQueue.main.async {
                    completion(products)
                }
            }
        }
    }
    
    class func fetchPrFromUIDColorSize(prUID: String, color: String, size: String, completion: @escaping (Product) -> Void) {
        let ref = DatabaseRef.product(uid: prUID).ref()
        ref.observe(.value) { (snapshot) in
            guard let dictPr = snapshot.value as? [String: Any] else { return }
            let uid = dictPr["uid"] as! String
            let createdTime = dictPr["createdTime"] as! String
            let type = dictPr["type"] as! String
            let tags = dictPr["tags"] as! [String]
            let active = dictPr["active"] as! Bool
            
            var prColors: [ProductColor] = []
            
            let refColor = ref.child("colors/\(color)/sizes/\(size)")
            refColor.observe(.value) { (snapshot) in
                if let dict = snapshot.value as? [String: Any] {
                    let infoModel = ProductInfoModel(dictionary: dict)
                    let prSize = ProductSize(size: size, prInfoModel: infoModel)
                    let prColor = ProductColor(color: color, prSizes: [prSize])
                    let prModel = ProModel(uid: uid, createdTime: createdTime, prColors: [prColor], type: type, tags: tags)
                    let product = Product(prModel: prModel)
                    completion(product)
                }
            }
            
            ProductColor.fetchProductColor(prUID: prUID) { (prColor) in
                if !prColors.contains(prColor) { prColors.append(prColor) }
                
                let prModel = ProModel(uid: uid, createdTime: createdTime, prColors: prColors, type: type, tags: tags, active: active)
                let pro = Product(prModel: prModel)
                guard pro.active else { return }
                
                DispatchQueue.main.async {
                    completion(pro)
                }
            }
        }
    }
    
    class func fetchProductFromPrUID(prUID: String, completion: @escaping (Product) -> Void) {
        let ref = DatabaseRef.product(uid: prUID).ref()
        ref.observe(.value) { (snapshot) in
            guard let dictPr = snapshot.value as? [String: Any] else { return }
            let uid = dictPr["uid"] as! String
            let createdTime = dictPr["createdTime"] as! String
            let type = dictPr["type"] as! String
            let tags = dictPr["tags"] as! [String]
            let active = dictPr["active"] as! Bool
            
            var prColors: [ProductColor] = []
            
            if let dictColor = dictPr["colors"] as? [String: Any] {
                for (color, value) in dictColor {
                    var prSizes: [ProductSize] = []
                    
                    if let dict = value as? [String: Any] {
                        if let dictSize = dict["sizes"] as? [String: Any] {
                            for (size, value) in dictSize {
                                if let dict = value as? [String: Any] {
                                    let prInfoModel = ProductInfoModel(dictionary: dict)
                                    let prSize = ProductSize(size: size, prInfoModel: prInfoModel)
                                    if !prSizes.contains(prSize) {
                                        prSizes.append(prSize)
                                        prSizes.sort(by: { $0.size < $1.size })
                                    }
                                }
                            }
                        }
                    }

                    let prColor = ProductColor(color: color, prSizes: prSizes)
                    if !prColors.contains(prColor) {
                        prColors.append(prColor)
                    }
                }
            }
            
            let prModel = ProModel(uid: uid, createdTime: createdTime, prColors: prColors, type: type, tags: tags, active: active)
            let pro = Product(prModel: prModel)
            guard pro.active else { return }
            
            DispatchQueue.main.async {
                completion(pro)
            }
        }
    }
}

//MARK: - DownloadImage

extension Product {
    
    class func downloadImage(from link: String, completion: @escaping (UIImage) -> Void) {
        let url = URL(string: link)
        SDWebImageManager.shared.loadImage(
            with: url,
            options: .continueInBackground,
            progress: nil) { (image, data, error, cache, finished, url) in
                guard error == nil, let image = image else { return }
                completion(image)
        }
        
        /*
        guard let url = URL(string: link) else { return }
        let session = URLSession.shared
        session.dataTask(with: url, completionHandler: { (data, response, error) in
            DispatchQueue.global(qos: .background).async {
                guard error == nil, let data = data, let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async {
                    completion(image)
                }
            }

        }).resume()
        */
    }
}

//MARK: - Fetch

extension Product {
    
    class func fetchFeatured(completion: @escaping ([Product]) -> Void) {
        var products: [Product] = []
        
        let ref = Database.database().reference().child("Product")
        ref.observe(.childAdded) { (snapshot) in
            guard let dictPr = snapshot.value as? [String: Any] else { return }
            let uid = dictPr["uid"] as! String
            let createdTime = dictPr["createdTime"] as! String
            let type = dictPr["type"] as! String
            let tags = (dictPr["tags"] as? [String]) ?? []
            let active = dictPr["active"] as! Bool
            
            var prColors: [ProductColor] = []
            
            if let dictColor = dictPr["colors"] as? [String: Any] {
                for (color, value) in dictColor {
                    var prSizes: [ProductSize] = []
                    
                    if let dict = value as? [String: Any] {
                        if let dictSize = dict["sizes"] as? [String: Any] {
                            for (size, value) in dictSize {
                                if let dict = value as? [String: Any] {
                                    let prInfoModel = ProductInfoModel(dictionary: dict)
                                    let prSize = ProductSize(size: size, prInfoModel: prInfoModel)
                                    if !prSizes.contains(prSize) {
                                        prSizes.append(prSize)
                                        prSizes.sort(by: { $0.size < $1.size })
                                    }
                                }
                            }
                        }
                    }

                    let prColor = ProductColor(color: color, prSizes: prSizes)
                    if !prColors.contains(prColor) {
                        prColors.append(prColor)
                    }
                }
            }
            
            let prModel = ProModel(uid: uid, createdTime: createdTime, prColors: prColors, type: type, tags: tags, active: active)
            let pro = Product(prModel: prModel)
            guard pro.active else { return }
            
            ViewsModel.fetchViews(prUID: pro.uid) { (model) in
                guard let model = model else {
                    pro.proModel.viewed = 0
                    if !products.contains(pro) {
                        products.append(pro)
                        DispatchQueue.main.async {
                            completion(products)
                        }
                    }
                    
                    return
                }
                
                pro.proModel.viewed = model.count
                
                if !products.contains(pro) {
                    products.append(pro)
                    DispatchQueue.main.async {
                        completion(products)
                    }
                }
            }
        }
    }
    
    class func fetchSellers(completion: @escaping ([Product]) -> Void) {
        var products: [Product] = []
        
        let ref = Database.database().reference().child("Product")
        ref.observe(.childAdded) { (snapshot) in
            guard let dictPr = snapshot.value as? [String: Any] else { return }
            let uid = dictPr["uid"] as! String
            let createdTime = dictPr["createdTime"] as! String
            let type = dictPr["type"] as! String
            let tags = (dictPr["tags"] as? [String]) ?? []
            let active = dictPr["active"] as! Bool
            
            var prColors: [ProductColor] = []
            
            if let dictColor = dictPr["colors"] as? [String: Any] {
                for (color, value) in dictColor {
                    var prSizes: [ProductSize] = []
                    
                    if let dict = value as? [String: Any] {
                        if let dictSize = dict["sizes"] as? [String: Any] {
                            for (size, value) in dictSize {
                                if let dict = value as? [String: Any] {
                                    let prInfoModel = ProductInfoModel(dictionary: dict)
                                    let prSize = ProductSize(size: size, prInfoModel: prInfoModel)
                                    if !prSizes.contains(prSize) {
                                        prSizes.append(prSize)
                                        prSizes.sort(by: { $0.size < $1.size })
                                    }
                                }
                            }
                        }
                    }

                    let prColor = ProductColor(color: color, prSizes: prSizes)
                    if !prColors.contains(prColor) {
                        prColors.append(prColor)
                    }
                }
            }
            
            let prModel = ProModel(uid: uid, createdTime: createdTime, prColors: prColors, type: type, tags: tags, active: active)
            let pro = Product(prModel: prModel)
            guard pro.active else { return }
            
            Buyed.fetchBuyed(prUID: pro.uid) { (buy) in
                guard let buy = buy else {
                    pro.proModel.buyed = 0
                    if !products.contains(pro) {
                        products.append(pro)
                        DispatchQueue.main.async {
                            completion(products)
                        }
                    }
                    
                    return
                }
                
                pro.proModel.buyed = buy.count
                
                if !products.contains(pro) {
                    products.append(pro)
                    DispatchQueue.main.async {
                        completion(products)
                    }
                }
            }
        }
    }
}

//MARK: - Equatable

extension Product: Equatable {}
func ==(lhs: Product, rhs: Product) -> Bool {
    return lhs.uid == rhs.uid
}
