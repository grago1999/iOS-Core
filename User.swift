//
//  User.swift
//  Game Base
//
//  Created by Gianluca Rago on 2/23/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import Foundation

class User {
    
    public private(set) var id:String
    public private(set) var creationDate:Date
    
    init(id:String, creationDate:Date) {
        self.id = id
        self.creationDate = creationDate
    }
   
    
}
