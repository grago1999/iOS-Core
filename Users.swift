//
//  Users.swift
//  Location Base
//
//  Created by Gianluca Rago on 8/12/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit
import SwiftyJSON

class Users {
    
    static var main:User?
    private static var retrieved:[User] = []
    
    private static func getNonMain(users:[User]) -> User {
        var user:User?
        for tempUser in users {
            if tempUser.getId() != main?.getId() {
                user = tempUser
            }
        }
        return user!
    }
    
    static func addRetrieved(user:User) {
        retrieved.append(user)
    }

    static func get(userId:Int, completionHandler: @escaping (Bool, String, User) -> Void) {
        var foundUser:User?
        for user in retrieved {
            if user.getId() == userId {
                foundUser = user
                break
            }
        }
        if let user = foundUser {
            completionHandler(true, "Found local user successfully", user)
        } else {
            Connection.request(path:"/base/api/v1/user/get.php", postDict:["userId":String(userId)], completionHandler: { success, msg, json in
                var user = User()
                if success {
                    user = to(from:json["data"])
                }
                completionHandler(success, msg, user)
            })
        }
    }
    
    static func getFriends(user:User, completionHandler: @escaping (Bool, String, [User]) -> Void) {
        Connection.request(path:"/base/api/v1/user/getFriends.php", postDict:[:], completionHandler: { success, msg, json in
            var users:[User] = []
            let friends = json["data"]["friends"].arrayValue
            for friend in friends {
                users.append(to(from:friend))
            }
            users.sort(by: { $0.getUsername() > $1.getUsername() })
            completionHandler(success, msg, users)
        })
    }
    
    static func search(text:String, completionHandler: @escaping (Bool, String, [User]) -> Void) {
        Connection.request(path:"/base/api/v1/user/search.php", postDict:["text":text], completionHandler: { success, msg, json in
            var users:[User] = []
            let results = json["data"]["users"].arrayValue
            for result in results {
                users.append(to(from:result))
            }
            users.sort(by: { $0.getUsername() > $1.getUsername() })
            completionHandler(success, msg, users)
        })
    }
    
//    static func getCommendations(completionHandler: @escaping (Bool, String, [User]) -> Void) {
//        Connection.request(path:"/base/api/v1/user/getCommendations.php", postDict:[:], completionHandler: { success, msg, json in
//            var users:[User] = []
//            let commendedUsers = json["data"]["commendedUsers"].arrayValue
//            for commendedUser in commendedUsers {
//                users.append(to(from:commendedUser))
//            }
//            users.sort(by: { $0.getUsername() > $1.getUsername() })
//            completionHandler(success, msg, users)
//        })
//    }
//
//    static func getBlocked(completionHandler: @escaping (Bool, String, [User]) -> Void) {
//        Connection.request(path:"/base/api/v1/user/getBlockedUsers.php", postDict:[:], completionHandler: { success, msg, json in
//            var users:[User] = []
//            let blockedUsers = json["data"]["blockedUsers"].arrayValue
//            for blockedUser in blockedUsers {
//                users.append(to(from:blockedUser))
//            }
//            users.sort(by: { $0.getUsername() > $1.getUsername() })
//            completionHandler(success, msg, users)
//        })
//    }
    
    static func commend(user:User, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/commend.php", postDict:["userId":String(user.getId())], completionHandler: {
            success, msg, json in
            completionHandler(success, msg)
        })
    }
    
    static func block(user:User, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/block.php", postDict:["userId":String(user.getId())], completionHandler: {
            success, msg, json in
            completionHandler(success, msg)
        })
    }
    
    static func removeFriend(user:User, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/removeFriend.php", postDict:["userId":String(user.getId())], completionHandler: {
            success, msg, json in
            completionHandler(success, msg)
        })
    }
    
    static func unblock(user:User, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/unblock.php", postDict:["userId":String(user.getId())], completionHandler: {
            success, msg, json in
            completionHandler(success, msg)
        })
    }
    
    static func report(user:User, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/report.php", postDict:["userId":String(user.getId())], completionHandler: {
            success, msg, json in
            completionHandler(success, msg)
        })
    }
    
    static func to(from:JSON) -> User {
        let userId:Int = from["user"]["id"].intValue
        let username:String = from["user"]["username"].stringValue
        let banned:Bool = from["user"]["banned"].boolValue
        let privacy = from["user"]["privacy"].intValue
        //                let xp:Int = blockedUser["user"]["xp"].intValue
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
