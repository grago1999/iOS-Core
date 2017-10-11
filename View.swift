//
//  View.swift
//  Core
//
//  Created by Gianluca Rago on 8/12/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit

class View {
    
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    struct status {
        static let width = UIApplication.shared.statusBarFrame.width
        static let height = UIApplication.shared.statusBarFrame.height
    }
    
    static let margin:CGFloat = width > 320.0 ? 12.0 : 8.0
    static let space:CGFloat = margin*3
    
    struct Shadow {
        static let size:CGSize = CGSize(width:0.0, height:2.0)
        static let opacity:Float = 0.4
    }
    
    struct Animation {
        static let duration:Double = 0.25
    }
    
    struct RoundButton {
        static let size:CGSize = CGSize(width:45.0, height:45.0)
        static let cornerRadius:CGFloat = 5.0
        static let borderWidth:CGFloat = 2.0
    }
    
    struct GeneralButton {
        static let size:CGSize = CGSize(width:280.0, height:50.0)
        static let cornerRadius:CGFloat = 5.0
        static let borderWidth:CGFloat = 2.0
    }
    
    struct SmallButton {
        static let size:CGSize = CGSize(width:120.0, height:32.0)
        static let cornerRadius:CGFloat = 5.0
        static let borderWidth:CGFloat = 2.0
    }
    
    struct LongButton {
        static let size:CGSize = CGSize(width:width-(margin*2), height:GeneralButton.size.height)
        static let cornerRadius:CGFloat = 5.0
        static let borderWidth:CGFloat = 2.0
    }
    
    struct Nav {
        static let size:CGSize = CGSize(width:width, height:60.0)
    }
    
    struct GeneralField {
        static let size:CGSize = CGSize(width:280.0, height:50.0)
        static let cornerRadius:CGFloat = 5.0
        static let borderWidth:CGFloat = 2.0
    }
    
    struct LongField {
        static let size:CGSize = CGSize(width:width-(margin*2), height:GeneralField.size.height)
        static let cornerRadius:CGFloat = 5.0
        static let borderWidth:CGFloat = 2.0
    }
    
    struct SmallField {
        static let size:CGSize = CGSize(width:120.0, height:25.0)
        static let cornerRadius:CGFloat = 5.0
        static let borderWidth:CGFloat = 2.0
    }
    
    struct Notification {
        static let size:CGSize = CGSize(width:width, height:60.0)
        static let indicatorSize:CGSize = CGSize(width:14.0, height:14.0)
    }
    
    static var loadingView:SView?
    
    static func showLoadingView(toView:UIView) {
        let duration:Double = Animation.duration*4
        let radius:CGFloat = 35.0
        Common.isLoading = true
        loadingView = SView(frame:CGRect(x:0, y:0, width:toView.frame.size.width, height:toView.frame.size.height), id:"loading-view")
        loadingView!.backgroundColor = Colors.gray
        loadingView!.layer.zPosition = 100
        loadingView!.isUserInteractionEnabled = false
        
        let circlePath = UIBezierPath(arcCenter:CGPoint(x:loadingView!.frame.size.width/2.0, y:loadingView!.frame.size.height/2.0), radius:radius, startAngle:0.0, endAngle:CGFloat(.pi*2.0), clockwise:true)
        let reverseCirclePath = UIBezierPath(arcCenter:CGPoint(x:loadingView!.frame.size.width/2.0, y:loadingView!.frame.size.height/2.0), radius:radius, startAngle:0.0, endAngle:CGFloat(.pi*2.0), clockwise:false)
        
        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = Colors.white.cgColor
        circleLayer.lineWidth = 10.0
        circleLayer.strokeEnd = 0.0
        loadingView!.layer.addSublayer(circleLayer)
        
        func animate() {
            circleLayer.path = circlePath.cgPath
            let animation = CABasicAnimation(keyPath:"strokeEnd")
            animation.duration = duration
            animation.fromValue = 0
            animation.toValue = 1
            animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            circleLayer.strokeEnd = 1.0
            circleLayer.add(animation, forKey:"circleAnim")
            
            Common.attemptLater(fromNow:duration, attempt: {
                circleLayer.path = reverseCirclePath.cgPath
                let reverseAnim = CABasicAnimation(keyPath:"strokeEnd")
                reverseAnim.duration = duration
                reverseAnim.fromValue = 1
                reverseAnim.toValue = 0
                reverseAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
                circleLayer.strokeEnd = 0
                circleLayer.add(reverseAnim, forKey:"reverseCircleAnim")
                
                Common.attemptLater(fromNow:duration, attempt: {
                    animate()
                })
            })
        }
        animate()
        
        toView.addSubview(loadingView!)
    }

}
