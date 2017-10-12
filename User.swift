//
//  User.swift
//  Game Base
//
//  Created by Gianluca Rago on 2/23/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import Foundation

class User {
    
    public private(set) var id:Int
    public private(set) var username:String
    public private(set) var banned:Bool
    public private(set) var privacy:Int
    public private(set) var creationDate:Date?
    
    init(id:Int, username:String, banned:Bool, privacy:Int) {
        self.id = id
        self.username = username
        self.banned = banned
        self.privacy = privacy
    }
    
    func update(privacy:Int, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/updatePrivacy", post:["privacy":String(privacy)], completionHandler: {
            res in
            if res.success {
                self.privacy = privacy
            }
            completionHandler(res.success, res.msg)
        })
    }
    
}
