//
//  Notifications.swift
//  Core
//
//  Created by Gianluca Rago on 8/4/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class Notifications {
    
    static private let center = UNUserNotificationCenter.current()
    
    static func prepare() {
        //        UIApplication.shared.registerForRemoteNotifications()
        stop()
        center.requestAuthorization(options:[.alert, .badge]) { granted, err in
            if granted {
                
            }
        }
    }
    
    static func create(title:String, id:String, region:CLRegion) {
        let trigger = UNLocationNotificationTrigger(region:region, repeats:false)
        send(title:title, id:id, trigger:trigger)
    }
    
    private static func send(title:String, id:String, trigger:UNNotificationTrigger) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = LocaleMessages.get(id:id)
        let request = UNNotificationRequest(identifier:id, content:content, trigger:trigger)
        center.add(request)
    }
    
    static func stop() {
        center.removeAllPendingNotificationRequests()
    }

}
