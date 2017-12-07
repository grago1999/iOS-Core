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
    public private(set) var creationDate:Date
    public private(set) var messages:[Message] = []
    
    init(id:Int, title:String, creationDate:Date) {
        self.id = id
        self.title = title
        self.creationDate = creationDate
    }
    
    init() {
        self.id = 0
        self.title = ""
        self.creationDate = Date()
    }
    
    func add(message:Message) {
        var shouldAddMsg:Bool = true
        for currentMsg in self.messages {
            if currentMsg.id == message.id {
                shouldAddMsg = false
                break
            }
        }
        if shouldAddMsg {
            self.messages.append(message)
        }
    }
    
    func send(message:String, completion: @escaping (Bool) -> Void) {
        Connection.request(path:"/base/api/v1/chat/send", post:["text":message]) { res in
            completion(res.success)
        }
    }
    
    func update(completion: @escaping (Bool) -> Void) {
        Chats.get(id:self.id) { success, code, message, chat in
            if success {
                self.messages = chat!.messages
            }
            completion(success)
        }
    }
    
    func isValid(res:String) -> Bool {
        return res.prefix(3) == "000"
    }

    func guess(prevProof:String, nonce:Int) -> String {
        var current:String = String(prevProof)+String(nonce)
        for _ in 0...1 {
            current = Common.hash(str:current)
        }
        return current
    }
    
}
