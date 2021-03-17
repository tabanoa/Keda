//
//  CoreDataStack.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import CoreData

class CoreDataStack {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                print("Load Error: \(error)")
            }
        }
        
        return container
    }()
    
    func saveContext() {
        guard managedObjectContext.hasChanges else { return }
        do {
            try managedObjectContext.save()
            
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
}
