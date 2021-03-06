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
    private static var retrieved:[String:User] = [:]
    
    private static func getNonMain(from:[User]) -> User? {
        if main != nil {
            for tempUser in from {
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

    static func get(id:String, completion: @escaping (Bool, Int, String, User?) -> Void) {
        if let user = retrieved[id] {
            completion(true, 0, "Found local user successfully", user)
        }
        Connection.request(path:"/api/v1/users/get", post:["userId":String(id)], completion: { res in
            if res.success {
                completion(res.success, res.code, res.message, to(from:res.data!))
            }
            completion(res.success, res.code, res.message, nil)
        })
    }
    
    static func search(text:String, completion: @escaping (Bool, Int, String, [User]) -> Void) {
        Connection.request(path:"/api/v1/users/search", post:["text":text], completion: { res in
            var users:[User] = []
            let results = res.data!["users"].arrayValue
            for result in results {
                users.append(to(from:result))
            }
            completion(res.success, res.code, res.message, users)
        })
    }
    
    static func commend(user:User, completion: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/api/v1/users/commend", post:["userId":String(user.id)], completion: {
            res in
            completion(res.success, res.message)
        })
    }
    
    static func block(user:User, completion: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/api/v1/users/block", post:["userId":String(user.id)], completion: {
            res in
            completion(res.success, res.message)
        })
    }
    
    static func unblock(user:User, completion: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/api/v1/users/unblock", post:["userId":String(user.id)], completion: {
            res in
            completion(res.success, res.message)
        })
    }
    
    static func report(user:User, completion: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/api/v1/users/report", post:["userId":String(user.id)], completion: {
            res in
            completion(res.success, res.message)
        })
    }
    
    static func to(from:JSON) -> User {
        let userId:String = from["_id"].stringValue
        let creationDate:Date = Dates.from(str:from["creationDate"].stringValue)
        let user:User = User(id:userId, creationDate:creationDate)
        
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
