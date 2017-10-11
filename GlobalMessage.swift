//
//  GlobalMessage.swift
//  Game Base
//
//  Created by Gianluca Rago on 6/11/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import Foundation

class GlobalMessage {
    
    private var id:Int
    private var title:String
    private var description:String
    private var imgName:String
    private var shouldStop:Bool
    private var startDate:Date?
    private var endDate:Date?
    private var creationDate:Date?
    
    init(id:Int, title:String, description:String, imgName:String, shouldStop:Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.imgName = imgName
        self.shouldStop = shouldStop
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
    
    func getImgName() -> String {
        return imgName
    }
    
    func getShouldStop() -> Bool {
        return shouldStop
    }
    
}
