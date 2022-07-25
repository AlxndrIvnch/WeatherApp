//
//  Forecast.swift
//  MusicApp
//
//  Created by Aleksandr on 19.07.2022.
//

import Foundation

struct Forecast: Decodable {
    
    let forecastday: [DayForecastGroup]?
    
}
