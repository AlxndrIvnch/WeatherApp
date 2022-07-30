//
//  UvCell.swift
//  MusicApp
//
//  Created by Aleksandr on 23.07.2022.
//

import UIKit

class UvCell: UICollectionViewCell {
    
    static let identifire = "UvCell"

    @IBOutlet weak var uvLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var model: CurrentWeather!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 15

    }

    func setup(with model: CurrentWeather) {
        self.model = model
        uvLable.text = String(model.uv ?? 0)
        descriptionLable.text = uvLevel(model.uv)
        progressView.progress = Float(model.uv ?? 0) / 12
        progressView.progressTintColor = uvColoe(model.uv)
    }
    
    private func uvLevel(_ uv: Int?) -> String? {
        	
        guard uv ?? -1 >= 0 else { return nil }

        switch uv! {
        case 0...2: return "Low"
        case 3...5: return "Moderate"
        case 6...7: return "High"
        case 8...10: return "Very high"
        default: return "Excessive"
        }
    }
    
    private func uvColoe(_ uv: Int?) -> UIColor {
            
        guard uv ?? -1 >= 0 else { return .link }

        switch uv! {
        case 0...2: return .green
        case 3...5: return .yellow
        case 6...7: return .orange
        case 8...10: return .red
        default: return .purple
        }
    }
    
}
