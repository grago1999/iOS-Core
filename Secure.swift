//
//  Secure.swift
//  Location Base
//
//  Created by Gianluca Rago on 8/12/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit
import Valet

class Secure {
    
    static let valet = VALValet(identifier:Config.prodName, accessibility:.whenUnlocked)
    
    static func add(value:String, key:String) -> Bool {
        if let validValet = valet {
            validValet.setString(value, forKey:key)
            return true
        }
        return false
    }
    
    static func get(key:String) -> String? {
        if let validValet = valet {
            return validValet.string(forKey:key)
        }
        return nil
    }

}
