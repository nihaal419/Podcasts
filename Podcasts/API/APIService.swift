//
//  APIService.swift
//  Podcasts
//
//  Created by Nihaal Manesia on 7/31/19.
//  Copyright © 2019 Nihaal Manesia. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    let baseiTunesSearchUrl = "https://itunes.apple.com/search?term="
    
    static let shared = APIService()
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        let parameters = ["term": searchText, "media": "podcast"]
        
        Alamofire.request(baseiTunesSearchUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).response { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect", err)
                return
            }
            
            guard let data = dataResponse.data else {return}
            
            do{
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                completionHandler(searchResult.results)
            } catch let decodeErr{
                print("Failed to decode:", decodeErr)
            }
        }
    }
    
    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
    
}
