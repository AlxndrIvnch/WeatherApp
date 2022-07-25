//
//  Condition.swift
//  MusicApp
//
//  Created by Aleksandr on 20.07.2022.
//

import Foundation
import UIKit
import Alamofire

struct Condition: Decodable, Hashable {
    let code: Int?
    let icon: String?
    let text: String?
    
    func getImage(handler: @escaping (UIImage?) -> ())  {

        guard let icon = icon else { fatalError() }
        
        if let image = UIImage(systemName: icon) {
            
            handler(image.withTintColor(.systemYellow, renderingMode: .alwaysOriginal))
            return
        }
        
        guard let url = URL(string: "https:" + icon) else { fatalError() }

        AF.request(url).responseData { response in
            switch response.result {
            case .failure(let error):
                print(error)
                handler(nil)
            case .success(let data):
                handler(UIImage(data: data))
            }
        }.resume()
    }
}
