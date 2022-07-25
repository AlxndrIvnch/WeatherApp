//
//  HourForecastCell.swift
//  MusicApp
//
//  Created by Aleksandr on 19.07.2022.
//

import UIKit

class HourForecastCell: UICollectionViewCell {
    
    static let identifire = "HourForecastCell"
    
    var model: HourForecast!
  
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var tempLable: UILabel!
    @IBOutlet weak var chanceLable: UILabel!
    
    @IBOutlet weak var chanceHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(with hourForecast: HourForecast) {
        self.model = hourForecast
        
        if let date = hourForecast.getDate() {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            timeLable.text = hour >= 10 ? String(hour) : "0\(hour)"
        } else {
            timeLable.text = hourForecast.time
        }
        
        if let temp = hourForecast.temp_c {
            tempLable.text = String(Int(temp)) + "°"
        } else {
            tempLable.text = hourForecast.condition?.text
        }
        
        hourForecast.condition?.getImage(handler: { [weak self] image in
            self?.imageView.image = image
        })
        
        if let chanceOfSnow = model.chance_of_snow, chanceOfSnow > 0 {
            chanceLable.text = "\(chanceOfSnow)%"
        } else if let chanceOfRain = model.chance_of_rain, chanceOfRain > 0 {
            chanceLable.text = "\(chanceOfRain)%"
        } else {
            chanceLable.text = nil
        }
        
        chanceHeightConstraint.constant = (chanceLable.text ?? "").isEmpty ? 0 : 12
        
    }

}
