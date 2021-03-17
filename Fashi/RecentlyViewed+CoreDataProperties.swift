//
//  RecentlyViewed+CoreDataProperties.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import Foundation
import CoreData


extension RecentlyViewed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentlyViewed> {
        return NSFetchRequest<RecentlyViewed>(entityName: "RecentlyViewed")
    }

    @NSManaged public var productUID: String
    @NSManaged public var createdTime: String

}
