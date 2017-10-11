//
//  LocaleMessages.swift
//  Core
//
//  Created by Gianluca Rago on 7/8/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

class LocaleMessages {
    
    static var locale:String = "en"
    static var localeData:[String:String] = LocaleData.enData
    
    static func get(id:String) -> String {
        if let value = localeData[id] {
            Common.log(prefix:.debug, str:"Found message for "+id)
            return value
        }
        Common.log(prefix:.warning, str:"Could not find message for "+id)
        return ""
    }
    
}
