//
//  HomeProtocol.swift
//  Astro
//
//  Created by Michael Abadi on 11/2/17.
//  Copyright © 2017 Michael Abadi Santoso. All rights reserved.
//

import Foundation

/**
 * @discussion Ability To Favourite for each class
 */
protocol AbilityToFavourite {
    mutating func addToFavourite()
    mutating func deleteFromFavourite()
}

/**
 * @discussion Ability To Sort for some class
 */
protocol AbilityToSort {
    mutating func sortByName()
    mutating func sortByNumber()
    mutating func noSort()
}
