//
//  User.swift
//  Game Base
//
//  Created by Gianluca Rago on 2/23/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit

class User {
    
    private var id:Int
    private var username:String
    private var banned:Bool
    private var privacy:Int
    private var creationDate:Date?
    
    private var friends:[User]?
    
    init(id:Int, username:String, banned:Bool, privacy:Int) {
        self.id = id
        self.username = username
        self.banned = banned
        self.privacy = privacy
    }
    
    init() {
        self.id = 0
        self.username = ""
        self.banned = false
        self.privacy = 0
    }
    
    fileprivate func update(friends:[User]) {
        self.friends = friends
    }
    
    func update(privacy:Int, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/updatePrivacy.php", postDict:["privacy":String(privacy)], completionHandler: {
            success, msg, json in
            if success {
                self.privacy = privacy
            }
            completionHandler(success, msg)
        })
    }
    
    func getId() -> Int {
        return id
    }

    func getUsername() -> String {
        return username
    }
    
    func isBanned() -> Bool {
        return banned
    }
    
    func getPrivacy() -> Int {
        return privacy
    }
    
    func canInteractWithUser(completionHandler: @escaping (Bool) -> Void) {
        if isBanned() {
            completionHandler(false)
        } else {
            canInteractWithPrivacy(completionHandler: { canInteract in
                if canInteract {
                    
                } else {
                    completionHandler(false)
                }
            })
        }
    }
    
    private func canInteractWithPrivacy(completionHandler: @escaping (Bool) -> Void) {
        if getPrivacy() == 0 {
            completionHandler(true)
        } else if getPrivacy() == 2 {
            Users.main!.getFriends(forceUpdate:false, completionHandler: { success, msg, friends in
                if success {
                    var isFriend:Bool = false
                    for friend in friends {
                        if friend.getId() == self.getId() {
                            isFriend = true
                            break
                        }
                    }
                    completionHandler(isFriend)
                }
            })
        }
        completionHandler(true)
    }
    
    func getFriends(forceUpdate:Bool, completionHandler: @escaping (Bool, String, [User]) -> Void) {
        if let friends = self.friends {
            if forceUpdate {
                Users.getFriends(user:self, completionHandler: { success, msg, retrievedFriends in
                    self.update(friends:retrievedFriends)
                    completionHandler(success, msg, retrievedFriends)
                })
            } else {
                completionHandler(true, "Found local friends successfully", friends)
            }
        } else {
            Users.getFriends(user:self, completionHandler: { success, msg, retrievedFriends in
                self.update(friends:retrievedFriends)
                completionHandler(success, msg, retrievedFriends)
            })
        }
    }
    
    func sendFriendInvite(user:User, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/sendFriendInvite.php", postDict:["userId":String(user.getId())], completionHandler: {
            success, msg, json in
            completionHandler(success, msg)
        })
    }
    
    func responseToFriendInvite(user:User, isAccepted:Bool, completionHandler: @escaping (Bool, String) -> Void) {
        var isAccepted:Int = 0
        if isAccepted {
            isAccepted = 1
        }
        Connection.request(path:"/base/api/v1/user/respondFriendInvite.php", postDict:["userId":String(user.getId()), "isAccepted":"\(isAccepted)"], completionHandler: { success, msg, json in
            if success {
                self.getFriends(forceUpdate:true, completionHandler: { success, msg, friends in
                    if success {
                        Common.log(prefix:.debug, str:"Updated friends after invite response")
                    }
                })
            }
            completionHandler(success, msg)
        })
    }
    
}
