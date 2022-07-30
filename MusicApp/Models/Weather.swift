//
//  ServerResponse.swift
//  MusicApp
//
//  Created by Aleksandr on 20.07.2022.
//

import Foundation
import MapKit

struct Weather: Decodable {
    let location: Location?
    let current: CurrentWeather?
    let forecast: Forecast?
}
	
