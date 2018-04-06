//
//  Purchases.swift
//  Core
//
//  Created by Gianluca Rago on 8/12/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//
class Purchases {
    
    static func add(purchaseTypeId:Int, completion: @escaping (Bool, String) -> Void) {
        Connection.request(path:"/api/v1/user/addPurchase", post:["purchaseTypeId":String(purchaseTypeId)], completion: {
            res in
            completion(res.success, res.message)
        })
    }
    
    static func get(completion: @escaping (Bool, String, [Purchase]) -> Void) {
        Connection.request(path:"/api/v1/user/getPurchases", post:[:], completion: {
            res in
            var purchases:[Purchase] = []
            let purchaseArr = res.data!["purchases"].arrayValue
            for purchaseJSON in purchaseArr {
                let purchaseId:Int = purchaseJSON["id"].intValue
                let purchaseTypeId:Int = purchaseJSON["purchaseTypeId"].intValue
                let purchase = Purchase(id:purchaseId, purchaseTypeId:purchaseTypeId)
                purchases.append(purchase)
            }
            completion(res.success, res.message, purchases)
        })
    }
    
    static func getStore(completion: @escaping (Bool, String, [PurchaseType]) -> Void) {
        Connection.request(path:"/api/v1/store/get", post:[:], completion: {
            res in
            var purchaseTypes:[PurchaseType] = []
            let purchaseTypesArr = res.data!["purchaseTypes"].arrayValue
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
            completion(res.success, res.message, purchaseTypes)
        })
    }

}
