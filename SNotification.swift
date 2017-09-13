//
//  SNotification.swift
//  Location Base
//
//  Created by Gianluca Rago on 8/4/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit

class SNotification {

    private var id:String
    
    init(id:String) {
        self.id = id
    }
    
    init() {
        self.id = ""
    }
    
    func getId() -> String {
        return id
    }
    
}
