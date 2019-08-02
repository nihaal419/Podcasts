//
//  PodcastCell.swift
//  Podcasts
//
//  Created by Nihaal Manesia on 7/31/19.
//  Copyright © 2019 Nihaal Manesia. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    
    var podcast: Podcast!{
        didSet{
            trackNameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            episodeCountLabel.text = "\(podcast.trackCount ?? 0) Episodes"
            
            guard let artworkUrl = podcast.artworkUrl600 else {return}
            let url = URL(string: artworkUrl.toSecureHTTPS())
            
            podcastImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
