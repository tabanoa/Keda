//
//  RecentSearches+CoreDataProperties.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import Foundation
import CoreData


extension RecentSearches {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentSearches> {
        return NSFetchRequest<RecentSearches>(entityName: "RecentSearches")
    }

    @NSManaged public var tag: String
    @NSManaged public var createdTime: String

}
