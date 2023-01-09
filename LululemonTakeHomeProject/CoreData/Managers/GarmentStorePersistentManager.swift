//
//  GarmentStorePersistentManager.swift
//  LululemonTakeHomeProject
//
//  Created by Samuel Adama on 1/6/23.
//

import Foundation
import CoreData

class GarmentStorePersistentManager {
    var persistentContainer: NSPersistentContainer

    init() {
        persistentContainer = NSPersistentContainer(name: "GarmentStore")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error Loading: \(error.localizedDescription)")
            }
        }
    }
    
    // used to save to Core data
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // print error
                print("Failed to save garment: \(error.localizedDescription)")
            }
        }
    }
    
    func updateGarment() {
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
    
    // delete garment using slide to delete in UI
    func deleteGarment(clothes: Garment) {
        
        persistentContainer.viewContext.delete(clothes)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed: \(error)")
        }
        
    }
    
    // add new garment and save it to core data
    func addNewGarment(_ name: String){
        let garmentData = Garment(context: persistentContainer.viewContext)
        garmentData.name = name
        garmentData.dateCreated = Date()
        saveContext()
    }
    
    // fetch all Garments
    func getAllGarments() -> [Garment] {
        let fetchRequest: NSFetchRequest<Garment> = Garment.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
