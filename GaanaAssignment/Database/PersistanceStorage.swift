//
//  DatabaseHelper.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 19/12/20.
//

import Foundation
import CoreData

class PersistentStorage {
    
    static let sharedInstance = PersistentStorage()
    
    lazy var context: NSManagedObjectContext = {
        let persistoreStore = self.persistentContainer
        return persistoreStore.viewContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let persistoreStore = self.persistentContainer
        let backgroundContext = persistentContainer.newBackgroundContext()
        return backgroundContext
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "GaanaAssignment", withExtension: "momd")!
        let managedObjectModel  = NSManagedObjectModel(contentsOf: modelURL)!
        return managedObjectModel
    }()
    
    private lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("GaanaAssignment.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            // Configure automatic migration.
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "GaanaAssignment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        print(applicationDocumentsDirectory)
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let myContext = context
        if myContext.hasChanges {
            do {
                try myContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchManagedObject<T: NSManagedObject>(managedObjectType: T.Type) -> [T]? {
        do {
            let result = try PersistentStorage.sharedInstance.context.fetch(managedObjectType.fetchRequest()) as? [T]
            return result
        } catch let err {
            print(err.localizedDescription)
        }
        return nil
    }
    
    func fetchManagedObject<T: NSManagedObject>(predicate: NSPredicate?, managedObjectType: T.Type) -> [T]? {
        do {
            let request = managedObjectType.fetchRequest()
            let predicate = predicate
            request.predicate = predicate
            let result = try PersistentStorage.sharedInstance.context.fetch(request) as? [T]
            return result
        } catch let err {
            print(err.localizedDescription)
        }
        return nil
    }
   
    func deleteRecord<T: NSManagedObject>(predicate: NSPredicate?, managedObjectType: T.Type) -> Bool {
        let results = fetchManagedObject(predicate: predicate, managedObjectType: managedObjectType)
        guard let fetchResults = results, !fetchResults.isEmpty,
              let objectToDelete = fetchResults.first else { return false }
        context.delete(objectToDelete)
        saveContext()
        return true
    }
}
