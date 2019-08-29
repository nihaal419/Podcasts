//
//  Episode.swift
//  Podcasts
//
//  Created by Nihaal Manesia on 8/2/19.
//  Copyright © 2019 Nihaal Manesia. All rights reserved.
//

import Foundation
import FeedKit

struct Episode: Codable {
    let title: String
    let author: String
    let pubDate: Date
    let description: String
    let streamUrl: String
    
    var fileUrl: String?
    var imageUrl: String?
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
    }
}
