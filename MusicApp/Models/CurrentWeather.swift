//
//  CurrentWeather.swift
//  MusicApp
//
//  Created by Aleksandr on 20.07.2022.
//

import Foundation

struct CurrentWeather: Decodable, Hashable {
    
//    var id: String? = UUID().uuidString
    
    let cloud: Double?
    let condition: Condition?
    let temp_c: Double?
    let feelslike_c: Double?
    let gust_kph: Double?
    let humidity: Double?
    let precip_mm: Double?
    let pressure_mb: Int?
    let uv: Int?
    let vis_km: Int?
    let wind_degree: Int?
    let wind_dir: String?
    let wind_kph: Double?
    
}
