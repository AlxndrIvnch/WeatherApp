//
//  SearchCell.swift
//  MusicApp
//
//  Created by Aleksandr on 22.07.2022.
//

import UIKit

class SearchCell: UITableViewCell {
    
    static let identifire = "SearchCell"
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var cityNameLable: UILabel!
    @IBOutlet weak var minMaxTempLable: UILabel!
    @IBOutlet weak var tempLable: UILabel!
    
    var weatherModel: Weather! {
        didSet {
            if let code = weatherModel?.current?.condition?.code {
                self.containerView.backgroundColor = BackgroundManager.getColor(with: code)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.cornerRadius = 15
        descriptionLable.sizeToFit()
    }
    
    func setup(with weatherModel: Weather) {
        self.weatherModel = weatherModel
        
        cityNameLable.text = weatherModel.location?.name
        descriptionLable.text = weatherModel.current?.condition?.text
        minMaxTempLable.text = "Max.: \(Int(weatherModel.forecast?.forecastday?.first?.day?.maxtemp_c ?? 0))°, min.: \(Int(weatherModel.forecast?.forecastday?.first?.day?.mintemp_c ?? 0))°"
        tempLable.text = "\((weatherModel.current?.temp_c ?? 0))°"
    }
    
    
}
