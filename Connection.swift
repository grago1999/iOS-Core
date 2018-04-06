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
        if !prepared {
            if Config.dev && Config.fake {
                prepared = true
            } else {
                if reachability.currentReachabilityStatus == .notReachable {
                    Common.attemptLater(fromNow:2, attempt: {
                        Connection.prepare()
                    })
                } else {
                    session = URLSession(configuration:config)
                    Connection.status(completion: { res, status in
                        Common.log(prefix:.debug, str:"Status: \(status) with success: \(res.success) and message: \(res.message)")
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
    }
    
    private static func status(completion: @escaping (Response, Bool) -> Void) {
        request(path:"/api/v1/status", get:[:]) { res in
            var status:Bool = false
            if res.success {
                status = res.data!["status"].stringValue == "ok"
            }
            completion(res, status)
        }
    }
    
    static func request(baseUrl:String? = nil, path:String, get:[String:String], completion: @escaping (Response) -> Void) {
        request(baseUrl:baseUrl, path:path, send:get, method:"GET") { response in
            completion(response)
        }
    }
    
    static func request(baseUrl:String? = nil, path:String, post:[String:String], completion: @escaping (Response) -> Void) {
        request(baseUrl:baseUrl, path:path, send:post, method:"POST") { response in
            completion(response)
        }
    }
    
    private static func request(baseUrl:String? = nil, path:String, send:[String:String], method:String, completion: @escaping (Response) -> Void) {
        var base:String = Config.url
        if baseUrl != nil {
            base = baseUrl!
        }
        if reachability.currentReachabilityStatus == .notReachable {
            Common.attemptLater(fromNow:1, attempt: {
                request(path:path, send:send, method:method, completion: { res in
                    completion(res)
                })
            })
        } else {
            var sendStr:String = ""
            var isFirst:Bool = true
            for key in send.keys {
                var val:String = ""
                if isFirst {
                    isFirst = false
                } else {
                    val += "&"
                }
                val += key+"="+send[key]!
                sendStr += val
            }
            var urlStr:String = base+path
            if method == "GET" {
                urlStr += "?"+sendStr
            }
            guard let url = URL(string:urlStr) else {
                Common.log(prefix:.error, str:"Could not create URL")
                return
            }
            if Config.dev && Config.fake {
                DispatchQueue.main.async {
                    let response = Responses.rand(path:path)
                    completion(Response(url:"faked"+path, success:response["success"].boolValue, code:response["code"].intValue, message:response["message"].stringValue, data:response["data"]))
                }
            } else {
                var urlRequest = URLRequest(url:url)
                urlRequest.timeoutInterval = 10
                urlRequest.setValue(Config.origin, forHTTPHeaderField:"origin")
                urlRequest.httpMethod = method
                if method == "POST" {
                    urlRequest.httpBody = sendStr.data(using:String.Encoding.utf8)
                }
                let task = session?.dataTask(with: urlRequest, completionHandler: { data, response, error in
                    if error == nil {
                        let json = JSON(data:data!)
                        let success:Bool = json["success"].boolValue
                        let code:Int = json["code"].intValue
                        let message:String = json["message"].stringValue
                        Common.log(prefix:.debug, str:"Request to \(base+path) with success: \(success) with message: \(message)")
                        completion(Response(url:base+path, success:success, code:code, message:message, data:json["data"]))
                    } else {
                        Common.log(prefix:.error, str:error.debugDescription)
                        completion(Response(url:base+path, success:false, code:1000, message:"error"))
                    }
                })
                task?.resume()
            }
        }
    }
    
}
