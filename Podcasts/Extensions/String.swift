//
//  String.swift
//  Podcasts
//
//  Created by Nihaal Manesia on 8/2/19.
//  Copyright © 2019 Nihaal Manesia. All rights reserved.
//

import Foundation

extension String {
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
