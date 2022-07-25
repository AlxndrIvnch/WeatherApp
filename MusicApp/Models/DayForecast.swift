//
//  DayForecast.swift
//  MusicApp
//
//  Created by Aleksandr on 22.07.2022.
//

import Foundation


struct DayForecast: Decodable, Hashable {
    let maxtemp_c: Double?
    let mintemp_c: Double?
    let avgtemp_c: Double?
    let maxwind_kph: Double?
    let totalprecip_mm: Double?
    let avgvis_km: Double?
    let avghumidity: Int?
    let daily_will_it_rain: Int?
    let daily_chance_of_rain: Int?
    let daily_will_it_snow: Int?
    let daily_chance_of_snow: Int?
    let condition: Condition?
    let uv: Int?
    
    
}
