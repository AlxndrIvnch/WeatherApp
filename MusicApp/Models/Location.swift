//
//  Location.swift
//  MusicApp
//
//  Created by Aleksandr on 19.07.2022.
//

import Foundation
import CoreData
import MapKit

struct Location: Decodable, Equatable {
    let name: String?
    let region: String?
    let country: String?
    let lat: Double?
    let lon: Double?
    let tz_id: String?
    let localtime: String?
    
    init(_ location: LocationCoreData) {
        self.lat = location.lat
        self.lon = location.lon
        self.name = location.name
        self.region = location.region
        self.country = location.country
        self.tz_id = nil
        self.localtime = nil
    }
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.lat == rhs.lat && lhs.lon == rhs.lon || lhs.getNameRegionCountryString() == rhs.getNameRegionCountryString()
    }
    
    static func fetchFromCoreDataLocations(_ locations: [LocationCoreData]) -> [Location] {
        return locations.map { Location($0) }
    }
    
    func transformToCoreDataLocation(with context: NSManagedObjectContext) -> LocationCoreData {
        let locationCoreData = LocationCoreData(context: context)
        locationCoreData.lon = self.lon ?? 0
        locationCoreData.lat = self.lat ?? 0
        locationCoreData.country = self.country
        locationCoreData.name = self.name
        locationCoreData.region = self.region
        return locationCoreData
    }
    
    func getNameRegionCountryString() -> String {
        return "\(name ?? ""),\(region ?? ""),\(country ?? "")"
    }
    
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm"
        guard let dateString = localtime else { return nil }
        let date = dateFormatter.date(from: dateString)
        return date
    }
    
    func getCLLocation() -> CLLocationCoordinate2D? {
        guard let latitude = self.lat, let longitude = self.lon else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
