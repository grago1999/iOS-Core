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
    public private(set) var name:String
    public private(set) var banned:Bool
    public private(set) var privacy:Int
    public private(set) var creationDate:Date
    
    init(id:Int, name:String, banned:Bool, privacy:Int, creationDate:Date) {
        self.id = id
        self.name = name
        self.banned = banned
        self.privacy = privacy
        self.creationDate = creationDate
    }
    
    func update(privacy:Int, completion: @escaping (Bool, Int, String) -> Void) {
        Connection.request(path:"/api/v1/user/update", post:["privacy":String(privacy)], completion: {
            res in
            if res.success {
                self.privacy = privacy
            }
            completion(res.success, res.code, res.message)
        })
    }
    
}
