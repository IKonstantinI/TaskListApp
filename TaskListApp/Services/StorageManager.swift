//
//  StorageManager.swift
//  TaskListApp
//
//  Created by horze on 12.02.2024.
//

import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "TaskListApp")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    func fetchEntities<T: NSManagedObject>(ofType type: T.Type) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: type))
        
        do {
            let entities = try persistentContainer.viewContext.fetch(fetchRequest)
            return entities
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }
    
    func saveContext() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }
    
    func deleteEntity(_ entity: NSManagedObject) {
        persistentContainer.viewContext.delete(entity)
        saveContext()
    }
    
    func updateEntity<T: NSManagedObject>(_ entity: T, withValues values: [String: Any]) {
        for (key, value) in values {
            entity.setValue(value, forKey: key)
        }
        saveContext()
    }
}
