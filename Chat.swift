//
//  Chat.swift
//  Game Base
//
//  Created by Gianluca Rago on 3/12/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import Foundation

class Chat {

    public private(set) var id:Int
    public private(set) var title:String
    public private(set) var creationDate:Date?
    public private(set) var msgs:[Message] = []
    
    init(id:Int, title:String, creationDate:Date) {
        self.id = id
        self.title = title
        self.creationDate = creationDate
    }
    
    init() {
        self.id = 0
        self.title = ""
    }
    
    func add(msg:Message) {
        var shouldAddMsg:Bool = true
        for currentMsg in self.msgs {
            if currentMsg.id == msg.id {
                shouldAddMsg = false
                break
            }
        }
        if shouldAddMsg {
            self.msgs.append(msg)
        }
    }
    
    func get() -> [Message] {
        return msgs
    }

}
