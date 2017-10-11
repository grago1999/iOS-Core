//
//  Users.swift
//  Core
//
//  Created by Gianluca Rago on 8/12/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import SwiftyJSON

class Users {
    
    static var main:User?
    private static var retrieved:[Int:User] = [:]
    
    private static func getNonMain(users:[User]) -> User {
        for tempUser in users {
            if tempUser.getId() != main?.getId() {
                return tempUser
            }
        }
        return User()
    }
    
    static func addRetrieved(user:User) {
        retrieved[user.getId()] = user
    }

    static func get(id:Int, completionHandler: @escaping (Bool, String, User) -> Void) {
        if let user = retrieved[id] {
            completionHandler(true, "Found local user successfully", user)
        }
        Connection.request(path:"/base/api/v1/user/get", post:["userId":String(id)], completionHandler: { res in
            var user = User()
            if res.success {
                user = to(from:res.data)
            }
            completionHandler(res.success, res.msg, user)
        })
    }
    
    static func search(text:String, completionHandler: @escaping (Bool, String, [User]) -> Void) {
        Connection.request(path:"/base/api/v1/user/search", post:["text":text], completionHandler: { res in
            var users:[User] = []
            let results = res.data["users"].arrayValue
            for result in results {
                users.append(to(from:result))
            }
            users.sort(by: { $0.getUsername() > $1.getUsername() })
            completionHandler(res.success, res.msg, users)
        })
    }
    
    static func commend(user:User, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/commend", post:["userId":String(user.getId())], completionHandler: {
            res in
            completionHandler(res.success, res.msg)
        })
    }
    
    static func block(user:User, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/block", post:["userId":String(user.getId())], completionHandler: {
            res in
            completionHandler(res.success, res.msg)
        })
    }
    
    static func unblock(user:User, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/unblock", post:["userId":String(user.getId())], completionHandler: {
            res in
            completionHandler(res.success, res.msg)
        })
    }
    
    static func report(user:User, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/report", post:["userId":String(user.getId())], completionHandler: {
            res in
            completionHandler(res.success, res.msg)
        })
    }
    
    static func to(from:JSON) -> User {
        let userId:Int = from["user"]["id"].intValue
        let username:String = from["user"]["username"].stringValue
        let banned:Bool = from["user"]["banned"].boolValue
        let privacy = from["user"]["privacy"].intValue
        let user:User = User(id:userId, username:username, banned:banned, privacy:privacy)
        addRetrieved(user:user)
        return user
    }
    
    static func rand() -> JSON {
        return [
            "id": Common.rand(low:0, high:123456789),
            "username": "somename"+String(Common.rand(num:3)),
            "banned": false,
            "privacy": 0,
            "xp": 0
        ]
    }
    
}
