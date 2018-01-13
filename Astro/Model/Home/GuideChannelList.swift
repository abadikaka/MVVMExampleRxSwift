//
//  GuideChannelList.swift
//  Astro
//
//  Created by Michael Abadi on 11/6/17.
//  Copyright © 2017 Michael Abadi Santoso. All rights reserved.
//

import Foundation

/**
 * @discussion Guide Channel Detail Information
 * @discussion AbilityToFavourite conform to this protocol
 */
struct GuideChannel {
    
    let channelId: Int
    let channelTitle: String
    let channelStbNumber: Int
    let live: Int
    let displayDateTime: String
    let programmeTitle: String
    let displayDuration: String
    let displayDate: Date

    init(dictionary: [String: AnyObject]){
        channelId = dictionary["channelId"] as! Int
        channelTitle = dictionary["channelTitle"] as! String
        channelStbNumber = Int(dictionary["channelStbNumber"] as! String)!
        live = dictionary["live"] as! Int
        displayDateTime = dictionary["displayDateTime"] as! String
        programmeTitle = dictionary["programmeTitle"] as! String
        displayDuration = dictionary["displayDuration"] as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: displayDateTime[0..<19])
        displayDate = date!
    }
}

/**
 * @discussion Channel List Response information
 */
struct GuideChannelList: ResponseStatus {
    
    // all variables which define guide channel list
    let responseMessage: String
    let responseCode: String
    var guideChannels: [GuideChannel] = []
    
    init(dictionary: [String: AnyObject]){        
        responseMessage = dictionary["responseMessage"] as! String
        responseCode = dictionary["responseCode"] as! String        
        let arrayOfGuideChannels = dictionary["getevent"] as! Array<AnyObject>
        if let arrayOfGuideChannels = arrayOfGuideChannels as? [[String : AnyObject]] {
            var counter: Int = 0
            while counter < arrayOfGuideChannels.count {
                let guideChannel = GuideChannel(dictionary: arrayOfGuideChannels[counter])
                guideChannels.append(guideChannel)
                counter = counter + 1
            }
        }
        guideChannels = guideChannels.sorted(by: {$0.displayDate.compare($1.displayDate) == .orderedAscending})
    }
}

// MARK: - conform to protocol AbilityToSort
extension GuideChannelList: AbilityToSort {
        
    mutating func sortByName() {
        guideChannels = guideChannels.sorted(by: { $0.channelTitle < $1.channelTitle })
    }
    
    mutating func sortByNumber() {
        guideChannels = guideChannels.sorted(by: { $0.channelStbNumber < $1.channelStbNumber })
    }
    
    mutating func noSort() {
        guideChannels = guideChannels.sorted(by: {$0.displayDate.compare($1.displayDate) == .orderedAscending})
    }
}
