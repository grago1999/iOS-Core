//
//  CImageView.swift
//  Anchor
//
//  Created by Gianluca Rago on 2/15/18.
//  Copyright © 2018 Anchor. All rights reserved.
//

import UIKit

class CImageView: UIImageView {

    public private(set) var id:String
    
    init(frame:CGRect, id:String) {
        self.id = id
        super.init(frame:frame)
        self.backgroundColor = .clear
        self.contentMode = .scaleAspectFill
        self.layer.masksToBounds = true
    }
    
    init() {
        self.id = ""
        super.init(frame:.zero)
    }
    
    func addOverlay() {
        let overlay:CView = CView(frame:CGRect(origin:.zero, size:self.frame.size), id:"image-view-overlay")
        overlay.backgroundColor = Colors.gray.withAlphaComponent(0.5)
        overlay.layer.zPosition = 2
        self.addSubview(overlay)
    }
    
    func remove() {
        UIView.animate(withDuration:View.Animation.duration, animations: {
            self.alpha = 0
        }, completion: { done in
            self.removeFromSuperview()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = ""
        super.init(coder:aDecoder)
    }

}
