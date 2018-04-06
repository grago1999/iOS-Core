//
//  SView.swift
//  Core
//
//  Created by Gianluca Rago on 7/8/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit

class CView: UIView {
    
    public private(set) var id:String
    private var loadingView:CView?
    
    init(frame:CGRect, id:String) {
        self.id = id
        super.init(frame:frame)
        self.backgroundColor = .clear
    }
    
    init() {
        self.id = ""
        super.init(frame:.zero)
    }
    
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 0.0
        self.layer.shadowOpacity = View.Shadow.opacity
        self.layer.shadowOffset = View.Shadow.size
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func hideShadow() {
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOpacity = 0.0
    }
    
    func remove() {
        UIView.animate(withDuration:View.Animation.duration, animations: {
            self.alpha = 0
        }, completion: { done in
            self.removeFromSuperview()
        })
    }
    
    func startLoading() {
        loadingView = View.createLoadingView(view:self)
        self.addSubview(loadingView!)
    }
    
    func stopLoading() {
        Common.isLoading = false
        loadingView?.remove()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = ""
        super.init(coder:aDecoder)
    }

}
