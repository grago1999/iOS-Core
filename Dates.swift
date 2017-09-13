//
//  Dates.swift
//  Location Base
//
//  Created by Gianluca Rago on 8/13/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit

class Dates {

    static func from(str:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from:str) {
            return date
        } else {
            return Date()
        }
    }
    
    static func to(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from:date)
    }
    
    private static func format(num:Int) -> String {
        return num < 10 ? "0\(num)" : String(num)
    }
    
    static func rand() -> String {
        let year:Int = Common.rand(low:1, high:17)
        let month:Int = Common.rand(low:1, high:12)
        let day:Int = Common.rand(low:1, high:28)
        let date:String = "20"+format(num:year)+"-"+format(num:month)+"-"+format(num:day)
        
        let hour:Int = Common.rand(low:1, high:12)
        let minute:Int = Common.rand(low:0, high:59)
        let seconds:Int = Common.rand(low:0, high:59)
        let time:String = format(num:hour)+":"+format(num:minute)+":"+format(num:seconds)
        
        return date+" "+time
    }
    
}
