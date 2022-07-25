//
//  CurrentWeatherCell.swift
//  MusicApp
//
//  Created by Aleksandr on 20.07.2022.
//

import UIKit

class CurrentWeatherCell: UICollectionViewCell {

    static let identifire = "CurrentWeatherCell"
    
    var model: CurrentWeather!
    
    @IBOutlet weak var lable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = #colorLiteral(red: 0.4629999995, green: 0.4629999995, blue: 0.5019999743, alpha: 0.4)
        layer.cornerRadius = 15
    }
    
    func setup(with model: CurrentWeather, and itemNumber: Int) {
        self.model = model
        
        lable.text = {
            switch itemNumber {
            case 0:
                return String(model.uv ?? 0)
            case 1:
                return String(model.wind_kph ?? 0) + " km/h"
            case 2:
                return String(model.precip_mm ?? 0) + " mm"
            case 3:
                return String(model.temp_c ?? 0) + " ℃"
            case 4:
                return String(model.humidity ?? 0) + " %"
            case 5:
                return String(model.vis_km ?? 0) + " km"
            case 6:
                return String(model.pressure_mb ?? 0) + " mb"
            default:
                return ""
            }
        }()
        
        
    }

}
