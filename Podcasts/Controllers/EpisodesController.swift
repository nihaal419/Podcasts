//
//  EpisodesController.swift
//  Podcasts
//
//  Created by Nihaal Manesia on 7/31/19.
//  Copyright © 2019 Nihaal Manesia. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    
    var podcast: Podcast? {
        didSet{
            navigationItem.title = podcast?.trackName
            
            fetchEpisodes()
        }
    }
    
    fileprivate func fetchEpisodes() {
        guard let feedUrl = podcast?.feedUrl else {return}
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate let cellId = "cellId"
    
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBarButtons()
    }
    
    //MARK:- Setup
    
    fileprivate func setupNavigationBarButtons() {
        let savedPodcasts = UserDefaults.standard.savedPodcasts()
        if savedPodcasts.firstIndex(where: { $0.trackName == self.podcast?.trackName  && $0.artistName == self.podcast?.artistName}) == nil {
            let heartBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "heart-outline"), style: .plain, target: self, action: #selector(handleSavingFavorite))
            heartBarButton.tintColor = .purple
            navigationItem.rightBarButtonItem = heartBarButton
        } else {
            let heartBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "heart-filled"), style: .plain, target: nil, action: nil)
            heartBarButton.tintColor = .purple
            navigationItem.rightBarButtonItem = heartBarButton
        }
    }
    
    @objc fileprivate func handleSavingFavorite() {
        let heartBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "heart-filled"), style: .plain, target: nil, action: nil)
        heartBarButton.tintColor = .purple
        navigationItem.rightBarButtonItem = heartBarButton
        
        guard let podcast = self.podcast else {return}
        var listOfPodcasts = UserDefaults.standard.savedPodcasts()
        listOfPodcasts.insert(podcast, at: 0)
        let data = NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts)
        UserDefaults.standard.setValue(data, forKey: UserDefaults.favoritedPodcastKey)
        
        showBadgeHighlight()
    }
    
    fileprivate func showBadgeHighlight() {
        UIApplication.mainTabBarController()?.viewControllers?[0].tabBarItem.badgeValue = "New"
    }
    
//    @objc fileprivate func handleRemovingFavorite() {
//        navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "heart-outline")
//        guard let podcast = self.podcast else {return}
//        var listOfPodcasts = UserDefaults.standard.savedPodcasts()
//        guard let index = listOfPodcasts.firstIndex(of: podcast) else {return}
//        UserDefaults.standard.removePodcasts(index: index)
//    }
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let downloadAction = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in
            let episode = self.episodes[indexPath.row]
            UserDefaults.standard.downloadEpisode(episode: episode)
            
            //download the episode
            APIService.shared.downloadEpisode(episode: episode)
        }
        
        return [downloadAction]
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = episodes[indexPath.row]
        cell.episode = episode
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
    }
}
