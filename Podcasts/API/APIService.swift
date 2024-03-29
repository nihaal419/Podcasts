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

extension Notification.Name {
    static let downloadProgress = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")
}

class APIService {
    
    typealias EpisodeDownloadCompleteTuple = (fileUrl: String,
                                              episodeTitle: String)
    let baseiTunesSearchUrl = "https://itunes.apple.com/search?term="
    
    static let shared = APIService()
    
    func downloadEpisode(episode: Episode) {
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        
        Alamofire.download(episode.streamUrl, to: downloadRequest).downloadProgress { (progress) in
            NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title" : episode.title, "progress": progress.fractionCompleted])
            }.response { (response) in
                print(response.destinationURL?.absoluteString ?? "")
                
                let episodeDownloadComplete = EpisodeDownloadCompleteTuple(response.destinationURL?.absoluteString ?? "", episode.title)
                NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete, userInfo: nil)
                
                var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
                guard let index = downloadedEpisodes.lastIndex(where: { $0.title == episode.title && $0.author == episode.author}) else {return}
                downloadedEpisodes[index].fileUrl = response.destinationURL?.absoluteString ?? ""
                
                do {
                    let data = try JSONEncoder().encode(downloadedEpisodes)
                    UserDefaults.standard.set(data , forKey: UserDefaults.downloadedEpisodesKey)
                } catch let err {
                    print("Failed to encode episodes with file url update", err)
                }
        }
    }
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        guard let url = URL(string: feedUrl.toSecureHTTPS()) else {return}
        
        DispatchQueue.global(qos: .background).async {
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
