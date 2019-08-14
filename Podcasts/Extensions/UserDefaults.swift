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
