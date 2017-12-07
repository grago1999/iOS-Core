//
//  Chats.swift
//  Core
//
//  Created by Gianluca Rago on 8/12/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import Foundation

class Chats {
    
    static func all(completion: @escaping (Bool, Int, String, [Chat]) -> Void) {
        Connection.request(path:"/api/v1/chat/all", post:[:]) { res in
            var chats:[Chat] = []
            if res.success {
                for chatData in res.data["chats"].arrayValue {
                    let chat = Chat(id:chatData["id"].intValue, title:chatData["title"].stringValue, creationDate:Dates.from(str:chatData["creationDate"].stringValue))
                    chats.append(chat)
                }
            }
            completion(res.success, res.code, res.message, chats)
        }
    }
    
    static func get(id:Int, completion: @escaping (Bool, Int, String, Chat?) -> Void) {
       Connection.request(path:"/api/v1/chat/get", post:["chatId":String(id)], completion: { res in
            var chat:Chat?
            if res.success {
                let chatTitle:String = res.data["chat"]["title"].stringValue
                let chatCreationDate:Date = Dates.from(str:res.data["chat"]["creationDate"].stringValue)
                chat = Chat(id:id, title:chatTitle, creationDate:chatCreationDate)
                let msgArrays = res.data["chat"]["messages"].arrayValue
                for msgArray in msgArrays {
                    chat!.add(message:Message(id:msgArray["id"].intValue, user:Users.to(from:msgArray["user"]), text:msgArray["text"].stringValue, creationDate:Dates.from(str:msgArray["creationDate"].stringValue)))
                }
            }
            completion(res.success, res.code, res.message, chat)
        })
    }
    
    static func create(userId:Int, completion: @escaping (Bool, Int, String, Chat?) -> Void) {
        Connection.request(path:"/base/api/v1/chat/create", post:["userId":String(userId)], completion: { res in
            var chat:Chat?
            if res.success {
                chat = Chat(id:res.data["chat"]["id"].intValue, title:res.data["chat"]["title"].stringValue, creationDate: Dates.from(str:res.data["chat"]["creationDate"].stringValue))
                let msgArrays = res.data["chat"]["messages"].arrayValue
                for msgArray in msgArrays {
                    chat!.add(message:Message(id:msgArray["id"].intValue, user:Users.to(from:msgArray["user"]), text:msgArray["text"].stringValue, creationDate:Dates.from(str:msgArray["creationDate"].stringValue)))
                }
            }
            completion(res.success, res.code, res.message, chat)
        })
    }
    
    static func send(chatId:Int, text:String, completion: @escaping (Bool, Int, String) -> Void) {
        Connection.request(path:"/base/api/v1/chat/send", post:["chatId":String(chatId), "text":text], completion: { res in
            completion(res.success, res.code, res.message)
        })
    }

}
