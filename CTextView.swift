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
        self.textColor = .white
        self.font = Fonts.general
    }
    
    init() {
        self.id = ""
        super.init(frame:.zero, textContainer:nil)
    }
    
    func fit() {
        let fixedWidth = self.frame.size.width
        self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = self.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.frame = newFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = ""
        super.init(coder:aDecoder)
    }
    
}
