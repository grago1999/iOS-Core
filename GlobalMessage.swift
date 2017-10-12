//
//  GlobalMessage.swift
//  Game Base
//
//  Created by Gianluca Rago on 6/11/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import Foundation

class GlobalMessage {
    
    public private(set) var id:Int
    public private(set) var title:String
    public private(set) var description:String
    public private(set) var imgName:String
    public private(set) var shouldStop:Bool
    public private(set) var startDate:Date?
    public private(set) var endDate:Date?
    public private(set) var creationDate:Date?
    
    init(id:Int, title:String, description:String, imgName:String, shouldStop:Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.imgName = imgName
        self.shouldStop = shouldStop
    }
    
}
