//
//  Settings.swift
//  Core
//
//  Created by Gianluca Rago on 8/13/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit

class Settings {
    
    enum Key:String {
        case hasOpenedApp = "has-opened-app"
        case hasPromptedNotifications = "has-prompted-notifications"
        case doesAllowNotifications = "does-allow-notifications"
        case needsToUpdatePassword = "needs-to-update-password"
        case hasSignedInWithEmail = "has-signed-in-with-email"
        case hasSignedInWithGoogle = "has-signed-in-with-google"
        case hasSignedInWithFacebook = "has-signed-in-with-facebook"
        case hasPromptedLocationSerivces = "has-prompted-location-services"
    }
    
    static func set(value:Bool, key:Key) {
        Notifications.remove(id:key.rawValue)
        UserDefaults.standard.set(value, forKey:key.rawValue)
    }
    
    static func get(for:Key) -> Bool {
        return UserDefaults.standard.bool(forKey:`for`.rawValue)
    }
    
}
