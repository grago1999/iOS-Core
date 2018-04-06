//
//  CScrollView.swift
//  Qume
//
//  Created by Gianluca Rago on 11/21/17.
//  Copyright © 2017 Ragoware. All rights reserved.
//

import UIKit

class CScrollView: UIScrollView {
    
    typealias actionHandler = () -> Void

    private var id:String
    
    public private(set) var itemViews:[CView] = []
    public private(set) var viewCount:Int = 0
    private var handlers:[Int:actionHandler] = [:]
    
    private var loadingView:CView?
    
    enum Side:Int {
        case left = 0
        case right = 1
    }
    
    init(frame:CGRect, id:String) {
        self.id = id
        super.init(frame:frame)
        self.contentSize = CGSize(width:frame.size.width, height:frame.size.height)
        self.contentOffset = .zero
    }
    
    func add(id:String, major:String, minor:String = "", image:UIImage? = nil, handler:@escaping actionHandler) {
        let overlap:CGFloat = 10.0
        let y:CGFloat = itemViews.count > 0 ? itemViews.last!.frame.origin.y+itemViews.last!.frame.size.height : 0.0
        let height:CGFloat = self.frame.size.height/6
        let majorHeight:CGFloat = minor == "" ? height : height/3
        
        let itemView = CView(frame:CGRect(x:0, y:y, width:self.frame.size.width, height:height), id:id)
        self.addSubview(itemView)
        
        let majorLabel:CLabel = CLabel(frame:CGRect(x:View.margin, y:0, width:itemView.frame.size.width-View.margin, height:majorHeight), id:id+"-major-label")
        majorLabel.text = major
        majorLabel.font = Fonts.general
        majorLabel.layer.zPosition = 3
        itemView.addSubview(majorLabel)
        
        if minor != "" {
            let minorLabel:CTextView = CTextView(frame:CGRect(x:View.margin, y:majorHeight-overlap, width:itemView.frame.size.width-View.margin, height:height-majorHeight-overlap), id:id+"-minor-label")
            minorLabel.text = minor
            minorLabel.isUserInteractionEnabled = false
            minorLabel.layer.zPosition = 3
            itemView.addSubview(minorLabel)
        }
        
        if let existingImage = image {
            let imageView:CImageView = CImageView(frame:CGRect(origin:.zero, size:itemView.frame.size), id:"item-background-image-view")
            imageView.image = existingImage
            imageView.addOverlay()
            itemView.addSubview(imageView)
            
            majorLabel.textColor = UIColor.white.withAlphaComponent(0.95)
            majorLabel.center()
        }
        
        let max:CGFloat = itemView.frame.origin.y+itemView.frame.size.height
        if max > self.contentSize.height {
            self.contentSize = CGSize(width:View.width, height:max)
        }
        
        let btn:CButton = CButton(frame:CGRect(origin:.zero, size:itemView.frame.size), id:id+"-btn")
        btn.addTarget(self, action:#selector(act(btn:)), for:.touchUpInside)
        btn.tag = viewCount
        itemView.addSubview(btn)
        
        handlers[btn.tag] = handler
        itemViews.append(itemView)
        viewCount+=1
    }
    
    func add(id:String, side:Side, text:String) {
        let width:CGFloat = self.frame.size.width*(2/3)
        var x:CGFloat = 0.0
        if side == .right {
            x = self.frame.size.width-width
        }
        let y:CGFloat = itemViews.count > 0 ? itemViews.last!.frame.origin.y+itemViews.last!.frame.size.height : 0.0
        
        let textView = CTextView(frame:CGRect(origin:.zero, size:CGSize(width:width, height:0)), id:id+"-text-view")
        textView.text = text
        textView.sizeToFit()
        textView.isScrollEnabled = false
        
        let itemView = CView(frame:CGRect(x:x, y:y, width:width, height:textView.frame.size.height), id:id)
        self.addSubview(itemView)
        itemView.addSubview(textView)
        
        itemViews.append(itemView)
        viewCount+=1
    }
    
    @objc private func act(btn:UIButton) {
        DispatchQueue.main.async {
            self.handlers[btn.tag]!()
        }
    }
    
    func remove() {
        UIView.animate(withDuration:View.Animation.duration, animations: {
            self.alpha = 0
        }, completion: { done in
            self.removeFromSuperview()
        })
    }
    
    func clear() {
        for itemView in itemViews {
            itemView.removeFromSuperview()
        }
        itemViews = []
    }
    
    func startLoading() {
        loadingView = View.createLoadingView(view:self as UIView)
        self.addSubview(loadingView!)
    }
    
    func stopLoading() {
        Common.isLoading = false
        loadingView?.remove()
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
