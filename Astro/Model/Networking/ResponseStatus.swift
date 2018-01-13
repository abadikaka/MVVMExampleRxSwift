//
//  Response.swift
//  Astro
//
//  Created by Michael Abadi on 11/2/17.
//  Copyright © 2017 Michael Abadi Santoso. All rights reserved.
//

import Foundation

/**
 * @discussion Response information protocol
 */
protocol ResponseStatus {
    var responseMessage: String {get}
    var responseCode: String {get}
}
