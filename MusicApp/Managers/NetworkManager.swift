//
//  NetworkManager.swift
//  MusicApp
//
//  Created by Aleksandr on 20.07.2022.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static private let accessKey = "52d2cc82ddb84564be7122731221707"
    static private let rootUrl = "https://api.weatherapi.com/v1/"
    
    static func getUrl(for request: RequestType, and text: String, language: Language = .ukrainian) -> URL? {
        guard let httpsQ = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        switch request {
        case .search:
            return URL(string: rootUrl + "\(request.rawValue).json?key=\(accessKey)&q=\(httpsQ)") //&lang=\(language.rawValue)
        case .forecast:
            return URL(string: rootUrl + "\(request.rawValue).json?key=\(accessKey)&q=\(httpsQ)&days=10") //&lang=\(language.rawValue)
        }
    }
    
    static func request(for type: RequestType, with text: String, and language: Language = .ukrainian , handler: @escaping (Data?) -> ()) {
            
            guard let url = getUrl(for: type, and: text, language: language) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = ["Content-Type": "application/json; Charset=UTF-8"]
            
            AF.request(request).responseData { response in
                
                switch response.result {
                case .success(let data):
                    handler(data)
                case .failure(let error):
                    print(error.localizedDescription)
                    handler(nil)
                }
            }.resume()
        }
    
//    static func chainRequest(for type: RequestType, with texts: [String], and language: Language = .ukrainian , handler: @escaping ([Data?]) -> ()) {
//        var dataArray = [Data?]()
//        var qs = texts
//        guard !qs.isEmpty, let url = getUrl(for: type, and: qs.removeFirst(), language: language) else {
//            handler([Data]())
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = ["Content-Type": "application/json; Charset=UTF-8"]
//
//        AF.request(request).responseData { response in
//
//            switch response.result {
//            case .success(let data):
//                dataArray.append(data)
//            case .failure(let error):
//                print(error.localizedDescription)
//                dataArray.append(nil)
//            }
//
//            NetworkManager.chainRequest(for: type, with: qs) { data in
//                dataArray.append(contentsOf: data)
//                handler(dataArray)
//            }
//        }.resume()
//    }
    
}

extension NetworkManager {
    
    enum RequestType: String {
        case search
        case forecast
    }
    enum Language: String {
        case arabic = "ar"
        case bengali = "bn"
        case bulgarian = "bg"
        case chinese = "zh" //Simplified
        case czech = "cs"
        case danish = "da"
        case dutch = "nl"
        case finnish = "fi"
        case french = "fr"
        case german  = "de"
        case greek = "el"
        case hindi = "hi"
        case hungarian = "hu"
        case italian = "it"
        case japanese  = "ja"
        case javanese = "jv"
        case korean = "ko"
        case mandarin = "zh_cmn"
        case marathi = "mr"
        case polish = "pl"
        case portuguese = "pt"
        case punjabi = "pa"
        case romanian = "ro"
        case russian = "ru"
        case serbian = "sr"
        case sinhalese = "si"
        case slovak  = "sk"
        case spanish = "es"
        case swedish  = "sv"
        case tamil  = "ta"
        case telugu = "te"
        case turkish = "tr"
        case ukrainian = "uk"
        case urdu = "ur"
        case vietnamese = "vi"
        case wu = "zh_wuu" //Shanghainese)
        case xiang = "zh_hsn"
        case yue = "zh_yue" //Cantonese
        case zulu  = "zu"
    }
}
