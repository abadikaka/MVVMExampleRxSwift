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
    static let baseURL = ""

    // Endpoint for V3
    struct EndpointV3 {
        static let getChannelList = Config.baseURL + ""
        static let getChannels = Config.baseURL + ""
        static let getEvents = Config.baseURL + ""
        static let searchEvents = Config.baseURL + ""
        static let searchVOD = Config.baseURL + ""
        static let getVOD = Config.baseURL + ""
        static let getBucketList = Config.baseURL + ""
        static let getCuratedContentLite = Config.baseURL + ""
    }
    
    // Avoid initialization of this (it's just for namingspace purposes)
    private init() {}
}
