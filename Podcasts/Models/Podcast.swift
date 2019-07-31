//
//  Podcast.swift
//  Podcasts
//
//  Created by Nihaal Manesia on 7/30/19.
//  Copyright © 2019 Nihaal Manesia. All rights reserved.
//

import Foundation

struct Podcast: Decodable {
    var trackName: String?
    var artistName: String?
    var trackCount: Int?
    var artworkUrl600: String?
    var feedUrl: String?
}
