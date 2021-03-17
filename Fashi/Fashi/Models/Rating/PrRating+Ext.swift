//
//  PrRating+Ext.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import Firebase

//MARK: - Save

extension PrRating {
    
    class func saveAccessories() {
//        testAccessoriesRating1 {}
//        testAccessoriesRating2 {}
//        testAccessoriesRating3 {}
//        testAccessoriesRating4 {}
//        testAccessoriesRating5 {}
//        testAccessoriesRating6 {}
//        testAccessoriesRating7 {}
//        testAccessoriesRating8 {}
    }
    
    class func saveBags() {
//        testBagsRating1 {}
//        testBagsRating2 {}
    }
    
    class func saveClothing() {
//        testClothingRating1 {}
//        testClothingRating2 {}
//        testClothingRating3 {}
//        testClothingRating4 {}
    }
    
    class func saveShoes() {
//        testShoesRating1 {}
//        testShoesRating2 {}
//        testShoesRating3 {}
    }
    
    class func saveWatches() {
//        testWatchesRating1 {}
//        testWatchesRating2 {}
//        testWatchesRating3 {}
//        testWatchesRating4 {}
    }
}

//MARK: - Test Accessories

extension PrRating {
    
    class func saveR(_ v: Int, prUID: String, frR: Int, toR: Int, completion: @escaping () -> Void) {
        for _ in frR...toR {
            let uid = Database.database().reference().childByAutoId().key!
            let prRating = PrRating(prUID: prUID)
            prRating.saveRating(v, userUID: uid, completion: completion)
        }
    }
    
    class func testAccessoriesRating1(completion: @escaping () -> Void) {
        let prUID = "123456-ACCESSORIES-001"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
    
    class func testAccessoriesRating2(completion: @escaping () -> Void) {
        let prUID = "123456-ACCESSORIES-002"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
    
    class func testAccessoriesRating3(completion: @escaping () -> Void) {
        let prUID = "123456-ACCESSORIES-003"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
    
    class func testAccessoriesRating4(completion: @escaping () -> Void) {
        let prUID = "123456-ACCESSORIES-004"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
    
    class func testAccessoriesRating5(completion: @escaping () -> Void) {
        let prUID = "123456-ACCESSORIES-005"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
    
    class func testAccessoriesRating6(completion: @escaping () -> Void) {
        let prUID = "123456-ACCESSORIES-006"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
    
    class func testAccessoriesRating7(completion: @escaping () -> Void) {
        let prUID = "123456-ACCESSORIES-007"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
    
    class func testAccessoriesRating8(completion: @escaping () -> Void) {
        let prUID = "123456-ACCESSORIES-008"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
}

//MARK: - Test Bags

extension PrRating {
    
    class func testBagsRating1(completion: @escaping () -> Void) {
        let prUID = "123456-BAGS-001"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
    
    class func testBagsRating2(completion: @escaping () -> Void) {
        let prUID = "123456-BAGS-002"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
}

//MARK: - Test Clothing

extension PrRating {
    
    class func testClothingRating1(completion: @escaping () -> Void) {
        let prUID = "123456-CLOTHING-001"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
    
    class func testClothingRating2(completion: @escaping () -> Void) {
        let prUID = "123456-CLOTHING-002"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
    
    class func testClothingRating3(completion: @escaping () -> Void) {
        let prUID = "123456-CLOTHING-003"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
    
    class func testClothingRating4(completion: @escaping () -> Void) {
        let prUID = "123456-CLOTHING-004"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
}

//MARK: - Test Shoes

extension PrRating {
    
    class func testShoesRating1(completion: @escaping () -> Void) {
        let prUID = "123456-SHOES-001"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
    
    class func testShoesRating2(completion: @escaping () -> Void) {
        let prUID = "123456-SHOES-002"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
    
    class func testShoesRating3(completion: @escaping () -> Void) {
        let prUID = "123456-SHOES-003"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
}

//MARK: - Test Watches

extension PrRating {
    
    class func testWatchesRating1(completion: @escaping () -> Void) {
        let prUID = "123456-WATCHES-001"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
    
    class func testWatchesRating2(completion: @escaping () -> Void) {
        let prUID = "123456-WATCHES-002"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
    
    class func testWatchesRating3(completion: @escaping () -> Void) {
        let prUID = "123456-WATCHES-003"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
    
    class func testWatchesRating4(completion: @escaping () -> Void) {
        let prUID = "123456-WATCHES-004"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1, completion: completion)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2, completion: completion)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3, completion: completion)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4, completion: completion)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5, completion: completion)
    }
}
