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
        self.font = Fonts.title
        self.text = LocaleMessages.get(id:id)
        self.textColor = .white
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
    }
    
    func center() {
        self.textAlignment = .center
    }
    
    func remove() {
        UIView.animate(withDuration:View.Animation.duration, animations: {
            self.alpha = 0
        }, completion: { done in
            self.removeFromSuperview()
        })
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
