//
//  Analytics.swift
//  Analytics
//
//  Created by Gianluca Rago on 5/14/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import SwiftyJSON

class Analytics {
    
    private static var deviceId:String = hashedDeviceId()
    
    static func report(actionTypeId:String, elementId:String?) {
        var post:[String:String] = ["appId":String(Config.appId), "deviceId":deviceId, "actionTypeId":actionTypeId]
        if let actionElementId = elementId {
            post["elementId"] = actionElementId
        }
        Connection.request(baseUrl:Config.analyticsUrl, path:"/analytics/api/v1/report", post:post, completion: { res in
            Common.log(prefix:.debug, str:res.message)
        })
    }
    
    private static func hashedDeviceId() -> String {
        let hashedDeviceId:String = Common.hash(str:(UIDevice.current.identifierForVendor?.uuidString)!)
        Common.log(prefix:.debug, str:"Hashed Device Id: \(hashedDeviceId)")
        return hashedDeviceId
    }
    
}
