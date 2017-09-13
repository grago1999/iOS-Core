//
//  View.swift
//  Location Base
//
//  Created by Gianluca Rago on 8/12/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit

class View {
    
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    static let margin:CGFloat = screenWidth > 320.0 ? 12.0 : 8.0
    static let space:CGFloat = margin*3
    
    struct Shadow {
        static let size:CGSize = CGSize(width:0.0, height:2.0)
        static let opacity:CGFloat = 0.4
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
        static let size:CGSize = CGSize(width:screenWidth-(margin*2), height:GeneralButton.size.height)
        static let cornerRadius:CGFloat = 5.0
        static let borderWidth:CGFloat = 2.0
    }
    
    struct Nav {
        static let size:CGSize = CGSize(width:screenWidth, height:60.0)
    }
    
    struct GeneralField {
        static let size:CGSize = CGSize(width:280.0, height:50.0)
        static let cornerRadius:CGFloat = 5.0
        static let borderWidth:CGFloat = 2.0
    }
    
    struct LongField {
        static let size:CGSize = CGSize(width:screenWidth-(margin*2), height:GeneralField.size.height)
        static let cornerRadius:CGFloat = 5.0
        static let borderWidth:CGFloat = 2.0
    }
    
    struct SmallField {
        static let size:CGSize = CGSize(width:120.0, height:25.0)
        static let cornerRadius:CGFloat = 5.0
        static let borderWidth:CGFloat = 2.0
    }
    
    struct Notification {
        static let size:CGSize = CGSize(width:screenWidth, height:60.0)
        static let indicatorSize:CGSize = CGSize(width:14.0, height:14.0)
    }
    
    static var loadingView:SView?
    
    static func showLoadingView(toView:UIView) {
        let duration:Double = animDuration*4
        let radius:CGFloat = 35.0
        Common.isLoading = true
        loadingView = SView(frame:CGRect(x:0, y:0, width:toView.frame.size.width, height:toView.frame.size.height), id:"loading-view")
        loadingView!.backgroundColor = UIColor.Palette.gray
        loadingView!.layer.zPosition = 100
        loadingView!.isUserInteractionEnabled = false
        
        let circlePath = UIBezierPath(arcCenter:CGPoint(x:loadingView!.frame.size.width/2.0, y:loadingView!.frame.size.height/2.0), radius:radius, startAngle:0.0, endAngle:CGFloat(.pi*2.0), clockwise:true)
        let reverseCirclePath = UIBezierPath(arcCenter:CGPoint(x:loadingView!.frame.size.width/2.0, y:loadingView!.frame.size.height/2.0), radius:radius, startAngle:0.0, endAngle:CGFloat(.pi*2.0), clockwise:false)
        
        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.Palette.white.cgColor
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

extension UIColor {
    
    struct Palette {
        static let orange:UIColor = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
        static let darkOrange:UIColor = UIColor(red:0.96, green:0.49, blue:0.00, alpha:1.0)
        static let red:UIColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        static let darkRed:UIColor = UIColor(red:0.83, green:0.18, blue:0.18, alpha:1.0)
        static let green:UIColor = UIColor(red:0.00, green:0.60, blue:0.60, alpha:1.0)
        static let darkGreen:UIColor = UIColor(red:0.00, green:0.42, blue:0.42, alpha:1.0)
        static let blue:UIColor = UIColor(red:0, green:0.5804, blue:1, alpha:1.0)
        static let darkBlue:UIColor = UIColor(red:0, green:0.3882, blue:0.9373, alpha:1.0)
        static let lightGray:UIColor = UIColor(red:56.0/255.0, green:59.0/255.0, blue:64.0/255.0, alpha:1.0)
        static let gray:UIColor = UIColor(red:41.0/255.0, green:44.0/255.0, blue:47.0/255.0, alpha:1.0)
        static let white:UIColor = UIColor(red:255.0/255.0, green:250.0/255.0, blue:250.0/255.0, alpha:1.0)
    }
    
}

extension UIFont {
    
    struct Main {
        static let general:UIFont = UIFont(name:"Avenir-Heavy", size:20.0)!
        static let title:UIFont = UIFont(name:"Avenir-Heavy", size:28.0)!
        static let small:UIFont = UIFont(name:"Avenir-Heavy", size:12.5)!
    }
    
}
