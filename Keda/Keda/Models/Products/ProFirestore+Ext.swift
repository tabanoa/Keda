//
//  ProFirestore+Ext.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import Firebase

extension Product {
    
    class func savehoodies() {
//        saveAllProduct(.hoodies1()) {}
//        saveAllProduct(.hoodies2()) {}
//        saveAllProduct(.hoodies3()) {}
//        saveAllProduct(.hoodies4()) {}
    }
    
    class func saveWatches() {
//        saveAllProduct(.watches1()) {}
//        saveAllProduct(.watches2()) {}
//        saveAllProduct(.watches3()) {}
//        saveAllProduct(.watches4()) {}
    }
    
    class func saveBelts() {
//        saveAllProduct(.belts1()) {}
//        saveAllProduct(.belts2()) {}
//        saveAllProduct(.belts3()) {}
//        saveAllProduct(.belts4()) {}
//        saveAllProduct(.belts5()) {}
//        saveAllProduct(.belts6()) {}
//        saveAllProduct(.belts7()) {}
//        saveAllProduct(.belts8()) {}
//        saveAllProduct(airPod1()) {}
    }
    
    class func saveShoes() {
//        saveAllProduct(.shoes1()) {}
//        saveAllProduct(.shoes2()) {}
//        saveAllProduct(.shoes3()) {}
//         saveAllProduct(jordanDior()) {}
    }
    
    class func saveBags() {
//        saveAllProduct(.bags1()) {}
//        saveAllProduct(.bags2()) {}
    }
    
    class func saveAllProduct(_ pr: Product, completion: @escaping () -> Void) {
        let prDict: [String: Any] = [
            "uid": pr.uid,
            "createdTime": pr.createdTime,
            "type": pr.type,
            "tags": pr.tags,
            "active": pr.active,
        ]
        
        let refPrID = DatabaseRef.product(uid: pr.uid).ref()
        refPrID.setValue(prDict)
        
        for i in 0..<pr.colors.count {
            pr.colorModelIndex = i
            
            for i in 0..<pr.sizes.count {
                pr.sizeModelIndex = i
                
                let infoDict: [String: Any] = [
                    "name": pr.name,
                    "price": pr.price,
                    "saleOff": pr.saleOff,
                    "imageLinks": pr.imageLinks,
                    "description": pr.description
                ]
                
                let refColor = refPrID.child("colors/\(pr.colors[pr.colorModelIndex])")
                let refSize = refColor.child("sizes/\(pr.sizes[pr.sizeModelIndex])")
                refSize.updateChildValues(infoDict)
                completion()
            }
        }
    }
}

//MARK: - CRUD

extension Product {
    
    class func savePr(_ pr: Product, completion: @escaping () -> Void) {
        let prDict: [String: Any] = [
            "uid": pr.uid,
            "createdTime": pr.createdTime,
            "type": pr.type,
            "tags": pr.tags,
            "active": pr.active,
        ]
        
        let refPrID = DatabaseRef.product(uid: pr.uid).ref()
        refPrID.setValue(prDict)
        
        for i in 0..<pr.colors.count {
            pr.colorModelIndex = i
            
            for j in 0..<pr.sizes.count {
                pr.sizeModelIndex = j
                
                let infoDict: [String: Any] = [
                    "name": pr.name,
                    "price": pr.price,
                    "saleOff": pr.saleOff,
                    "imageLinks": pr.imageLinks,
                    "description": pr.description
                ]
                
                let color = pr.colors[pr.colorModelIndex]
                let size = pr.sizes[pr.sizeModelIndex]
                let refSize = refPrID.child("colors/\(color)/sizes/\(size)")
                refSize.updateChildValues(infoDict)
                
                if(pr.images.count == 0){
                    completion()
                }else{
                    uploadImageToImgur(pr.images) { (links) in
                        ProductSize.saveImageLinks(prUID: pr.uid, color: color, size: size, imgLinks: links) {
                            delay(duration: 5.0) { completion() }
                        }
                    }
                }
            }
        }
    }
    
    class private func uploadImageToImgur(_ images: [UIImage], completion: @escaping ([String]) -> Void) {
        var imageLinks: [String] = []
        for image in images {
            Imgur.sharedInstance.uploadImageToImgur(image) { (link) in
                defer {
                    DispatchQueue.main.async {
                        completion(imageLinks)
                    }
                }
                
                if !imageLinks.contains(link) {
                    imageLinks.append(link)
                }
            }
        }
    }
    
    class func editProduct(prUID: String,
                           color: String,
                           size: String,
                           name: String,
                           price: Double,
                           saleOff: Double,
                           description: String,
                           images: [UIImage],
                           imageLinks: [String],
                           completion: @escaping () -> Void) {
        let toDict: [String: Any] = [
            "name": name,
            "price": price,
            "saleOff": saleOff,
            "imageLinks": imageLinks,
            "description": description
        ]
        
        let ref = DatabaseRef.product(uid: prUID).ref().child("colors/\(color)/sizes/\(size)")
        ref.updateChildValues(toDict)
        guard images.count != 0 else { completion(); return }
        
        upload(images: images, imageLinks: imageLinks) { (links) in
            ProductSize.saveImageLinks(prUID: prUID, color: color, size: size, imgLinks: links) {
                delay(duration: 5.0) { completion() }
            }
        }
    }
    
    class private func upload(images: [UIImage], imageLinks: [String], completion: @escaping ([String]) -> Void) {
        var imgLinks: [String] = imageLinks
        uploadImageToImgur(images) { (links) in
            defer {
                DispatchQueue.main.async {
                    completion(imgLinks)
                }
            }
            
            links.forEach({
                if !imgLinks.contains($0) {
                    imgLinks.append($0)
                }
            })
        }
    }
    
    func deleteSizeFromPr(color: String, size: String, completion: @escaping () -> Void) {
        let ref = DatabaseRef.product(uid: uid).ref().child("colors/\(color)/sizes/\(size)")
        ref.removeValue()
    }
    
    func deletePr(completion: @escaping () -> Void) {
        let ref = DatabaseRef.product(uid: uid).ref()
        ref.removeValue()
        completion()
    }
}
