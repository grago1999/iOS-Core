//
//  PurchaseType.swift
//  Game Base
//
//  Created by Gianluca Rago on 6/18/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseType {

    private var id:Int
    private var productId:String
    
    private var title:String
    private var description:String
    
    private var priceUSD:Double
    private var imgName:String
    
    private var creationDate:Date?
    
    init(id:Int, productId:String, title:String, description:String, priceUSD:Int, imgName:String) {
        self.id = id
        self.productId = productId
        self.title = title
        self.description = description
        self.priceUSD = Double(priceUSD)/100.0
        self.imgName = imgName
    }
    
    func getId() -> Int {
        return id
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getDescription() -> String {
        return description
    }

    func getProductId() -> String {
        return productId
    }
    
}
