//
//  Authentication.swift
//  Core
//
//  Created by Gianluca Rago on 8/12/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import SwiftyJSON

class Authentication {
    
    static func login(email:String, p:String, completionHandler: @escaping (Bool, String) -> Void) {
        if Connection.prepared {
            Connection.request(path:"/base/api/v1/includes/login", post:["email":email, "p":Common.hash(str:p), "client":"0", "locale":"en"], completionHandler: { res in
                Common.log(prefix:.debug, str:"Login \(res.success)")
                if res.success {
                    if validate(client:res.data) {
                        Users.main = Users.to(from:res.data)
                        Users.addRetrieved(user:Users.main!)
                        let hasEmailSaved:Bool = Secure.add(value:email, key:"email")
                        let hasPSaved:Bool = Secure.add(value:p, key:"p")
                        if hasEmailSaved && hasPSaved {
                            Settings.set(value:true, key:.hasSignedInWithEmail)
                        }
                    } else {
                        Common.log(prefix:.debug, str:"Invalid client")
                        completionHandler(false, res.msg)
                    }
                }
                completionHandler(res.success, res.msg)
            })
        } else {
            Common.attemptLater(fromNow:0.2, attempt: {
                login(email:email, p:p, completionHandler: { success, msg in
                    completionHandler(success, msg)
                })
            })
        }
    }
    
    static func register(email:String, p:String, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/includes/register", post:["email":email, "p":Common.hash(str:p), "client":"0", "locale":"en"], completionHandler: { res in
            if res.success {
                if validate(client:res.data) {
                    Users.main = Users.to(from:res.data)
                    Users.addRetrieved(user:Users.main!)
                    Settings.set(value:true, key:.hasSignedInWithEmail)
                    Common.log(prefix:.debug, str:"Register \(res.success) as \(Users.main!.getUsername())")
                    let hasEmailSaved:Bool = Secure.add(value:email, key:"email")
                    let hasPSaved:Bool = Secure.add(value:p, key:"p")
                    if hasEmailSaved && hasPSaved {
                        Settings.set(value:true, key:.hasSignedInWithEmail)
                    }
                } else {
                    Common.log(prefix:.debug, str:"Invalid client")
                    completionHandler(false, res.msg)
                }
            } else {
                Common.log(prefix:.debug, str:"Login \(res.success)")
            }
            completionHandler(res.success, res.msg)
        })
    }
    
    static func update(p:String, completionHandler: @escaping (Bool, String) -> Void) {
        let hashedP = Common.hash(str:p)
        Connection.request(path:"/base/api/v1/user/updatePassword", post:["p":hashedP], completionHandler: {
            res in
            if res.success {
                Settings.set(value:true, key:.needsToUpdatePassword)
                let hasPSaved:Bool = Secure.add(value:hashedP, key:"p")
                if hasPSaved {
                    Common.log(prefix:.debug, str:"New password ready")
                    completionHandler(true, res.msg)
                } else {
                    Common.log(prefix:.error, str:"Could not handle password locally")
                    completionHandler(false, "Could not handle password locally")
                }
            }
            completionHandler(res.success, res.msg)
        })
    }
    
    static func credientials() -> (String?, String?) {
        if let email = Secure.get(key:"email") {
            if let p = Secure.get(key:"p") {
                return (email, p)
            }
        }
        return (nil, nil)
    }
    
    static func isValid(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return email != "" && emailTest.evaluate(with:email)
    }
    
    static func isValid(p:String, min:Int) -> Bool {
        let pRegEx:String = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{\(min),}"
        let pTest = NSPredicate(format:"SELF MATCHES %@", pRegEx)
        return pTest.evaluate(with:p)
    }
    
    static func validate(client:JSON) -> Bool {
        Common.globalMessages = []
        let retrievedClientVersion:String = client["data"]["clientVersion"].stringValue
        let retrievedGlobalMessages:[JSON] = client["data"]["globalMessages"].arrayValue
        for retrievedGlobalMessage in retrievedGlobalMessages {
            let globalMessage:GlobalMessage = GlobalMessage(id:retrievedGlobalMessage["id"].intValue, title:retrievedGlobalMessage["title"].stringValue, description:retrievedGlobalMessage["description"].stringValue, imgName:retrievedGlobalMessage["imgName"].stringValue, shouldStop:retrievedGlobalMessage["shouldStop"].boolValue)
            Common.globalMessages.append(globalMessage)
        }
        return retrievedClientVersion == Config.prodVersion
    }
    
    static func randomHashedP() -> String {
        let orgStr:String = Common.words != nil ? Common.randPhrase(length:6, spaces:false)! : String(Common.rand(num:10))
        return Common.hash(str:orgStr)
    }
    
}
