//
//  Config.swift
//  Astro
//
//  Created by Michael Abadi on 11/1/17.
//  Copyright © 2017 Michael Abadi Santoso. All rights reserved.
//

import Foundation

/**
 * @discussion All Base Setting goes here
 */
struct Config {
    
    // base URL for the application API
    static let baseURL = "http://ams-api.astro.com.my/"

    // Endpoint for V3
    struct EndpointV3 {
        static let getChannelList = Config.baseURL + "ams/v3/getChannelList"
        static let getChannels = Config.baseURL + "ams/v3/getChannels"
        static let getEvents = Config.baseURL + "ams/v3/getEvents"
        static let searchEvents = Config.baseURL + "ams/v3/searchEvents"
        static let searchVOD = Config.baseURL + "ams/v3/searchVOD"
        static let getVOD = Config.baseURL + "ams/v3/getVOD"
        static let getBucketList = Config.baseURL + "ams/v3/getBucketList"
        static let getCuratedContentLite = Config.baseURL + "ams/v3/epg/getCuratedContentLite"
    }
    
    // Avoid initialization of this (it's just for namingspace purposes)
    private init() {}
}
