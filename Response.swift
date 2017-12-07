//
//  Response.swift
//  
//
//  Created by Gianluca Rago on 10/4/17.
//

import SwiftyJSON

class Response {

    public private(set) var url:String
    public private(set) var success:Bool
    public private(set) var message:String
    public private(set) var code:Int
    public private(set) var data:JSON
    
    init(url:String, success:Bool, code:Int, message:String, data:JSON) {
        self.url = url
        self.success = success
        self.code = code
        self.message = message
        self.data = data
    }
    
    init() {
        url = ""
        success = false
        code = 0
        message = ""
        data = []
    }
    
}
