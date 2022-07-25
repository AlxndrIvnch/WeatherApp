//
//  Date + extension .swift
//  MusicApp
//
//  Created by Aleksandr on 22.07.2022.
//

import Foundation

extension Date {
    var time: Time {
        return Time(self)
    }
    
    var weekDay: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
}
