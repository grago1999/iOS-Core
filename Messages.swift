//
//  Messages.swift
//  Location Base
//
//  Created by Gianluca Rago on 7/8/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

class Messages {
    
    static var locale:String = "en"
    static var localeData:[String:String] = MessageData.enData
    
    static func get(id:String) -> String {
        return localeData[id] != nil ? localeData[id]! : notFound(id:id)
    }
    
    private static func notFound(id:String) -> String {
        Common.log(prefix:.warning, str:"Could not find message for "+id)
        return ""
    }
    
}
