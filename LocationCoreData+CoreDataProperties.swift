//
//  LocationCoreData+CoreDataProperties.swift
//  MusicApp
//
//  Created by Aleksandr on 22.07.2022.
//
//

import Foundation
import CoreData


extension LocationCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationCoreData> {
        return NSFetchRequest<LocationCoreData>(entityName: "LocationCoreData")
    }

    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var name: String?
    @NSManaged public var region: String?
    @NSManaged public var country: String?

}

extension LocationCoreData : Identifiable {

}
