//
//  AstroForecast.swift
//  MusicApp
//
//  Created by Aleksandr on 22.07.2022.
//

import Foundation

struct AstroForecast: Decodable, Hashable {
    let sunrise: String?
    let sunset: String? // 08:40 PM HH:mm a
    let moonrise: String?
    let moonset: String?
    let moon_phase: String?
    let moon_illumination: String?
    
    func getDate(for event: Event) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        let time: String?
        
        switch event {
        case .sunrise:
            time = sunrise
        case .sunset:
            time = sunset
        case .moonrise:
            time = moonrise
        case .moonset:
            time = moonset
        }
        
        guard let time = time else { return nil }
        return dateFormatter.date(from: time)
    }
}

extension AstroForecast {
    enum Event {
        case sunrise
        case sunset
        case moonrise
        case moonset
    }
}
