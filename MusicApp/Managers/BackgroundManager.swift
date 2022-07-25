//
//  BackgroundManager.swift
//  MusicApp
//
//  Created by Aleksandr on 24.07.2022.
//

import Foundation
import UIKit

class BackgroundManager {
    
    static func getColor(with code: Int, and isDay: Bool) -> UIColor {
        switch code {
        case 1000: return isDay ? #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1) : #colorLiteral(red: 0.3523080085, green: 0.2849936032, blue: 0.1297192079, alpha: 1)
        case 1003: return isDay ? #colorLiteral(red: 0.4149263412, green: 0.7431894273, blue: 0.8665561869, alpha: 1) : #colorLiteral(red: 0.2900075417, green: 0.5166067769, blue: 0.6092960859, alpha: 1)
        case 1006: return isDay ? #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1) : #colorLiteral(red: 0.04165146611, green: 0.1307870883, blue: 0.1811655156, alpha: 1)
        case 1009: return isDay ? #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) : #colorLiteral(red: 0.1962492661, green: 0.212483369, blue: 0.236067488, alpha: 1)
        case 1030: return isDay ? #colorLiteral(red: 0.4357018693, green: 0.4717439352, blue: 0.5241041042, alpha: 1) : #colorLiteral(red: 0.2714129455, green: 0.2953709332, blue: 0.3319481699, alpha: 1)
        case 1063: return isDay ? #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) : #colorLiteral(red: 0.1173858396, green: 0.3342053288, blue: 0.5142017748, alpha: 1)
        case 1066: return isDay ? #colorLiteral(red: 0.5635466454, green: 0.7376252538, blue: 0.8283617424, alpha: 1) : #colorLiteral(red: 0.4153029181, green: 0.5452701491, blue: 0.616082702, alpha: 1)
        case 1069: return isDay ? #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) : #colorLiteral(red: 0.3079106111, green: 0.5515097212, blue: 0.6430583421, alpha: 1)
        case 1072: return isDay ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.1189817216, green: 0.3477901028, blue: 0.5031171086, alpha: 1)
        case 1087: return isDay ? #colorLiteral(red: 0.03654271616, green: 0.03249125686, blue: 0.2433173734, alpha: 1) : #colorLiteral(red: 0.02332908345, green: 0.02064462285, blue: 0.1628249492, alpha: 1)
        case 1114: return isDay ? #colorLiteral(red: 0.202882173, green: 0.4286299599, blue: 0.787244704, alpha: 1) : #colorLiteral(red: 0.1254889128, green: 0.2689273692, blue: 0.5, alpha: 1)
        case 1117: return isDay ? #colorLiteral(red: 0.6343200005, green: 0.7863181116, blue: 1, alpha: 1) : #colorLiteral(red: 0.4246007596, green: 0.5281793643, blue: 0.6768465909, alpha: 1)
        case 1135: return isDay ? #colorLiteral(red: 0.4357018693, green: 0.4717439352, blue: 0.5241041042, alpha: 1) : #colorLiteral(red: 0.2798009464, green: 0.3044993542, blue: 0.3422070082, alpha: 1)
        case 1147: return isDay ? #colorLiteral(red: 0.4955134325, green: 0.6270385115, blue: 0.75611168, alpha: 1) : #colorLiteral(red: 0.3242799183, green: 0.4117258878, blue: 0.5, alpha: 1)
        case 1150: return isDay ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.1372511608, green: 0.4011926761, blue: 0.5803698771, alpha: 1)
        case 1153: return isDay ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.1431297965, green: 0.4183762511, blue: 0.6052278317, alpha: 1)
        case 1168: return isDay ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.1443428484, green: 0.4219220682, blue: 0.6103572509, alpha: 1)
        case 1171: return isDay ? #colorLiteral(red: 0.19487211, green: 0.5696218733, blue: 0.8240214646, alpha: 1) : #colorLiteral(red: 0.09780724866, green: 0.2972376812, blue: 0.4298453282, alpha: 1)
        case 1180...1201: return isDay ? #colorLiteral(red: 0.1344702649, green: 0.8357665325, blue: 1, alpha: 1) : #colorLiteral(red: 0.08664784461, green: 0.5577323158, blue: 0.6717171717, alpha: 1)
        case 1204: return isDay ? #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.349483758, green: 0.2225691375, blue: 0.6154866701, alpha: 1)
        case 1207: return isDay ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.2455180479, green: 0.04192761905, blue: 0.6604677307, alpha: 1)
        case 1210...1219: return isDay ? #colorLiteral(red: 0.7913018438, green: 1, blue: 0.9467291958, alpha: 1) : #colorLiteral(red: 0.4461912308, green: 0.5659722222, blue: 0.5392361113, alpha: 1)
        case 1222...1225: return isDay ? #colorLiteral(red: 0.6820450605, green: 0.7415351161, blue: 0.8476957071, alpha: 1) : #colorLiteral(red: 0.4626006657, green: 0.5034308929, blue: 0.579782197, alpha: 1)
        case 1237: return isDay ? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1) : #colorLiteral(red: 0.1432514697, green: 0.001991485951, blue: 0.5826481815, alpha: 1)
        case 1240: return isDay ? #colorLiteral(red: 0.4629999995, green: 0.4629999995, blue: 0.5019999743, alpha: 0.4) : #colorLiteral(red: 0.318173979, green: 0.3180579107, blue: 0.3453554036, alpha: 0.4)
        case 1243, 1252, 1258, 1264, 1276, 1282: return isDay ? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1) : #colorLiteral(red: 0.1580940348, green: 0.002197827707, blue: 0.6430174997, alpha: 1)
        case 1246, 1249, 1261, 1273, 1279: return isDay ? #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1) : #colorLiteral(red: 0.03938358853, green: 0.1236658719, blue: 0.1713012479, alpha: 1)
        default: return isDay ? #colorLiteral(red: 0.202882173, green: 0.4286299599, blue: 0.787244704, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        }
    }
}
