//
//  Authentication.swift
//  Core
//
//  Created by Gianluca Rago on 8/12/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import SwiftyJSON

class Authentication {
    
    static func login(email:String, p:String, completion: @escaping (Response) -> Void) {
        if Connection.prepared {
            Connection.request(path:"/api/v1/auth/login", post:["email":email, "p":p, "client":"0", "locale":"en"], completion: { res in
                Common.log(prefix:.debug, str:"Login \(res.success)")
                if res.success {
                    if validate(client:res.data!) {
                        Users.set(main:Users.to(from:res.data!["user"]))
                        let hasEmailSaved:Bool = Secure.add(value:email, key:"email")
                        let hasPSaved:Bool = Secure.add(value:p, key:"p")
                        if hasEmailSaved && hasPSaved {
                            Settings.set(value:true, key:.hasSignedInWithEmail)
                        }
                    } else {
                        Common.log(prefix:.debug, str:"Invalid client")
                        completion(res)
                    }
                }
                completion(res)
            })
        } else {
            Common.attemptLater(fromNow:0.2) {
                login(email:email, p:p) { res in
                    completion(res)
                }
            }
        }
    }
    
    static func login(anonId:String, p:String, completion: @escaping (Response) -> Void) {
        if Connection.prepared {
            Connection.request(path:"/api/v1/auth/login", post:["anon_id":anonId, "p":p, "client":"0", "locale":"en"]) { res in
                Common.log(prefix:.debug, str:"Login \(res.success)")
                if res.success {
                    if validate(client:res.data!) {
                        print(res.data!)
                        Users.set(main:Users.to(from:res.data!["user"]))
                        let hasSavedAnonId:Bool = Secure.add(value:anonId, key:"anonId")
                        let hasPSaved:Bool = Secure.add(value:p, key:"p")
                        if hasSavedAnonId && hasPSaved {
                            Settings.set(value:true, key:.hasSignedInAnon)
                        }
                    } else {
                        Common.log(prefix:.debug, str:"Invalid client")
                        completion(res)
                    }
                }
                completion(res)
            }
        } else {
            Common.attemptLater(fromNow:0.2) {
                login(anonId:anonId, p:p) { res in
                    completion(res)
                }
            }
        }
    }
    
    static func signUp(email:String, p:String, completion: @escaping (Response) -> Void) {
        Connection.request(path:"/api/v1/auth/signup", post:["email":email, "p":p, "client":"0", "locale":"en"]) { res in
            if res.success {
                if validate(client:res.data!) {
                    Users.set(main:Users.to(from:res.data!))
                    Settings.set(value:true, key:.hasSignedInWithEmail)
                    Common.log(prefix:.debug, str:"Register \(res.success) as \(Users.main!.id)")
                    let hasEmailSaved:Bool = Secure.add(value:email, key:"email")
                    let hasPSaved:Bool = Secure.add(value:p, key:"p")
                    if hasEmailSaved && hasPSaved {
                        Settings.set(value:true, key:.hasSignedInAnon)
                    }
                } else {
                    Common.log(prefix:.debug, str:"Invalid client")
                    completion(res)
                }
            } else {
                Common.log(prefix:.debug, str:"Login \(res.success)")
            }
            completion(res)
        }
    }
    
    static func signUp(p:String, completion: @escaping (Response) -> Void) {
        let anonId:String = generateAnonId()
        Connection.request(path:"/api/v1/auth/signup", post:["anon_id":anonId, "p":p, "client":"0", "locale":"en"]) { res in
            if res.success {
                if validate(client:res.data!) {
                    Users.set(main:Users.to(from:res.data!))
                    Settings.set(value:true, key:.hasSignedInWithEmail)
                    Common.log(prefix:.debug, str:"Register \(res.success) as \(Users.main!.id)")
                    let hasSavedAnonId:Bool = Secure.add(value:anonId, key:"anonId")
                    let hasPSaved:Bool = Secure.add(value:p, key:"p")
                    if hasSavedAnonId && hasPSaved {
                        Settings.set(value:true, key:.hasSignedInAnon)
                    }
                } else {
                    Common.log(prefix:.debug, str:"Invalid client")
                    completion(res)
                }
            } else {
                Common.log(prefix:.debug, str:"Login \(res.success)")
            }
            completion(res)
        }
    }
    
    static func update(p:String, completion: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/api/v1/auth/update", post:["p":p]) {
            res in
            if res.success {
                Settings.set(value:true, key:.needsToUpdatePassword)
                let hasPSaved:Bool = Secure.add(value:p, key:"p")
                if hasPSaved {
                    Common.log(prefix:.debug, str:"New password ready")
                    completion(true, res.message)
                } else {
                    Common.log(prefix:.error, str:"Could not handle password locally")
                    completion(false, "Could not handle password locally")
                }
            }
            completion(res.success, res.message)
        }
    }
    
    static func credientials() -> (String, String, Bool)? {
        if let email = Secure.get(key:"email") {
            if let p = Secure.get(key:"p") {
                return (email, p, false)
            }
        } else if let anonId = Secure.get(key:"anonId") {
            if let p = Secure.get(key:"p") {
                return (anonId, p, true)
            }
        }
        return nil
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
        let retrievedClientVersion:String = client["clientVersion"].stringValue
        let retrievedGlobalMessages:[JSON] = client["globalMessages"].arrayValue
        for retrievedGlobalMessage in retrievedGlobalMessages {
            let globalMessage:GlobalMessage = GlobalMessage(id:retrievedGlobalMessage["id"].intValue, title:retrievedGlobalMessage["title"].stringValue, description:retrievedGlobalMessage["description"].stringValue, imgName:retrievedGlobalMessage["imgName"].stringValue, shouldStop:retrievedGlobalMessage["shouldStop"].boolValue)
            Common.globalMessages.append(globalMessage)
        }
        return retrievedClientVersion == Config.prodVersion
    }
    
    private static func generateAnonId() -> String {
        let hashedDeviceId:String = Common.hash(str:(UIDevice.current.identifierForVendor?.uuidString)!)
        Common.log(prefix:.debug, str:"Hashed anonId: \(hashedDeviceId)")
        return hashedDeviceId
    }
    
    static func randomP() -> String {
        return Common.words != nil ? Common.randPhrase(length:6, spaces:false)! : String(Common.rand(num:10))
    }
    
}
