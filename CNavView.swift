//
//  NavView.swift
//  Qume
//
//  Created by Gianluca Rago on 11/17/17.
//  Copyright © 2017 Ragoware. All rights reserved.
//

import UIKit

class CNavView: CView {
    
    private var label:CLabel?
    
    init(id:String) {
        super.init(frame:CGRect(x:0, y:0, width:View.width, height:View.status.height+View.Nav.size.height), id:id)
        self.backgroundColor = .white
        let title:String = LocaleMessages.get(id:id+"-label")
        if title != "" {
            self.label = CLabel(frame:CGRect(x:View.margin, y:View.status.height, width:View.width-View.margin, height:View.Nav.size.height), id:id+"-label")
            self.addSubview(self.label!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
}
