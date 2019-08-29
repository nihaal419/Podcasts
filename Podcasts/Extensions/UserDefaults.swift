//
//  UserDefaulsts.swift
//  Podcasts
//
//  Created by Nihaal Manesia on 8/13/19.
//  Copyright © 2019 Nihaal Manesia. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favoritedPodcastKey = "favoritedPodcastKey"
    static let downloadedEpisodesKey = "downloadedEpisodesKey"
    
    func downloadEpisode(episode: Episode) {
        do {
            var episodes = downloadedEpisodes()
            episodes.insert(episode, at: 0)
            let data = try JSONEncoder().encode(episodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let encodeErr {
            print("Failed to encode episodes", encodeErr)
        }
    }
    
    func downloadedEpisodes() -> [Episode] {
        guard let episodesData = data(forKey: UserDefaults.downloadedEpisodesKey) else {return []}
        do {
            let episodes = try JSONDecoder().decode([Episode].self, from: episodesData)
            return episodes
        } catch let decodeErr {
            print("Failed to decode episodes", decodeErr)
        }
        return []
    }
    
    func removeDownloadedEpisode(index: Int) -> [Episode] {
        var episodes = downloadedEpisodes()
        episodes.remove(at: index)
        do{
            let data = try JSONEncoder().encode(episodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let encodeErr {
            print("Error encoding podcasts", encodeErr)
        }
        return episodes
    }
    
    func savedPodcasts() -> [Podcast] {
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else {return []}
        guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savedPodcastsData) as? [Podcast] else {return []}
        return savedPodcasts
    }
    
//    func removePodcasts(index: Int) {
//        var podcasts = savedPodcasts()
//        podcasts.remove(at: index)
//        let data = NSKeyedArchiver.archivedData(withRootObject: podcasts)
//        UserDefaults.standard.setValue(data, forKey: UserDefaults.favoritedPodcastKey)
//    }

}
