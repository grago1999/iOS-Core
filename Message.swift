//
//  Message.swift
//  Game Base
//
//  Created by Gianluca Rago on 3/12/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import Foundation

class Message {
    
    public private(set) var id:Int
    public private(set) var user:User
    public private(set) var text:String
    public private(set) var creationDate:Date
    
    init(id:Int, user:User, text:String, creationDate:Date) {
        self.id = id
        self.user = user
        self.text = text
        self.creationDate = creationDate
    }

}
