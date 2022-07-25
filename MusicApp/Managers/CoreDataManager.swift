//
//  CoreDataManager.swift
//  MusicApp
//
//  Created by Aleksandr on 22.07.2022.
//

import Foundation
import CoreData

class CoreDataManager {

    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MusicApp")
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
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return CoreDataManager.persistentContainer.viewContext
    }

    // MARK: - Core Data Saving support

    static func saveContext () {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataManager {
    
    static func getAllLocations() -> [Location] {

        let request = LocationCoreData.fetchRequest()
        
        do {
            let locations = try context.fetch(request)
            return Location.fetchFromCoreDataLocations(locations)
        } catch {
            print(error.localizedDescription)
            return [Location]()
        }
    }
    static func getAllLocations() -> [LocationCoreData] {

        let request = LocationCoreData.fetchRequest()
        
        do {
            let locations = try context.fetch(request)
            return locations
        } catch {
            print(error.localizedDescription)
            return [LocationCoreData]()
        }
    }
    
    static func saveLocation(_ location: Location) {
        let _ = location.transformToCoreDataLocation(with: context)
 
        CoreDataManager.saveContext()
    }
    
    static func deleteLocation(_ location: Location) {
  
        let request = LocationCoreData.fetchRequest()
        
        do {
            
            let locations = try context.fetch(request)
            let neededLocation = locations.first { loc in
                return loc.lat == location.lat &&
                loc.lon == location.lon &&
                loc.name == location.name &&
                loc.region == location.region &&
                loc.country == location.country
            }

            if let neededLocation = neededLocation {
                context.delete(neededLocation)
                
                CoreDataManager.saveContext()
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func deleteLocation(_ location: LocationCoreData) {
        
        context.delete(location)
        
        CoreDataManager.saveContext()
    }
    
    static func updateLocation() {
        
    }
    
    static func deleteAllLocations() {
        let locations: [LocationCoreData] = CoreDataManager.getAllLocations()
        for location in locations {
            CoreDataManager.deleteLocation(location)
        }
    }
    
    static func updateLocationsIndices(with locations: [Location]) {
        
        CoreDataManager.deleteAllLocations()
        for location in locations {
            CoreDataManager.saveLocation(location)
        }
        CoreDataManager.saveContext()
    }
    
}
