//
//  Message.swift
//  Game Base
//
//  Created by Gianluca Rago on 3/12/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit

class Message {
    
    private var id:Int
    private var user:User
    private var msg:String
    private var creationDate:Date?
    
    init(id:Int, user:User, msg:String) {
        self.id = id
        self.user = user
        self.msg = msg
    }
    
    func getId() -> Int {
        return id
    }
    
    func getMsg() -> String {
        return msg
    }
    
    func getUser() -> User {
        return user
    }

}
