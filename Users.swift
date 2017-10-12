//
//  Users.swift
//  Core
//
//  Created by Gianluca Rago on 8/12/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import SwiftyJSON

class Users {
    
    public private(set) static var main:User?
    private static var retrieved:[Int:User] = [:]
    
    private static func getNonMain(users:[User]) -> User? {
        if main != nil {
            for tempUser in users {
                if tempUser.id != main!.id {
                    return tempUser
                }
            }
        }
        return nil
    }
    
    static func set(main:User) {
        if self.main == nil {
            self.main = main
            addRetrieved(user:main)
        }
    }
    
    private static func addRetrieved(user:User) {
        retrieved[user.id] = user
    }

    static func get(id:Int, completionHandler: @escaping (Bool, String, User?) -> Void) {
        if let user = retrieved[id] {
            completionHandler(true, "Found local user successfully", user)
        }
        Connection.request(path:"/base/api/v1/user/get", post:["userId":String(id)], completionHandler: { res in
            if res.success {
                completionHandler(res.success, res.msg, to(from:res.data))
            }
            completionHandler(res.success, res.msg, nil)
        })
    }
    
    static func search(text:String, completionHandler: @escaping (Bool, String, [User]) -> Void) {
        Connection.request(path:"/base/api/v1/user/search", post:["text":text], completionHandler: { res in
            var users:[User] = []
            let results = res.data["users"].arrayValue
            for result in results {
                users.append(to(from:result))
            }
            users.sort(by: { $0.username > $1.username })
            completionHandler(res.success, res.msg, users)
        })
    }
    
    static func commend(user:User, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/commend", post:["userId":String(user.id)], completionHandler: {
            res in
            completionHandler(res.success, res.msg)
        })
    }
    
    static func block(user:User, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/block", post:["userId":String(user.id)], completionHandler: {
            res in
            completionHandler(res.success, res.msg)
        })
    }
    
    static func unblock(user:User, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/unblock", post:["userId":String(user.id)], completionHandler: {
            res in
            completionHandler(res.success, res.msg)
        })
    }
    
    static func report(user:User, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/report", post:["userId":String(user.id)], completionHandler: {
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
