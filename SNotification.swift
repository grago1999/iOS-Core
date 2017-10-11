//
//  SNotification.swift
//  Core
//
//  Created by Gianluca Rago on 8/4/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

class SNotification {

    private var id:String
    private var title:String
    private var msg:String
    
    init(id:String, title:String, msg:String) {
        self.id = id
        self.title = title
        self.msg = msg
    }
    
    init() {
        self.id = ""
        self.title = ""
        self.msg = ""
    }
    
    func getId() -> String {
        return id
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getMsg() -> String {
        return msg
    }
    
}
