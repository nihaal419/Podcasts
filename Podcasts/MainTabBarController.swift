//
//  MainTabBarController.swift
//  Podcasts
//
//  Created by Nihaal Manesia on 7/16/19.
//  Copyright © 2019 Nihaal Manesia. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true
        
        tabBar.tintColor = .purple
        
        setupViewControllers()
    }
    
    //MARK:- Setup Functions
    
    fileprivate func setupViewControllers() {
        viewControllers = [
            generateNavigationControllers(with: ViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorite")),
            generateNavigationControllers(with: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            generateNavigationControllers(with: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "download"))
        ]
    }
    
    //MARK:- Helper Functions
    
    fileprivate func generateNavigationControllers(with rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
