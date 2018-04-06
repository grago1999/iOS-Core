//
//  Colors.swift
//  
//
//  Created by Gianluca Rago on 10/8/17.
//

import UIKit

class Colors {
    
    static let orange:UIColor = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
    static let darkOrange:UIColor = UIColor(red:0.96, green:0.49, blue:0.00, alpha:1.0)
    static let red:UIColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
    static let darkRed:UIColor = UIColor(red:0.83, green:0.18, blue:0.18, alpha:1.0)
    static let green:UIColor = UIColor(red:0.00, green:0.60, blue:0.60, alpha:1.0)
    static let darkGreen:UIColor = UIColor(red:0.00, green:0.42, blue:0.42, alpha:1.0)
    static let blue:UIColor = UIColor(red:0, green:0.5804, blue:1, alpha:1.0)
    static let darkBlue:UIColor = UIColor(red:0, green:0.3882, blue:0.9373, alpha:1.0)
    static let aBlue:UIColor = UIColor(red:78.0/255.0, green:168.0/255.0, blue:211.0/255.0, alpha:1.0)
    static let bBlue:UIColor = UIColor(red:70.0/255.0, green:151.0/255.0, blue:189.0/255.0, alpha:1.0)
    static let cBlue:UIColor = UIColor(red:62.0/255.0, green:134.0/255.0, blue:168.0/255.0, alpha:1.0)
    static let lightGray:UIColor = UIColor(red:56.0/255.0, green:59.0/255.0, blue:64.0/255.0, alpha:1.0)
    static let gray:UIColor = UIColor(red:41.0/255.0, green:44.0/255.0, blue:47.0/255.0, alpha:1.0)
    static let white:UIColor = UIColor(red:255.0/255.0, green:250.0/255.0, blue:250.0/255.0, alpha:1.0)
    static let dustyOscarSupreme:UIColor = UIColor(red:147.0/255.0, green:213.0/255.0, blue:54.0/255.0, alpha:1.0)
    
    static func random(current:UIColor? = nil) -> UIColor {
        var choice:UIColor = .white
        let rand = Int(arc4random_uniform(4))
        if rand == 0 {
            choice = orange
        } else if rand == 1 {
            choice = red
        } else if rand == 2 {
            choice = green
        } else {
            choice = blue
        }
        if current != nil {
            if current!.isEqual(choice) {
                return random(current:current)
            }
            return choice
        }
        return choice
    }
    
}
