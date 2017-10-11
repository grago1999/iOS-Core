//
//  Notifications.swift
//  Core
//
//  Created by Gianluca Rago on 8/4/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit

class Notifications {
    
    private static var queue:[SNotification] = []
    
    static func add(notifcation:SNotification) {
        queue.append(notifcation)
    }
    
    static func getFirst() -> SNotification {
        return has() ? queue.first! : SNotification()
    }
    
    static func remove(id:String) {
        let check = exists(id:id)
        if check.0 {
            queue.remove(at:check.1)
        }
    }
    
    static func exists(id:String) -> (Bool, Int) {
        var exists:Bool = false
        var i:Int = 0
        if has() {
            for notification in queue {
                if notification.getId() == id {
                    exists = true
                    break
                }
                i+=1
            }
        }
        return (exists, i)
    }
    
    static func count() -> Int {
        return queue.count
    }
    
    static func has() -> Bool {
        return queue.count > 0
    }

}
