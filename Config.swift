//
//  Config.swift
//  Location Base
//
//  Created by Gianluca Rago on 7/29/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

class Config {
    
    static let prodName:String = "some product name here"
    static let prodVersion:String = "some unique version identifier"
    
    static let dev:Bool = true
    static let fake:Bool = false
    static let debugLevel:Common.LogType = .debug
    
    static let url = dev ? "http://localhost" : "https://google.com"
    static let analyticsUrl = dev ? "http://localhost" : "https://google.com"
    
    static let appId:Int64 = 987654321
    
    enum Key:String {
        case hasOpenedApp = "has-opened-app"
        case hasPromptedNotifications = "has-prompted-notifications"
        case doesAllowNotifications = "does-allow-notifications"
        case needsToUpdatePassword = "needs-to-update-password"
        case hasSignedInWithEmail = "has-signed-in-with-email"
        case hasPromptedLocationSerivces = "has-prompted-location-services"
    }

}
