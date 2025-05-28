//
//  DelegaeManager.swift
//  CoreDataMemo
//
//  Created by Ko Minhyuk on 5/28/25.
//

import Foundation
import CoreData


class DataManager {
    
    static let shared = DataManager()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var list = [MEMOEntity]()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataMemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetch() {
        let request = MEMOEntity.fetchRequest()
        
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        
        request.sortDescriptors = [sortByDateDesc]
        
        do {
            list = try DataManager.shared.mainContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func insertMemo(memo: String) {
        let newMemo = MEMOEntity(context: mainContext)
        newMemo.content = memo
        newMemo.insertDate = .now
        
        saveContext()
        
        list.insert(newMemo, at: 0)
        
        NotificationCenter.default.post(name: .memoDidInsert, object: nil)
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
