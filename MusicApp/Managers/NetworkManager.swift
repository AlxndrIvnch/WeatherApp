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
    
    static private func getUrl(for request: RequestType, and text: String, language: Language = .ukrainian) -> URL? {
        guard let httpsQ = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        switch request {
        case .search:
            return URL(string: rootUrl + "\(request.rawValue).json?key=\(accessKey)&q=\(httpsQ)") //&lang=\(language.rawValue)
        case .forecast:
            return URL(string: rootUrl + "\(request.rawValue).json?key=\(accessKey)&q=\(httpsQ)&days=10") //&lang=\(language.rawValue)
        }
    }

    static private func decode<T: Decodable>(form data: Data) -> Result<T, Error> {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
    
    static func request<T: Decodable>(for type: RequestType, with text: String, and language: Language = .ukrainian , handler: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = getUrl(for: type, and: text, language: language) else { return }
        
        AF.request(url, method: .get, headers: .default).responseData { response in
            
            switch response.result {
            case .success(let data): handler(decode(form: data))
            case .failure(let error): handler(.failure(error))
            }
        }.resume()
    }
    
    static func groupRequest<T: Decodable>(for type: RequestType, with texts: [String], and language: Language = .ukrainian , handler: @escaping ([T]) -> ()) {
        
        let dispatchGroup = DispatchGroup()
        
        var results = [T]()
        
        for text in texts {
            dispatchGroup.enter()
            
            request(for: type, with: text) { (result : Result<T, Error>) in
                switch result {
                case .success(let success):
                    results.append(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            handler(results)
        }
    }
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
