//
//  SNotification.swift
//  Core
//
//  Created by Gianluca Rago on 8/4/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

class SNotification {

    public private(set) var id:String
    public private(set) var title:String
    public private(set) var message:String
    
    init(id:String, title:String, message:String) {
        self.id = id
        self.title = title
        self.message = message
    }
    
}
