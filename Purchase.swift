//
//  Purchase.swift
//  Game Base
//
//  Created by Gianluca Rago on 6/18/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import Foundation

class Purchase {

    public private(set) var id:Int
    
    public private(set) var purchaseTypeId:Int
    
    public private(set) var creationDate:Date?
    
    init(id:Int, purchaseTypeId:Int) {
        self.id = id
        self.purchaseTypeId = purchaseTypeId
    }

}
