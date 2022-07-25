//
//  DayForecastGroup.swift
//  MusicApp
//
//  Created by Aleksandr on 19.07.2022.
//

import Foundation

struct DayForecastGroup: Decodable, Hashable {
    let date: String?
    let day: DayForecast?
    let hour: [HourForecast]?
    let astro: AstroForecast?
    
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let dateString = date else { return nil }
        let date = dateFormatter.date(from: dateString)
        return date
    }
}
	
