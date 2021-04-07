//
//  RecentSearchesModel.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import CoreData

class RecentSearchesModel {
    
    var tag: String
    var createdTime: String
    
    init(tag: String, createdTime: String) {
        self.tag = tag
        self.createdTime = createdTime
    }
}

//MARK: - Fetch

extension RecentSearchesModel {
    
    class func fetchFromCoreData(completion: @escaping ([RecentSearchesModel]) -> Void) {
        var recentSearches: [RecentSearchesModel] = []
        
        let request: NSFetchRequest<RecentSearches> = RecentSearches.fetchRequest()
        do {
            let result = try appDl.coreDataStack.managedObjectContext.fetch(request)
            if result.count >= 10 {
                var recents = result.sorted(by: { $0.createdTime < $1.createdTime })
                let recent = recents.removeFirst()
                appDl.coreDataStack.managedObjectContext.delete(recent)
                appDl.coreDataStack.saveContext()
            }
            
            result.forEach({
                let recentSearch = RecentSearchesModel(tag: $0.tag, createdTime: $0.createdTime)
                recentSearches.append(recentSearch)
                recentSearches.sort(by: { $0.createdTime > $1.createdTime })
                completion(recentSearches)
            })
            
        } catch let error as NSError {
            print("Fetch recently viewed error: \(error.localizedDescription)")
        }
    }
    
    class func addRecentSearches(_ recentSearches: [RecentSearchesModel], completion: @escaping ([String]) -> Void) {
        var tags: [String] = []
        for recentSearch in recentSearches {
            if !tags.contains(recentSearch.tag) {
                tags.append(recentSearch.tag)
                completion(tags)
            }
        }
    }
    
    class func fetchRecentSearches(completion: @escaping ([String]) -> Void) {
        fetchFromCoreData { (recentlyVieweds) in
            addRecentSearches(recentlyVieweds) { (tags) in
                completion(tags)
            }
        }
    }
}

extension RecentSearchesModel: Equatable {}
func ==(lhs: RecentSearchesModel, rhs: RecentSearchesModel) -> Bool {
    return lhs.tag == rhs.tag
}
