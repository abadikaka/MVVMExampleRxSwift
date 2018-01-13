//
//  HomeCollectionViewController.swift
//  Astro
//
//  Created by Michael Abadi on 11/1/17.
//  Copyright © 2017 Michael Abadi Santoso. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 * @discussion View Class for Main Root Home class
 */
class HomeCollectionViewController: UICollectionViewController {
    
    @IBOutlet var homeCollectionView: UICollectionView!
    
    // variable for top filter bar
    lazy var filterBar: SortBar = {
        let mb = SortBar()
        mb.homeController = self
        return mb
    }()
    
    // all image name
    let favouriteImageName = "Favourite"
    let unfavouriteImageName = "Unfavourite"
    
    // all cell identifier
    let channelCellIdentifier = "channelCellId"
    
    // all nib identifier
    let channelCellNibName = "ChannelListCollectionViewCell"
    
    // collection view setting for inset and the row position
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
    let itemsPerRow: CGFloat = 1
    
    // all neccesarry properties
    var channelList: Variable<[ChannelList]> = Variable([])
    var profileInfo: ProfileInfo?
    
    //var savedFavouriteChannelIds: [Int] = []
    var savedFavouriteChannelIds: Variable<[Int]> = Variable([])
    
    // viewModel of current view
    var viewModel = HomeChannelViewModel(profileName: "Michael")
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilterBar()
        setupCell()
        populateChannelFavourites()
        populateChannelList()
        setupTabBar()
    }

    private func setupTabBar(){
        tabBarController?.delegate = self
    }
    
    /**
     * @discussion function for populate the fav channel from db (UserDefault)
     */
    private func populateChannelFavourites() {
        let observableChannelIds = viewModel.favouriteChannelIds.asObservable()
        observableChannelIds.bind(to: savedFavouriteChannelIds).disposed(by: disposeBag)
    }
    
    /**
     * @discussion function for populate the channel list from API
     */
    private func populateChannelList() {
        let observableChannelList = viewModel.channelList.asObservable()
        observableChannelList.bind(to: channelList).disposed(by: disposeBag)
        observableChannelList.bind { [unowned self] (response) in
            self.homeCollectionView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    /**
     * @discussion function for setup filter bar
     */
    private func setupFilterBar(){
        view.addSubview(filterBar)
        view.addConstraintsWithFormat("H:|[v0]|", views: filterBar)
        view.addConstraintsWithFormat("V:[v0(50)]", views: filterBar)
        
        filterBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }
    
    /**
     * @discussion function for setup the home list cell of channel
     */
    private func setupCell(){
        homeCollectionView.register(UINib(nibName: channelCellNibName, bundle: nil), forCellWithReuseIdentifier: channelCellIdentifier)
        homeCollectionView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0)
        homeCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(100, 0, 0, 0)
        homeCollectionView.backgroundColor = UIColor(rgb: 0xf1c40f)
        homeCollectionView.contentInsetAdjustmentBehavior = .never
    }
    
}

// MARK: UICollectionViewDataSource
extension HomeCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return !channelList.value.isEmpty ? channelList.value[0].channels.count : 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: channelCellIdentifier, for: indexPath) as! ChannelListCollectionViewCell
        
        guard !channelList.value.isEmpty else {
            cell.channel = nil
            cell.cellIndexPath = 0
            return cell
        }
        
        cell.channel = channelList.value[0].channels[indexPath.item]
        cell.homeController = self
        cell.cellIndexPath = indexPath.item
        cell.favouriteButton.setImage(UIImage(named:(channelList.value[0].channels[indexPath.item].markedAsFavorite ?  favouriteImageName: unfavouriteImageName)), for:.normal)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout delegate
extension HomeCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width - paddingSpace
        let cellWidth = screenWidth / itemsPerRow
        let size = CGSize(width: cellWidth, height: 100)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
}

extension HomeCollectionViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: UINavigationController.self as AnyClass) {
            let selectedIndex = tabBarController.selectedIndex
            if selectedIndex == 0 {
                let viewController  = tabBarController.viewControllers?[1] as! UINavigationController
                let guideController = viewController.viewControllers[0] as! GuideCollectionViewController
                if channelList.value.count > 0 {
                    guideController.channels = channelList.value[0].channels
                }
            }
        }
        
        return true
    }
}

