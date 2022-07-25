//
//  DayForecastCell.swift
//  MusicApp
//
//  Created by Aleksandr on 20.07.2022.
//

import UIKit

class DayForecastCell: UICollectionViewCell {

    static let identifire = "DayForecastCell"
    
    var model: DayForecastGroup!
    
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var minMaxTemp: UILabel!
    @IBOutlet weak var chanceLable: UILabel!
    
    @IBOutlet weak var chanceHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(with model: DayForecastGroup, and location: Location?) {
        self.model = model
        
        if let date = model.getDate() {
            let weekdayNumber = date.weekDay
            let weekday: String
            switch weekdayNumber {
            case 1: weekday = "Sun"
            case 2: weekday = "Mon"
            case 3: weekday = "Tue"
            case 4: weekday = "Wed"
            case 5: weekday = "Thu"
            case 6: weekday = "Fri"
            case 7: weekday = "Sat"
            default: weekday = ""
            }
            dateLable.text = location?.getDate()?.weekDay == date.weekDay ? "Today" : "\(weekday)"
        }
        
        model.day?.condition?.getImage(handler: { [weak self] image in
            guard let image = image else { return }
            self?.imageView.image = image
        })
        
        let maxTemp = model.day?.maxtemp_c
        let minTemp = model.day?.mintemp_c
        minMaxTemp.text = "min.: \(Int(minTemp ?? 0))° max.: \(Int(maxTemp ?? 0))°"
        
        if let chanceOfSnow = model.day?.daily_chance_of_snow, chanceOfSnow > 0 {
            chanceLable.text = "\(chanceOfSnow)%"
        } else if let chanceOfRain = model.day?.daily_chance_of_rain, chanceOfRain > 0 {
            chanceLable.text = "\(chanceOfRain)%"
        } else {
            chanceLable.text = nil
        }
        
        chanceHeightConstraint.constant = (chanceLable.text ?? "").isEmpty ? 0 : 12
    }

}
