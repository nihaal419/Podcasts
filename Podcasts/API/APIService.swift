//
//  APIService.swift
//  Podcasts
//
//  Created by Nihaal Manesia on 7/31/19.
//  Copyright © 2019 Nihaal Manesia. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    let baseiTunesSearchUrl = "https://itunes.apple.com/search?term="
    
    static let shared = APIService()
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        guard let url = URL(string: feedUrl.toSecureHTTPS()) else {return}
        
        let parser = FeedParser(URL: url)
        parser.parseAsync { (result) in
            
            if let err = result.error {
                print("Failed to parse XML feed:", err)
            }
            
            guard let feed = result.rssFeed else {return}
            let episodes = feed.toEpisodes()
            completionHandler(episodes)
        }
    }
    
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
