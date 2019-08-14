//
//  FavoritesController.swift
//  Podcasts
//
//  Created by Nihaal Manesia on 8/9/19.
//  Copyright © 2019 Nihaal Manesia. All rights reserved.
//

import UIKit

class FavoritesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    
    var podcasts = UserDefaults.standard.savedPodcasts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        podcasts = UserDefaults.standard.savedPodcasts()
        collectionView.reloadData()
        UIApplication.mainTabBarController()?.viewControllers?[0].tabBarItem.badgeValue = nil
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: cellId)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        guard let selectedIndexPath = collectionView.indexPathForItem(at: location) else {return}
        
        let alertController = UIAlertController(title: "Remove Podcast from Favorites?", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            self.podcasts.remove(at: selectedIndexPath.item)
            self.collectionView.deleteItems(at: [selectedIndexPath])
            let data = NSKeyedArchiver.archivedData(withRootObject: self.podcasts)
            UserDefaults.standard.setValue(data, forKey: UserDefaults.favoritedPodcastKey)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    //MARK:- UICollectionView Delegate / Spacing Methods
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        episodesController.podcast = self.podcasts[indexPath.row]
        navigationController?.pushViewController(episodesController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavoritePodcastCell
        cell.podcast = podcasts[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - (3*16)) / 2
        return CGSize(width: width, height: (width + 46))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
