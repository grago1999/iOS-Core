//
//  CLabel.swift
//  Qume
//
//  Created by Gianluca Rago on 11/19/17.
//  Copyright © 2017 Ragoware. All rights reserved.
//

import UIKit

class CLabel: UILabel {

    private var id:String
    
    init(frame:CGRect, id:String) {
        self.id = id
        super.init(frame:frame)
        self.textAlignment = .left
        self.font = UIFont.systemFont(ofSize:40.0, weight:.bold)
        self.text = LocaleMessages.get(id:id)
    }
    
    func update(fontSize:CGFloat) {
        self.font = UIFont.systemFont(ofSize:fontSize, weight:.semibold)
    }
    
    init() {
        self.id = ""
        super.init(frame:.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = ""
        super.init(coder:aDecoder)
    }
    
}
