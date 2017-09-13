//
//  Purchases.swift
//  Location Base
//
//  Created by Gianluca Rago on 8/12/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit

class Purchases {
    
    static func add(purchaseTypeId:Int, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/addPurchase.php", postDict:["purchaseTypeId":String(purchaseTypeId)], completionHandler: {
            success, msg, json in
            completionHandler(success, msg)
        })
    }
    
    static func get(completionHandler: @escaping (Bool, String, [Purchase]) -> Void) {
        Connection.request(path:"/base/api/v1/user/getPurchases.php", postDict:[:], completionHandler: {
            success, msg, json in
            var purchases:[Purchase] = []
            let purchaseArr = json["data"]["purchases"].arrayValue
            for purchaseJSON in purchaseArr {
                let purchaseId:Int = purchaseJSON["id"].intValue
                let purchaseTypeId:Int = purchaseJSON["purchaseTypeId"].intValue
                let purchase = Purchase(id:purchaseId, purchaseTypeId:purchaseTypeId)
                purchases.append(purchase)
            }
            completionHandler(success, msg, purchases)
        })
    }
    
    static func getStore(completionHandler: @escaping (Bool, String, [PurchaseType]) -> Void) {
        Connection.request(path:"/base/api/v1/store/get.php", postDict:[:], completionHandler: {
            success, msg, json in
            var purchaseTypes:[PurchaseType] = []
            let purchaseTypesArr = json["data"]["purchaseTypes"].arrayValue
            for purchaseTypeJSON in purchaseTypesArr {
                let purchaseTypeId:Int = purchaseTypeJSON["typeId"].intValue
                let productId:String = purchaseTypeJSON["productId"].stringValue
                let title:String = purchaseTypeJSON["title"].stringValue
                let description:String = purchaseTypeJSON["description"].stringValue
                let priceUSD:Int = purchaseTypeJSON["priceUSD"].intValue
                let imgName:String = purchaseTypeJSON["imgName"].stringValue
                let purchaseType = PurchaseType(id:purchaseTypeId, productId:productId, title:title, description:description, priceUSD:priceUSD, imgName:imgName)
                purchaseTypes.append(purchaseType)
            }
            completionHandler(success, msg, purchaseTypes)
        })
    }

}
