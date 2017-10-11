//
//  Purchases.swift
//  Core
//
//  Created by Gianluca Rago on 8/12/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//
class Purchases {
    
    static func add(purchaseTypeId:Int, completionHandler: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/base/api/v1/user/addPurchase", post:["purchaseTypeId":String(purchaseTypeId)], completionHandler: {
            res in
            completionHandler(res.success, res.msg)
        })
    }
    
    static func get(completionHandler: @escaping (Bool, String, [Purchase]) -> Void) {
        Connection.request(path:"/base/api/v1/user/getPurchases", post:[:], completionHandler: {
            res in
            var purchases:[Purchase] = []
            let purchaseArr = res.data["purchases"].arrayValue
            for purchaseJSON in purchaseArr {
                let purchaseId:Int = purchaseJSON["id"].intValue
                let purchaseTypeId:Int = purchaseJSON["purchaseTypeId"].intValue
                let purchase = Purchase(id:purchaseId, purchaseTypeId:purchaseTypeId)
                purchases.append(purchase)
            }
            completionHandler(res.success, res.msg, purchases)
        })
    }
    
    static func getStore(completionHandler: @escaping (Bool, String, [PurchaseType]) -> Void) {
        Connection.request(path:"/base/api/v1/store/get", post:[:], completionHandler: {
            res in
            var purchaseTypes:[PurchaseType] = []
            let purchaseTypesArr = res.data["purchaseTypes"].arrayValue
            for purchaseTypeJSON in purchaseTypesArr {
                let purchaseTypeId:Int = purchaseTypeJSON["typeId"].intValue
                let productId:String = purchaseTypeJSON["productId"].stringValue
                let title:String = purchaseTypeJSON["title"].stringValue
                let description:String = purchaseTypeJSON["description"].stringValue
                let priceUSD:Int = purchaseTypeJSON["priceUSD"].intValue
                let imgName:String = purchaseTypeJSON["imgName"].stringValue
                let purchaseType = PurchaseType(id:purchaseTypeId, productId:productId, title:title, description:description, price:Double(priceUSD)/100.0, imgName:imgName)
                purchaseTypes.append(purchaseType)
            }
            completionHandler(res.success, res.msg, purchaseTypes)
        })
    }

}
