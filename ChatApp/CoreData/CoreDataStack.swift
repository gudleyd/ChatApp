//
//  CoreDataStack.swift
//  ChatApp
//
//  Created by Иван Лебедев on 20/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

    var storeUrl: URL {
        let documentUrl = FileManager.default.urls(for: .documentDirectory,
                                                   in: .userDomainMask).first!
        return documentUrl.appendingPathComponent("MyStore.sqlite")
    }

    let dataModelName = "ChatApp"
    let dataModelExtension = "momd"

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelUrl = Bundle.main.url(forResource: self.dataModelName,
                                       withExtension: self.dataModelExtension)
        return NSManagedObjectModel(contentsOf: modelUrl!)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: storeUrl,
                                               options: nil)

        } catch {
            assert(false, "Error adding store: \(error)")
        }
        return coordinator
    }()

    lazy var masterContext: NSManagedObjectContext = {
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy

        return masterContext
    }()

    lazy var mainContext: NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = self.masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy

        return mainContext
    }()

    lazy var saveContext: NSManagedObjectContext = {
        var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        saveContext.parent = self.mainContext
        saveContext.mergePolicy = NSOverwriteMergePolicy

        return saveContext
    }()

    typealias SaveCompletion = () -> Void
    func performSave(with context: NSManagedObjectContext, completion: SaveCompletion? = nil ) {
        context.performAndWait {
            guard context.hasChanges else {
                completion?()
                return
            }
        }

        context.perform {
            do {
                try context.save()
            } catch let err {
                print("performSave ERROR:\n\(err)")
            }

            if let parentContext = context.parent {
                self.performSave(with: parentContext, completion: completion)
            } else {
                DispatchQueue.main.async {
                    completion?()
                }
            }

        }
    }
}
