//
//  PodcastSearchController.swift
//  Podcasts
//
//  Created by Nihaal Manesia on 7/16/19.
//  Copyright © 2019 Nihaal Manesia. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    var podcasts = [
        Podcast(trackName: "Podcast 1", artistName: "Nihaal Manesia"),
        Podcast(trackName: "Podcast 2", artistName: "Lauren Harville")
    ]

    let cellId = "cellId"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
    }
    
    //MARK:- Setup Work
    
    fileprivate func setupSearchBar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let url = "https://itunes.apple.com/search?term="
        let parameters = ["term": searchText, "media": "podcast"]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).response { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect", err)
                return
            }
            
            guard let data = dataResponse.data else {return}
            
            do{
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                
                self.podcasts = searchResult.results
                self.tableView.reloadData()
            } catch let decodeErr{
                print("Failed to decode:", decodeErr)
            }
        }
    }

    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
    
    //MARK:- UITableView
    
    fileprivate func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let podcast = podcasts[indexPath.row]
        cell.textLabel?.text = "\(podcast.trackName ?? "")\n\(podcast.artistName ?? "")"
        cell.textLabel?.numberOfLines = 0
        //cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        
        return cell
    }
}
