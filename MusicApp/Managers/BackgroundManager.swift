//
//  BackgroundManager.swift
//  MusicApp
//
//  Created by Aleksandr on 24.07.2022.
//

import Foundation
import UIKit

class BackgroundManager {
    
    static func getColor(with code: Int) -> UIColor {
        switch code {
        case 1000: return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        case 1003: return #colorLiteral(red: 0.4149263412, green: 0.7431894273, blue: 0.8665561869, alpha: 1)
        case 1006: return #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        case 1009: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        case 1030: return #colorLiteral(red: 0.4357018693, green: 0.4717439352, blue: 0.5241041042, alpha: 1)
        case 1063: return #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        case 1066: return #colorLiteral(red: 0.5635466454, green: 0.7376252538, blue: 0.8283617424, alpha: 1)
        case 1069: return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        case 1072: return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case 1087: return #colorLiteral(red: 0.03654271616, green: 0.03249125686, blue: 0.2433173734, alpha: 1)
        case 1114: return #colorLiteral(red: 0.202882173, green: 0.4286299599, blue: 0.787244704, alpha: 1)
        case 1117: return #colorLiteral(red: 0.6343200005, green: 0.7863181116, blue: 1, alpha: 1)
        case 1135: return #colorLiteral(red: 0.4357018693, green: 0.4717439352, blue: 0.5241041042, alpha: 1)
        case 1147: return #colorLiteral(red: 0.4955134325, green: 0.6270385115, blue: 0.75611168, alpha: 1)
        case 1150: return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case 1153: return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case 1168: return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case 1171: return #colorLiteral(red: 0.19487211, green: 0.5696218733, blue: 0.8240214646, alpha: 1)
        case 1180...1201: return #colorLiteral(red: 0.1344702649, green: 0.8357665325, blue: 1, alpha: 1)
        case 1204: return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        case 1207: return #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        case 1210...1219: return #colorLiteral(red: 0.7913018438, green: 1, blue: 0.9467291958, alpha: 1)
        case 1222...1225: return #colorLiteral(red: 0.6820450605, green: 0.7415351161, blue: 0.8476957071, alpha: 1)
        case 1237: return #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        case 1240: return #colorLiteral(red: 0.4629999995, green: 0.4629999995, blue: 0.5019999743, alpha: 0.4)
        case 1243, 1252, 1258, 1264, 1276, 1282: return #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        case 1246, 1249, 1261, 1273, 1279: return #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        default: return  #colorLiteral(red: 0.202882173, green: 0.4286299599, blue: 0.787244704, alpha: 1)
            
        }
    }
}
