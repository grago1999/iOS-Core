//
//  Responses.swift
//  Core
//
//  Created by Gianluca Rago on 8/13/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import SwiftyJSON

class Responses {
    
    private static let general:JSON = [
        "success": true,
        "msg": "Successfully faked response",
    ]
    private static let error:JSON = [
        "success": false,
        "msg": "Failed to fake response",
    ]
    
    private static var all:[String:JSON] = [:]
    
    static func addFake(path:String, data:JSON) {
        var response:JSON = general
        response["data"] = data
        if all[path] == nil {
            all[path] = response
        }
        Common.log(prefix:.debug, str:"Added fake response for "+path)
    }
    
    static func rand(path:String) -> JSON {
        return all[path] != nil ? all[path]! : error
    }

}
