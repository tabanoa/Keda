//
//  EmailList+CoreDataProperties.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import CoreData


extension EmailList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmailList> {
        return NSFetchRequest<EmailList>(entityName: "EmailList")
    }

    @NSManaged public var email: String
    @NSManaged public var password: String

}
