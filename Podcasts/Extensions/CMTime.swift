//
//  CMTime.swift
//  Podcasts
//
//  Created by Nihaal Manesia on 8/6/19.
//  Copyright © 2019 Nihaal Manesia. All rights reserved.
//

import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        
        let totalSeconds = Int(CMTimeGetSeconds(self))        
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        if minutes > 59 {
            let hours = totalSeconds / 3600
            let timeFormatString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            return timeFormatString
        }
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        return timeFormatString
    }
    
}
