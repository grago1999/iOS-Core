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

}
