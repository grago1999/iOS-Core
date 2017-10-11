//
//  Connection.swift
//  Core
//
//  Created by Gianluca Rago on 7/2/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import SwiftyJSON
import ReachabilitySwift

class Connection {
    
    private static let reachability:Reachability = Reachability()!
    
    static var prepared:Bool = false
    
    private static let config = URLSessionConfiguration.default
    private static var session:URLSession?
    
    static func prepare() {
        if !prepared && !Config.dev && !Config.fake {
            if reachability.currentReachabilityStatus == .notReachable {
                Common.attemptLater(fromNow:2, attempt: {
                    Connection.prepare()
                })
            } else {
                session = URLSession(configuration:config)
                Connection.status(completionHandler: { res, status in
                    Common.log(prefix:.debug, str:"Status: \(status) with success: \(res.success) and msg: \(res.msg)")
                    if res.success {
                        if status {
                            Connection.prepared = true
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
    
    private static func status(completionHandler: @escaping (Response, Bool) -> Void) {
        request(path:"/base/api/v1/status", post:[:], completionHandler: { res in
            var status:Bool = false
            if res.success {
                status = res.data["status"].boolValue
            }
            completionHandler(res, status)
        })
    }
    
    static func request(baseUrl:String? = nil, path:String, post:[String:String], completionHandler: @escaping (Response) -> Void) {
        var base:String = Config.url
        if baseUrl != nil {
            base = baseUrl!
        }
        if reachability.currentReachabilityStatus == .notReachable {
            Common.attemptLater(fromNow:1, attempt: {
                request(path:path, post:post, completionHandler: { res in
                    completionHandler(res)
                })
            })
        } else {
            guard let url = URL(string:base+path) else {
                Common.log(prefix:.error, str:"Could not create URL")
                return
            }
            if Config.dev && Config.fake {
                DispatchQueue.global(qos:.background).async {
                    let response = Responses.rand(path:path)
                    completionHandler(Response(url:baseUrl!+path, success:response["success"].boolValue, msg:response["msg"].stringValue, data:response["data"]))
                }
            } else {
                var postStr:String = ""
                var isFirst:Bool = true
                for key in post.keys {
                    var val:String = ""
                    if isFirst {
                        isFirst = false
                    } else {
                        val += "&"
                    }
                    val += key+"="+post[key]!
                    postStr += val
                }
                var urlRequest = URLRequest(url:url)
                urlRequest.httpMethod = "POST"
                urlRequest.httpBody = postStr.data(using:String.Encoding.utf8)
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
                        Common.log(prefix:.debug, str:"Request to \(base+path) with success: \(success) with message: \(msg)")
                        if msg == "Not logged in" {
                            Common.attemptLater(fromNow:1, attempt: {
                                request(path:path, post:post, completionHandler: { res in
                                    completionHandler(Response(url:baseUrl!+path, success:success, msg:msg, data:json["data"]))
                                })
                            })
                        } else {
                            completionHandler(Response(url:baseUrl!+path, success:success, msg:msg, data:json["data"]))
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
