//
//  Connection.swift
//  Location Base
//
//  Created by Gianluca Rago on 7/2/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit
import SwiftyJSON
import ReachabilitySwift

class Connection {
    
    static let reachability:Reachability = Reachability()!
    
    static var hasPrepared:Bool = false
    
    private static let config = URLSessionConfiguration.default
    private static var session:URLSession?
    
    static func prepare() {
        if !hasPrepared {
            if Config.dev && Config.fake {
                Responses.addFake(path:"/base/api/v1/status.php", data:[
                    "status": true
                ])
                Responses.addFake(path:"/base/api/v1/includes/login.php", data:[
                    "clientVersion": Config.prodVersion,
                    "globalMessages": [],
                    "user": Users.rand()
                ])
                Responses.addFake(path:"/base/api/v1/includes/register.php", data:[
                    "clientVersion": Config.prodVersion,
                    "globalMessages": [],
                    "user": Users.rand()
                ])
                Responses.addFake(path:"/base/api/v1/notes/getNearby.php", data:[
                    "notes": [
                        Notes.rand(),
                        Notes.rand(),
                        Notes.rand(),
                        Notes.rand(),
                        Notes.rand(),
                        Notes.rand(),
                        Notes.rand(),
                        Notes.rand(),
                        Notes.rand(),
                        Notes.rand()
                    ]
                ])
                Responses.addFake(path:"/base/api/v1/user/updatePassword.php", data:[:])
            }
            if reachability.currentReachabilityStatus == .notReachable {
                Common.attemptLater(fromNow:2, attempt: {
                    Connection.prepare()
                })
            } else {
                session = URLSession(configuration:config)
                Connection.status(completionHandler: { success, msg, status in
                    Common.log(prefix:.debug, str:"Status: \(status) with success: \(success) and msg: \(msg)")
                    if success {
                        if status {
                            Connection.hasPrepared = true
                        } else {
                            Common.attemptLater(fromNow:2, attempt: {
                                Connection.prepare()
                            })
                        }
                    } else {
                        Common.attemptLater(fromNow:2, attempt: {
                            Connection.prepare()
                        })
                    }
                })
            }
        }
    }
    
    static func status(completionHandler: @escaping (Bool, String, Bool) -> Void) {
        request(path:"/base/api/v1/status.php", postDict:[:], completionHandler: { success, msg, json in
            var status:Bool = false
            if success {
                status = json["data"]["status"].boolValue
            }
            completionHandler(success, msg, status)
        })
    }
    
    static func request(path:String, postDict:[String:String], completionHandler: @escaping (Bool, String, JSON) -> Void) {
        if reachability.currentReachabilityStatus == .notReachable {
            Common.attemptLater(fromNow:1, attempt: {
                request(path:path, postDict:postDict, completionHandler: { success, msg, json in
                    completionHandler(success, msg, json)
                })
            })
        } else {
            guard let url = URL(string:Config.url+path) else {
                Common.log(prefix:.error, str:"Could not create URL")
                return
            }
            if Config.dev && Config.fake {
                DispatchQueue.global(qos:.background).async {
                    let response = Responses.rand(path:path)
                    completionHandler(response["success"].boolValue, response["msg"].stringValue, response)
                }
            } else {
                var post:String = ""
                var isFirst:Bool = true
                for key in postDict.keys {
                    var val:String = ""
                    if isFirst {
                        isFirst = false
                    } else {
                        val += "&"
                    }
                    val += key+"="+postDict[key]!
                    post += val
                }
                var urlRequest = URLRequest(url:url)
                urlRequest.httpMethod = "POST"
                urlRequest.httpBody = post.data(using:String.Encoding.utf8)
                let task = session?.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                    var msg:String = ""
                    if error == nil {
                        let json = JSON(data:data!)
                        let success:Bool = json["success"].boolValue
                        if let oldMsg = json["msg"].string {
                            msg = oldMsg
                        } else {
                            msg = json["msg"]["msg"].stringValue
                        }
                        Common.log(prefix:.debug, str:"Request to \(Config.url+path) with success: \(success) with message: \(msg)")
                        if msg == "Not logged in" {
                            Common.attemptLater(fromNow:1, attempt: {
                                request(path:path, postDict:postDict, completionHandler: { success, msg, json in
                                    completionHandler(success, msg, json)
                                })
                            })
                        } else {
                            completionHandler(success, msg, json)
                        }
                    } else {
                        Common.log(prefix:.error, str:error.debugDescription)
                    }
                })
                task?.resume()
            }
        }
    }
    
}
