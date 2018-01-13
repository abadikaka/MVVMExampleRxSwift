//
//  GuideChannelViewModel.swift
//  Astro
//
//  Created by Michael Abadi on 11/6/17.
//  Copyright © 2017 Michael Abadi Santoso. All rights reserved.
//

import Foundation
import RxSwift

/**
 * @discussion Class for Guide Channel ViewModel
 */
struct GuideChannelViewModel {
    
    var disposeBag = DisposeBag()
    var profile: ProfileInfo?
    var channels = [Channel]()
    var guideChannels = Variable<GuideChannelList?>(nil)
    
    
    init(profileName: String, channels: [Channel]) {
        profile = nil
        //setupProfile(name: profileName)
        self.channels = channels
        fetchGuideChannelList()
    }
    
    /**
     * @discussion function for setup profile
     */
    mutating func setupProfile(name: String){
        profile = ProfileInfo(name: name)
    }
    
    /**
     * @discussion function for fetching Guide Channel from API
     */
    func fetchGuideChannelList() {
        let timeParam = getParamTime()
        let channelIds = channels.map({ return String($0.channelId) })
        let parameters = constructParameters(channelIds: channelIds, periodStart: timeParam["periodStart"]!, periodEnd: timeParam["periodEnd"]!)
        NetworkManager.sharedInstance.fetchUrl(request: .getCurrentAiringTime, body: parameters, headers: nil,{ (object) in
            let airingChannel = object as! GuideChannelList
            self.guideChannels.value = airingChannel
            print("AIRING CHANNEL ", airingChannel.guideChannels)
            
            
        })
    }
    
    /**
     * @discussion function for get current device time and some days later
     */
    func getParamTime() -> [String:String]{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let periodStart = dateFormatter.string(from: Date())
        let nextTime = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        let periodEnd = dateFormatter.string(from: nextTime!)
        return  ["periodStart": periodStart, "periodEnd": periodEnd]
    }
    
    /**
     * @discussion function for construction Parameters
     */
    func constructParameters(channelIds: [String], periodStart: String, periodEnd: String) -> ParametersDict{
        let channelId : String = channelIds.reduce("", { $0 == "" ? $1 : $0 + "," + $1 })
        return ["channelId": channelId, "periodStart": periodStart, "periodEnd": periodEnd, "live": "True"]
    }
    
    
    /**
     * @discussion function for get airing time from now on
     */
    func getRangeTime(currentProgramDate: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = dateFormatter.date(from: currentProgramDate[0..<19])
        let day = date!.days(from: Date())
        let hours = date!.hours(from: Date())
        let minutes = date!.minutes(from: Date())

        if day > 0 {
            return "in " + String(describing: day) + " days again"
        }else if hours > 0 {
            return "in " + String(describing: hours) + " hours again"
        }else if minutes > 0 {
            return "in " + String(describing: minutes) + " minutes again"
        }else{
            return "Now"
        }
    }
}

// MARK : Conform to Ability To Sort
extension GuideChannelViewModel: AbilityToSort {
    func sortByName() {
        guideChannels.value?.sortByName()
    }
    
    func sortByNumber() {
        guideChannels.value?.sortByNumber()
    }
    
    func noSort() {
        guideChannels.value?.noSort()
    }
}

