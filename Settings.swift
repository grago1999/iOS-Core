//
//  Settings.swift
//  Core
//
//  Created by Gianluca Rago on 8/13/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit

class Settings {
    
    static func set(value:Bool, key:Config.Key) {
        Notifications.remove(id:key.rawValue)
        UserDefaults.standard.set(value, forKey:key.rawValue)
    }
    
    static func get(for:Config.Key) -> Bool {
        return UserDefaults.standard.bool(forKey:`for`.rawValue)
    }
    
}
