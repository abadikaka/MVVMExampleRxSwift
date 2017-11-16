//
//  DatabaseManager.swift
//  Astro
//
//  Created by Michael Abadi on 11/2/17.
//  Copyright © 2017 Michael Abadi Santoso. All rights reserved.
//

import Foundation

/**
 * @discussion enum for identify the object type
 */
enum ObjectType {
    case profile
    case channel
    case none
}

/**
 * @discussion protocol for defining db duties
 * @param key as the key for save into db
 * @param object as any object
 * @param objectType for defining the object type
 * @param completion as String
 */
protocol DatabaseDuty {
    func saveToDatabase(key: String, object: AnyObject?, objectType: ObjectType, completion: @escaping (String) -> Void)
    func deleteFromDatabase(key: String, object: AnyObject?, objectType: ObjectType,completion: @escaping (String) -> Void)
    func retrieveFromDatabase(key: String, objectType: ObjectType,completion: @escaping (AnyObject?, ObjectType) -> Void)
    func updateToDatabase(key: String, object: AnyObject?, objectType: ObjectType, completion: @escaping (String) -> Void)
}

/**
 * @discussion protocol for defining which class has db ability
 * @param key as the key to be saved into db
 * @param object as any object
 */
protocol AbilityToSaveToDatabase {
    func saveToDatabase(key: String, object: AnyObject?)
    func deleteFromDatabase(key: String, object: AnyObject?)
    func retrieveFromDatabase(key: String)
    func updateToDatabase(key: String, object: AnyObject?)
}


/**
 * @discussion Class for Database Manager -- Singleton and conform to Database Duty protocol
 */
class DatabaseManager: NSObject, DatabaseDuty {
    
    static let sharedInstance = DatabaseManager()
    
    func saveToDatabase(key: String, object: AnyObject?, objectType: ObjectType, completion: @escaping (String) -> Void) {
        switch objectType {
        case .profile:
            if let object = object  {
                let profileInfo = object as! ProfileInfo
                let defaults = UserDefaults.standard
                defaults.set(profileInfo.favoriteChannels, forKey: key)
                defaults.synchronize()
                print("DONE UPDATE TO DATABASE", profileInfo.favoriteChannels)
                completion("success")
            }
        default:
            break
        }
    }
    
    func deleteFromDatabase(key: String, object: AnyObject?, objectType: ObjectType, completion: @escaping (String) -> Void) {
        
    }
    
    func retrieveFromDatabase(key: String, objectType: ObjectType, completion: @escaping (AnyObject?, ObjectType) -> Void) {
        switch objectType {
        case .profile:
            let defaults = UserDefaults.standard
            let array = defaults.array(forKey: key) as AnyObject?
            defaults.synchronize()
            print("DONE RETRIEVE FROM DATABASE")
            completion(array, objectType)
        default:
            break
        }
    }
    
    func updateToDatabase(key: String, object: AnyObject?, objectType: ObjectType, completion: @escaping (String) -> Void) {
        
    }
}

