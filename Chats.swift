//
//  Chats.swift
//  Location Base
//
//  Created by Gianluca Rago on 8/12/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit

class Chats {
    
    static func getId(userId:Int, completionHandler: @escaping (Bool, String, Int) -> Void) {
        Connection.request(path:"/base/api/v1/chat/getChatId.php", postDict:["userId":String(userId)], completionHandler: { success, msg, json in
            var chatId:Int = 0
            if success {
                chatId = json["data"]["chatId"].intValue
            }
            completionHandler(success, msg, chatId)
        })
    }
    
    static func get(chatId:Int, completionHandler: @escaping (Bool, String, Chat) -> Void) {
       Connection.request(path:"/base/api/v1/chat/get.php", postDict:["chatId":String(chatId)], completionHandler: { success, msg, json in
            var chat:Chat = Chat()
            if success {
                let chatTitle:String = json["data"]["chat"]["title"].stringValue
                let chatCreationDate:Date = Dates.from(str:json["data"]["chat"]["creationDate"].stringValue)
                let msgArrays = json["data"]["chat"]["msgs"].arrayValue
                for msgArray in msgArrays {
                    Users.get(userId:msgArray["userId"].intValue, completionHandler: { success, msg, user in
                        if success {
                            chat.add(msg:Message(id:msgArray["id"].intValue, user:user, msg:msgArray["msg"].stringValue))
                        }
                    })
                }
                chat = Chat(id:chatId, title:chatTitle, creationDate:chatCreationDate)
            }
            completionHandler(success, msg, chat)
        })
    }
    
    static func sendMsg(chatId:Int, msg:String, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/chat/sendMsg.php", postDict:["chatId":String(chatId), "msg":msg], completionHandler: { success, msg, json in
            completionHandler(success, msg)
        })
    }

}
