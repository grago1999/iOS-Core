//
//  NavView.swift
//  Qume
//
//  Created by Gianluca Rago on 11/17/17.
//  Copyright © 2017 Ragoware. All rights reserved.
//

import UIKit

class CNavView: CView {
    
    public private(set) var label:CLabel?
    
    init(id:String) {
        super.init(frame:CGRect(x:0, y:0, width:View.width, height:View.Status.height+View.Nav.size.height), id:id)
        let title:String = LocaleMessages.get(id:id)
        if title != "" {
            self.label = CLabel(frame:CGRect(x:View.margin, y:View.Status.height, width:View.width-(View.margin*2), height:View.Nav.size.height), id:id)
            self.addSubview(self.label!)
        }
    }
    
    func center() {
        label?.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
}
