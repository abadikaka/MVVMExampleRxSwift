//
//  HomeChannelViewModel.swift
//  Astro
//
//  Created by Michael Abadi on 11/2/17.
//  Copyright © 2017 Michael Abadi Santoso. All rights reserved.
//

import Foundation
import RxSwift

/**
 * @discussion Class for Home Root Channel ViewModel
 */
struct HomeChannelViewModel: AbilityToSaveToDatabase {
    
    var disposeBag = DisposeBag()
    var profile: ProfileInfo?
    let favouriteChannelIds = Variable<[Int]>([])
    var channelList = Variable<[ChannelList]>([])
    //var channelList2 = Variable<ChannelList?>(nil)
    
    init(profileName: String) {
        profile = nil
        setupProfile(name: profileName)
        retrieveFromDatabase(key: "Favourite")
        fetchChannelList()
    }
    
    /**
     * @discussion function for setup profile
     */
    mutating func setupProfile(name: String){
        profile = ProfileInfo(name: name)
    }
    
    /**
     * @discussion function for fetching Channel from API
     */
    func fetchChannelList() {
        NetworkManager.sharedInstance.fetchUrl(request: .getChannelList, body: nil, headers: nil, { (object) in
            let channelLists = object as! ChannelList
            var newArray = [ChannelList]()
            newArray.append(channelLists)
            self.channelList.value = newArray
            //self.channelList2.value = channelLists
            
            // mapping current channel with the favourite
            self.channelList.value[0].setupFavouriteChannel(channelIds: self.favouriteChannelIds.value)
            
            // add current channel with the user fav
            self.profile?.setupFavouriteChannel(channelIds: self.favouriteChannelIds.value)
            
            // sort by id + favorite
            self.noSort()
        })
    }
    
    /**
     * @discussion function for adding current Index Cell to fav
     * @param indexPath which is the index of current cell
     */
    func addCurentIndexToFavourite(indexPath: Int){
        channelList.value[0].channels[indexPath].addToFavourite()
        channelList.value[0].channels[indexPath].saveToDatabase(key: "Favourite", object: profile)
    }
    
    /**
     * @discussion function for delete current Index Cell to fav
     * @param indexPath which is the index of current cell
     */
    func deleteCurentIndexToFavourite(indexPath: Int){
        channelList.value[0].channels[indexPath].deleteFromFavourite()
        channelList.value[0].channels[indexPath].deleteFromDatabase(key: "Favourite", object: profile)
    }
    
    
    // MARK: - AbilityToSaveToDatabase protocol
    
    func saveToDatabase(key: String, object: AnyObject?) {
        
    }
    
    func deleteFromDatabase(key: String, object: AnyObject?) {
        
    }
    
    func retrieveFromDatabase(key: String) {
        DatabaseManager.sharedInstance.retrieveFromDatabase(key: key, objectType: .profile) { (object, objectType) in
            switch objectType {
            case .profile:
                self.favouriteChannelIds.value = object as! Array<Int>
                print("FAV RETRIEVED : ", self.favouriteChannelIds.value)
            default: break
            }
        }
    }
    
    func updateToDatabase(key: String, object: AnyObject?) {
        
    }
}

extension HomeChannelViewModel: AbilityToSort {
    
    func sortByName() {
        channelList.value[0].sortByName()
    }
    
    func sortByNumber() {
        channelList.value[0].sortByNumber()
    }
    
    func noSort() {
        channelList.value[0].noSort()
    }
}


