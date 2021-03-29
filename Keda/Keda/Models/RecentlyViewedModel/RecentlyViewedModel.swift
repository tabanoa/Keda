//
//  RecentlyViewedModel.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import CoreData

class RecentlyViewedModel {
    
    var prUID: String
    var createdTime: String
    
    init(prUID: String, createdTime: String) {
        self.prUID = prUID
        self.createdTime = createdTime
    }
}

//MARK: - Fetch

extension RecentlyViewedModel {
    
    class func fetchFromCoreData(completion: @escaping ([RecentlyViewedModel]) -> Void) {
        var recentlyVieweds: [RecentlyViewedModel] = []
        
        let request: NSFetchRequest<RecentlyViewed> = RecentlyViewed.fetchRequest()
        do {
            let result = try appDl.coreDataStack.managedObjectContext.fetch(request)
            if result.count >= 20 {
                var recently = result.sorted(by: { $0.createdTime < $1.createdTime })
                let recent = recently.removeFirst()
                appDl.coreDataStack.managedObjectContext.delete(recent)
                appDl.coreDataStack.saveContext()
            }
            
            result.forEach({
                let recentlyViewed = RecentlyViewedModel(prUID: $0.productUID, createdTime: $0.createdTime)
                recentlyVieweds.append(recentlyViewed)
                recentlyVieweds.sort(by: { $0.createdTime > $1.createdTime })
                completion(recentlyVieweds)
            })
            
        } catch let error as NSError {
            print("Fetch recently viewed error: \(error.localizedDescription)")
        }
    }
    
    class func addRecentlyViewed(_ recentlyVieweds: [RecentlyViewedModel], completion: @escaping ([Product]) -> Void) {
        var products: [Product] = []
        for recentlyViewed in recentlyVieweds {
            Product.fetchProducts { (prs) in
                prs.forEach({
                    if recentlyViewed.prUID ==  $0.uid {
                        if !products.contains($0) {
                            products.append($0)
                            completion(products)
                        }
                    }
                })
            }
        }
    }
    
    class func fetchRecentlyViewed(completion: @escaping ([Product]) -> Void) {
        fetchFromCoreData { (recentlyVieweds) in
            addRecentlyViewed(recentlyVieweds) { (products) in
                completion(products)
            }
        }
    }
}

extension RecentlyViewedModel: Equatable {}
func ==(lhs: RecentlyViewedModel, rhs: RecentlyViewedModel) -> Bool {
    return lhs.prUID == rhs.prUID
}
