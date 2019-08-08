//
//  UIApplication.swift
//  Podcasts
//
//  Created by Nihaal Manesia on 8/8/19.
//  Copyright © 2019 Nihaal Manesia. All rights reserved.
//

import UIKit

extension UIApplication {
    static func mainTabBarController() -> MainTabBarController? {
        return self.shared.keyWindow?.rootViewController as? MainTabBarController
    }
}
