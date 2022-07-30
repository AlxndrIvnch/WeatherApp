//
//  CLLocationCoordinate2D + extension.swift
//  MusicApp
//
//  Created by Aleksandr on 29.07.2022.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
}
