//
//  PrRating+Ext.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import Firebase

//MARK: - Save

extension PrRating {
    
    class func saveBelts() {
//        testBeltsRating1 {}
//        testBeltsRating2 {}
//        testBeltsRating3 {}
//        testBeltsRating4 {}
//        testBeltsRating5 {}
//        testBeltsRating6 {}
//        testBeltsRating7 {}
//        testBeltsRating8 {}
    }
    
    class func saveBags() {
//        testBagsRating1 {}
//        testBagsRating2 {}
    }
    
    class func saveHoodies() {
//        testHoodiesRating1 {}
//        testHoodiesRating2 {}
//        testHoodiesRating3 {}
//        testHoodiesRating4 {}
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

//MARK: - Test Belts

extension PrRating {
    
    class func saveR(_ v: Int, prUID: String, frR: Int, toR: Int, completion: @escaping () -> Void) {
        for _ in frR...toR {
            let uid = Database.database().reference().childByAutoId().key!
            let prRating = PrRating(prUID: prUID)
            prRating.saveRating(v, userUID: uid, completion: completion)
        }
    }
    
    class func testBeltsRating1(completion: @escaping () -> Void) {
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
    
    class func testBeltsRating2(completion: @escaping () -> Void) {
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
    
    class func testBeltsRating3(completion: @escaping () -> Void) {
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
    
    class func testBeltsRating4(completion: @escaping () -> Void) {
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
    
    class func testBeltsRating5(completion: @escaping () -> Void) {
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
    
    class func testBeltsRating6(completion: @escaping () -> Void) {
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
    
    class func testBeltsRating7(completion: @escaping () -> Void) {
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
    
    class func testBeltsRating8(completion: @escaping () -> Void) {
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

//MARK: - Test Hoodies

extension PrRating {
    
    class func testHoodiesRating1(completion: @escaping () -> Void) {
        let prUID = "123456-Hoodies-001"
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
    
    class func testHoodiesRating2(completion: @escaping () -> Void) {
        let prUID = "123456-Hoodies-002"
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
    
    class func testHoodiesRating3(completion: @escaping () -> Void) {
        let prUID = "123456-Hoodies-003"
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
    
    class func testHoodiesRating4(completion: @escaping () -> Void) {
        let prUID = "123456-Hoodies-004"
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
