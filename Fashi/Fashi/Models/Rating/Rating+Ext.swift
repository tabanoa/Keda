//
//  Rating+Ext.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import Firebase

//MARK: - Save

extension Rating {
    
    class func saveAccessories() {
//        testAccessoriesRating1()
//        testAccessoriesRating2()
//        testAccessoriesRating3()
//        testAccessoriesRating4()
//        testAccessoriesRating5()
//        testAccessoriesRating6()
//        testAccessoriesRating7()
//        testAccessoriesRating8()
    }
    
    class func saveBags() {
//        testBagsRating1()
//        testBagsRating2()
    }
    
    class func saveClothing() {
//        testClothingRating1()
//        testClothingRating2()
//        testClothingRating3()
//        testClothingRating4()
    }
    
    class func saveShoes() {
//        testShoesRating1()
//        testShoesRating2()
//        testShoesRating3()
    }
    
    class func saveWatches() {
//        testWatchesRating1()
//        testWatchesRating2()
//        testWatchesRating3()
//        testWatchesRating4()
    }
}

//MARK: - Test Accessories

extension Rating {
    
    class func saveR(_ v: Int, prUID: String, frR: Int, toR: Int) {
        for _ in frR...toR {
            let uid = Database.database().reference().childByAutoId().key!
            let r = Rating()
            r.saveRating(prUID, v, uid)
        }
    }
    
    class func testAccessoriesRating1() {
        let prUID = "123456-ACCESSORIES-001"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
    
    class func testAccessoriesRating2() {
        let prUID = "123456-ACCESSORIES-002"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
    
    class func testAccessoriesRating3() {
        let prUID = "123456-ACCESSORIES-003"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
    
    class func testAccessoriesRating4() {
        let prUID = "123456-ACCESSORIES-004"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
    
    class func testAccessoriesRating5() {
        let prUID = "123456-ACCESSORIES-005"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
    
    class func testAccessoriesRating6() {
        let prUID = "123456-ACCESSORIES-006"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
    
    class func testAccessoriesRating7() {
        let prUID = "123456-ACCESSORIES-007"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
    
    class func testAccessoriesRating8() {
        let prUID = "123456-ACCESSORIES-008"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
}

//MARK: - Test Bags

extension Rating {
    
    class func testBagsRating1() {
        let prUID = "123456-BAGS-001"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
    
    class func testBagsRating2() {
        let prUID = "123456-BAGS-002"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
}

//MARK: - Test Clothing

extension Rating {
    
    class func testClothingRating1() {
        let prUID = "123456-CLOTHING-001"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
    
    class func testClothingRating2() {
        let prUID = "123456-CLOTHING-002"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
    
    class func testClothingRating3() {
        let prUID = "123456-CLOTHING-003"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
    
    class func testClothingRating4() {
        let prUID = "123456-CLOTHING-004"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
}

//MARK: - Test Shoes

extension Rating {
    
    class func testShoesRating1() {
        let prUID = "123456-SHOES-001"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
    
    class func testShoesRating2() {
        let prUID = "123456-SHOES-002"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
    
    class func testShoesRating3() {
        let prUID = "123456-SHOES-003"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
}

//MARK: - Test Watches

extension Rating {
    
    class func testWatchesRating1() {
        let prUID = "123456-WATCHES-001"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
    
    class func testWatchesRating2() {
        let prUID = "123456-WATCHES-002"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
    
    class func testWatchesRating3() {
        let prUID = "123456-WATCHES-003"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
    
    class func testWatchesRating4() {
        let prUID = "123456-WATCHES-004"
        let r1 = Int.random(min: 10, max: 20)
        saveR(1, prUID: prUID, frR: 1, toR: r1)
        
        let r2 = Int.random(min: 10, max: 20)
        saveR(2, prUID: prUID, frR: 2, toR: r2)
        
        let r3 = Int.random(min: 10, max: 20)
        saveR(3, prUID: prUID, frR: 3, toR: r3)
        
        let r4 = Int.random(min: 30, max: 100)
        saveR(4, prUID: prUID, frR: 4, toR: r4)
        
        let r5 = Int.random(min: 40, max: 150)
        saveR(5, prUID: prUID, frR: 5, toR: r5)
    }
}
