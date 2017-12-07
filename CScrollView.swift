//
//  CScrollView.swift
//  Qume
//
//  Created by Gianluca Rago on 11/21/17.
//  Copyright © 2017 Ragoware. All rights reserved.
//

import UIKit

class CScrollView: UIScrollView {

    private var id:String
    private var itemViews:[CView] = []
    public private(set) var viewCount:Int = 0
    typealias actionHandler = () -> Void
    private var handlers:[Int:actionHandler] = [:]
    
    private let top:CGFloat = 40.0
    
    enum Side:Int {
        case left = 0
        case right = 1
    }
    
    init(frame:CGRect, id:String) {
        self.id = id
        super.init(frame:frame)
        self.contentSize = CGSize(width:frame.size.width, height:frame.size.height+top)
        self.contentOffset = CGPoint(x:0, y:top)
    }
    
    func add(id:String, major:String, minor:String = "", handler:@escaping actionHandler) {
        let overlap:CGFloat = 10.0
        var y:CGFloat = top
        if itemViews.count > 0 {
            y = itemViews.last!.frame.origin.y+itemViews.last!.frame.size.height
        }
        var height:CGFloat = self.frame.size.height/6
        var majorHeight:CGFloat = height/3
        if minor == "" {
            height = self.frame.size.height/10
            majorHeight = height
        }
        let itemView = CView(frame:CGRect(x:0, y:y, width:self.frame.size.width, height:height), id:id)
        self.addSubview(itemView)
        let majorLabel:CLabel = CLabel(frame:CGRect(x:View.margin, y:0, width:itemView.frame.size.width-View.margin, height:majorHeight), id:id+"-major-label")
        majorLabel.text = major
        majorLabel.update(fontSize:30.0)
        itemView.addSubview(majorLabel)
        if minor != "" {
            let minorLabel:CTextView = CTextView(frame:CGRect(x:View.margin, y:majorHeight-overlap, width:itemView.frame.size.width-View.margin, height:height-majorHeight-overlap), id:id+"-minor-label")
            minorLabel.text = minor
            minorLabel.isUserInteractionEnabled = false
            itemView.addSubview(minorLabel)
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
        var color:UIColor = Colors.lightGray
        let width:CGFloat = self.frame.size.width*(2/3)
        var x:CGFloat = 0.0
        if side == .right {
            x = self.frame.size.width-width
            color = Colors.dustyOscarSupreme
        }
        var y:CGFloat = top
        if itemViews.count > 0 {
            y = itemViews.last!.frame.origin.y+itemViews.last!.frame.size.height
        }
        let textView = CTextView(frame:CGRect(origin:.zero, size:CGSize(width:width, height:0)), id:id+"-text-view")
        textView.text = text
        textView.sizeToFit()
        textView.isScrollEnabled = false
        let itemView = CView(frame:CGRect(x:x, y:y, width:width, height:textView.frame.size.height), id:id)
        itemView.backgroundColor = color
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
    
    init() {
        self.id = ""
        super.init(frame:.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = ""
        super.init(coder:aDecoder)
    }

}
