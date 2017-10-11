//
//  Chats.swift
//  Core
//
//  Created by Gianluca Rago on 8/12/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import Foundation

class Chats {
    
    static func get(chatId:Int, completionHandler: @escaping (Bool, String, Chat) -> Void) {
       Connection.request(path:"/base/api/v1/chat/get", post:["chatId":String(chatId)], completionHandler: { res in
            var chat:Chat = Chat()
            if res.success {
                let chatTitle:String = res.data["chat"]["title"].stringValue
                let chatCreationDate:Date = Dates.from(str:res.data["chat"]["creationDate"].stringValue)
                let msgArrays = res.data["chat"]["msgs"].arrayValue
                for msgArray in msgArrays {
                    Users.get(id:msgArray["userId"].intValue, completionHandler: { success, msg, user in
                        if success {
                            chat.add(msg:Message(id:msgArray["id"].intValue, user:user, msg:msgArray["msg"].stringValue))
                        }
                    })
                }
                chat = Chat(id:chatId, title:chatTitle, creationDate:chatCreationDate)
            }
            completionHandler(res.success, res.msg, chat)
        })
    }
    
    static func sendMsg(chatId:Int, msg:String, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/chat/sendMsg", post:["chatId":String(chatId), "msg":msg], completionHandler: { res in
            completionHandler(res.success, res.msg)
        })
    }

}
