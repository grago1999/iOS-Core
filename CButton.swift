//
//  CButton.swift
//  Qume
//
//  Created by Gianluca Rago on 11/19/17.
//  Copyright © 2017 Ragoware. All rights reserved.
//

import UIKit

class CButton: UIButton {

    private var id:String
    
    init(frame:CGRect, id:String) {
        self.id = id
        super.init(frame:frame)
        self.setTitle(LocaleMessages.get(id:id), for:.normal)
        self.backgroundColor = .clear
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
