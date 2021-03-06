//
//  Common.swift
//  Game Base
//
//  Created by Gianluca Rago on 2/20/17.
//  Copyright © 2017 Gianluca Rago. All rights reserved.
//

import UIKit
import SwiftyJSON

class Common {
    
    enum LogType:String {
        case debug = "debug"
        case warning = "warning"
        case error = "error"
    }
    
    static let alphabet:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    static let maxChars:Int = 250
    
    static var globalMessages:[GlobalMessage] = []
    
    static let delay:Double = 2.0
    
    static var isLoading:Bool = false
    
    static var words:[String]?
    
    static func hash(str:String) -> String {
        let data = NSData(data:str.data(using:String.Encoding.utf8)!)
        var digest = [UInt8](repeating:0, count:Int(CC_SHA512_DIGEST_LENGTH))
        CC_SHA512(data.bytes, CC_LONG(data.length), &digest)
        let output = NSMutableString(capacity:Int(CC_SHA512_DIGEST_LENGTH))
        for byte in digest {
            output.appendFormat("%02x", byte)
        }
        return output as String
    }
    
    private static func openWordsFile() -> Bool {
        if let file = Bundle.main.path(forResource:"words", ofType:"txt") {
            do {
                let wordStr = try String(contentsOfFile:file)
                words = wordStr.components(separatedBy:.newlines)
                Common.log(prefix:.debug, str:"Opened words.txt")
                return true
            } catch {
                Common.log(prefix:.error, str:error.localizedDescription)
            }
        }
        Common.log(prefix:.error, str:"Could not open words.txt")
        return false
    }
    
    static func randPhrase(length:Int, spaces:Bool) -> String? {
        if let existingWords = words {
            var randomText = ""
            for _ in 0...length {
                randomText += existingWords[numericCast(arc4random_uniform(numericCast(existingWords.count)))]
                if spaces {
                    randomText += " "
                }
            }
            return randomText
        } else {
            return openWordsFile() ? randPhrase(length:length, spaces:spaces) : nil
        }
    }
    
    static func rand(low:Int, high:Int) -> Int {
        return low+Int(arc4random_uniform(UInt32(high-low+1)))
    }
    
    static func rand(low:Double, high:Double) -> Double {
        return Double(arc4random()) / Double(UInt32.max) * abs(low - high) + min(low, high)
    }

    static func rand(num:Int) -> String {
        var str:String = ""
        for _ in 0 ..< num {
            let rand = arc4random_uniform(UInt32(alphabet.characters.count))
            str += String(UnicodeScalar(NSString(string:alphabet).character(at:Int(rand)))!)
        }
        return str
    }
    
    static func deviceStats() -> String {
        let deviceVersion = UIDevice.current.systemName+UIDevice.current.systemVersion
        let isLowPowerModeEnabled:String = ProcessInfo.processInfo.isLowPowerModeEnabled ? "Low Power Mode" : ""
        return "\n\n\n\n\n\nThis is just some information that can help us solve any issues you're having:\n\n"+deviceVersion+"\n"+isLowPowerModeEnabled
    }

    static func reset() {
        for item in iterateEnum(Config.Key.self) {
            Settings.set(value:false, key:item)
        }
    }
    
    // https://stackoverflow.com/questions/24007461/how-to-enumerate-an-enum-with-string-type
    static func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var i = 0
        return AnyIterator {
            let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
            if next.hashValue != i { return nil }
            i += 1
            return next
        }
    }
    
    static func log(prefix:LogType, str:String) {
        if Config.debugLevel == .debug {
            print(prefix.rawValue+": "+str)
        } else if prefix == .warning || prefix == .error {
            print(prefix.rawValue+": "+str)
        }
    }
    
    static func attemptLater(fromNow:Double, attempt: @escaping () -> Void) {
        let when = DispatchTime.now()+fromNow
        DispatchQueue.main.asyncAfter(deadline:when) {
            attempt()
        }
    }
    
}
