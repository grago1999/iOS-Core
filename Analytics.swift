//
//  Analytics.swift
//  Analytics
//
//  Created by Gianluca Rago on 5/14/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit
import SwiftyJSON

class Analytics {
    
    static var hasPrepared:Bool = false
    
    private static var appId:Int64 = Config.appId
    private static var deviceId:String = hashedDeviceId()
    
    static func report(actionTypeId:String, elementId:String?) {
        var postDict:[String:String] = ["appId":String(appId), "deviceId":deviceId, "actionTypeId":actionTypeId]
        if let actionElementId = elementId {
            postDict["elementId"] = actionElementId
        }
        Connection.request(path:"/analytics/api/v1/report.php", postDict:postDict, completionHandler: { success, msg, json in
            Common.log(prefix:.debug, str:msg)
        })
    }
    
    private static func hashedDeviceId() -> String {
        let hashedDeviceId:String = Common.hash(str:(UIDevice.current.identifierForVendor?.uuidString)!)
        Common.log(prefix:.debug, str:"Hashed Device Id: \(hashedDeviceId)")
        return hashedDeviceId
    }
    
}
