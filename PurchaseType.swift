//
//  PurchaseType.swift
//  Game Base
//
//  Created by Gianluca Rago on 6/18/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import Foundation

class PurchaseType {

    public private(set) var id:Int
    public private(set) var productId:String
    
    public private(set) var title:String
    public private(set) var description:String
    
    public private(set) var price:Double
    public private(set) var imgName:String
    
    public private(set) var creationDate:Date?
    
    init(id:Int, productId:String, title:String, description:String, price:Double, imgName:String) {
        self.id = id
        self.productId = productId
        self.title = title
        self.description = description
        self.price = price
        self.imgName = imgName
    }
    
}
