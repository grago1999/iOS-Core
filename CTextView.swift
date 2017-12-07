//
//  CTextView.swift
//  Qume
//
//  Created by Gianluca Rago on 11/23/17.
//  Copyright © 2017 Ragoware. All rights reserved.
//

import UIKit

class CTextView: UITextView {

    private var id:String
    
    init(frame:CGRect, id:String) {
        self.id = id
        super.init(frame:frame, textContainer:nil)
        self.backgroundColor = .clear
        self.font = UIFont.systemFont(ofSize:20.0)
    }
    
    init() {
        self.id = ""
        super.init(frame:.zero, textContainer:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = ""
        super.init(coder:aDecoder)
    }
    
}
