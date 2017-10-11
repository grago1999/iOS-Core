//
//  User.swift
//  Game Base
//
//  Created by Gianluca Rago on 2/23/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import Foundation

class User {
    
    private var id:Int
    private var username:String
    private var banned:Bool
    private var privacy:Int
    private var creationDate:Date?
    
    init(id:Int, username:String, banned:Bool, privacy:Int) {
        self.id = id
        self.username = username
        self.banned = banned
        self.privacy = privacy
    }
    
    init() {
        self.id = 0
        self.username = ""
        self.banned = false
        self.privacy = 0
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
    
    func getId() -> Int {
        return id
    }

    func getUsername() -> String {
        return username
    }
    
    func isBanned() -> Bool {
        return banned
    }
    
    func getPrivacy() -> Int {
        return privacy
    }
    
}
