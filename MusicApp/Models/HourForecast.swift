//
//  HourForecast.swift
//  MusicApp
//
//  Created by Aleksandr on 19.07.2022.
//

import Foundation

struct HourForecast: Decodable, Hashable {
    
    var time: String?
    let condition: Condition?
    let temp_c: Double?
    let is_day: Int?
    let chance_of_rain: Int?
    let chance_of_snow: Int?
  
    func getDate() -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        guard let time = time else { return nil }
        if let date = dateFormatter.date(from: time) {
            return date
        }
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.date(from: time)
    }
    
    mutating func setCurrent() {
        time = "Now"
    }
}
