//
//  ProfileInfo.swift
//  Astro
//
//  Created by Michael Abadi on 11/1/17.
//  Copyright © 2017 Michael Abadi Santoso. All rights reserved.
//

import Foundation
import UIKit

/**
 * @discussion Profile Info for storing current user info
 */
class ProfileInfo: NSObject{
    
    // all variables which define profile info
    var name: String
    var picture: UIImage?
    var favoriteChannels: [Int] = []

    init(name: String) {
        self.name = name
    }
    
    /**
     * @discussion function for add new channel to profile preferences
     * @param id which is the id of channel
     */
    func addNewChannelToFavourite(id: Int) {
        favoriteChannels.append(id)
        
    }
    
    /**
     * @discussion function for delete channel from profile preferences
     * @param id which is the id of channel
     */
    func deleteNewChannelFromFavourite(id: Int) {
        favoriteChannels = favoriteChannels.filter { $0 != id }
    }
    
    /**
     * @discussion function for setup fav channel from db for user preferences
     * @param channelIds which is the array of channel id from db
     */
    func setupFavouriteChannel(channelIds: [Int]){
        for id in channelIds {
            addNewChannelToFavourite(id: id)
        }
        print("PROFILE FAV CHANNEL: ", favoriteChannels)
    }
    
}

extension ProfileInfo: AbilityToSaveToDatabase {
    func retrieveFromDatabase(key: String) {
        
    }
    
    func saveToDatabase(key: String, object: AnyObject?) {
        
    }
    
    func deleteFromDatabase(key: String, object: AnyObject?) {
        
    }

    func updateToDatabase(key: String, object: AnyObject?) {
        
    }
}
