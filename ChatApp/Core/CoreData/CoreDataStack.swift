//
//  CoreDataStack.swift
//  ChatApp
//
//  Created by Иван Лебедев on 20/03/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataStack {
    
    var storeUrl: URL { get }
    
    var managedObjectModel: NSManagedObjectModel { get set }
    
    var persistentStoreCoordinator: NSPersistentStoreCoordinator { get set }
    
    var mainContext: NSManagedObjectContext { get set }
    
    var masterContext: NSManagedObjectContext { get set }
    
    var saveContext: NSManagedObjectContext { get set }
    
    func performSave(with context: NSManagedObjectContext, completion: (() -> Void)?)
}

class CoreDataStack: ICoreDataStack {

    var storeUrl: URL {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory,
                                                         in: .userDomainMask).first else {
                                                            fatalError("Bad document URL")
        }
        return documentUrl.appendingPathComponent("MyStore.sqlite")
    }

    let dataModelName = "ChatApp"
    let dataModelExtension = "momd"

    lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelUrl = Bundle.main.url(forResource: self.dataModelName,
                                             withExtension: self.dataModelExtension) else {
                                                fatalError("Bad model url")
        }
        guard let managedModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("Can't create managedObjectModel")
        }
        return managedModel
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
                Debugger.shared.dbprint("performSave ERROR:\n\(err)")
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
