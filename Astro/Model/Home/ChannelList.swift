//
//  ChannelList.swift
//  Astro
//
//  Created by Michael Abadi on 11/1/17.
//  Copyright © 2017 Michael Abadi Santoso. All rights reserved.
//

import Foundation
import UIKit


/**
 * @discussion Channel Detail Information
 * @discussion Codable just for additional if wanna use Swift 4 abilities in decode
 * @discussion AbilityToFavourite conform to this protocol
 */
struct Channel: Codable, AbilityToFavourite {
        
    let channelId: Int
    let channelTitle: String
    let channelStbNumber: Int
    var markedAsFavorite: Bool
    
    mutating func addToFavourite() {
        markedAsFavorite = true
    }
    
    mutating func deleteFromFavourite() {
        markedAsFavorite = false
    }
    
    init(dictionary: [String: AnyObject]){
        channelId = dictionary["channelId"] as! Int
        channelTitle = dictionary["channelTitle"] as! String
        channelStbNumber = dictionary["channelStbNumber"] as! Int
        markedAsFavorite = false
    }
}

// MARK: - conform to protocol AbilityToSaveToDatabase
extension Channel: AbilityToSaveToDatabase {
    func saveToDatabase(key: String, object: AnyObject?) {
        if let object = object as? ProfileInfo {
            object.addNewChannelToFavourite(id: channelId)
            DatabaseManager.sharedInstance.saveToDatabase(key: key, object: object as AnyObject, objectType: .profile) { (response) in
                print("Channel Fav Saved")
            }
        }
    }
    
    func deleteFromDatabase(key: String, object: AnyObject?) {
        if let object = object as? ProfileInfo {
            object.deleteNewChannelFromFavourite(id: channelId)
            DatabaseManager.sharedInstance.saveToDatabase(key: key, object: object as AnyObject, objectType: .profile) { (response) in
                print("Channel Fav Deleted")
            }
        }
    }
    
    func updateToDatabase(key: String, object: AnyObject?) {
        
    }
    
    func retrieveFromDatabase(key: String) {
        DatabaseManager.sharedInstance.retrieveFromDatabase(key: key, objectType: .profile) { (object, objectType) in
            switch objectType {
                case .profile:
                    let object = object as! Array<Int>
                    print("RETRIEVE CHANNEL FROM DATABASE", object)
                default: break
            }

        }
    }
}

/**
 * @discussion Channel List Response information
 */
struct ChannelList: Codable, ResponseStatus {
    
    // all variables which define channel list
    let responseMessage: String
    let responseCode: String
    var channels: [Channel] = []
    
    // old ways : Swift 3.0, Swift 4.0 can use Decodable but still not perfect
    init(dictionary: [String: AnyObject]){
        responseMessage = dictionary["responseMessage"] as! String
        responseCode = dictionary["responseCode"] as! String
        let arrayOfChannels = dictionary["channels"] as! Array<AnyObject>
        if let arrayOfChannels = arrayOfChannels as? [[String : AnyObject]] {
            var counter: Int = 0
            while counter < arrayOfChannels.count {
                let channel = Channel(dictionary: arrayOfChannels[counter])
                channels.append(channel)
                counter = counter + 1
            }
        }
    }
    
    /**
     * @discussion function for setup fav channel from db to be marked in the channel
     * @param channelIds which is the array of channel id from db
     */
    mutating func setupFavouriteChannel(channelIds: [Int]){
        for data in channels {
            for id in channelIds {
                if data.channelId == id {
                    channels[id-1].addToFavourite()
                }
            }
        }
    }
}

// MARK: - conform to protocol AbilityToSort
extension ChannelList: AbilityToSort {
    
    mutating func sortByName() {
        //channels = channels.sorted(by: { $0.channelTitle < $1.channelTitle })
        channels = channels.sorted { t1, t2 in
            if t1.markedAsFavorite == t2.markedAsFavorite {
                return t1.channelTitle < t2.channelTitle
            }
            return t1.markedAsFavorite && !t2.markedAsFavorite
        }
    }
    
    mutating func sortByNumber() {
        //channels = channels.sorted(by: { $0.channelStbNumber < $1.channelStbNumber })
        channels = channels.sorted { t1, t2 in
            if t1.markedAsFavorite == t2.markedAsFavorite {
                return t1.channelStbNumber < t2.channelStbNumber
            }
            return t1.markedAsFavorite && !t2.markedAsFavorite
        }
    }
    
    mutating func noSort() {
        //channels = channels.sorted(by: { $0.channelId < $1.channelId })
        channels = channels.sorted { t1, t2 in
            if t1.markedAsFavorite == t2.markedAsFavorite {
                return t1.channelId < t2.channelId
            }
            return t1.markedAsFavorite && !t2.markedAsFavorite
        }
    }
}
