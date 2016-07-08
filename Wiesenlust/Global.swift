//
//  Global.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 04/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SystemConfiguration
import Contentful

let COLOR1 = UIColor(red: CGFloat(188.0 / 255.0), green: CGFloat(208.0 / 255.0), blue: CGFloat(24.0 / 255.0), alpha: 1.0)
let COLOR2 = UIColor(red: CGFloat(146.0 / 255.0), green: CGFloat(20.0 / 255.0), blue: CGFloat(114.0 / 255.0), alpha: 1.0)
let COLOR2_DARK = UIColor(red: CGFloat(105.0 / 255.0), green: CGFloat(14.0 / 255.0), blue: CGFloat(82.0 / 255.0), alpha: 1.0)
let COLOR_YELLOW = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(255.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: 1.0)

let logo1 = UIImage(named: "logo02.png")
let menuIcon1 = UIImage(named: "menuIcon1.png")
let menuIcon2 = UIImage(named: "menuIcon2.png")
let menuIcon3 = UIImage(named: "menuIcon3.png")
let menuIcon4 = UIImage(named: "menuIcon4.png")
let menuIcon5 = UIImage(named: "menuIcon5.png")
let menuIcon6 = UIImage(named: "menuIcon6.png")

let font1Thin = "HelveticaNeue-Thin"
let font1Medium = "HelveticaNeue-Medium"
let font1Regular = "HelveticaNeue-Regular"
let font1Light = "HelveticaNeue-Light"
let font1UltraLight = "HelveticaNeue-UltraLight"

let menuLblText1 = "Menu"
let menuLblText2 = "Coupons"
let menuLblText3 = "Rewards"
let menuLblText4 = "Reservations"
let menuLblText5 = "Locations"
let menuLblText6 = "Feedback"

let socialURLApp = "yelp4:///biz/wiesenlust-frankfurt-am-main"
let socialURLWeb = "http://yelp.com/biz/wiesenlust-frankfurt-am-main"
let socialButtonTitle = "VISIT US ON YELP!"

let LoadingMsgTapToExit = "Tap anytime to exit"
let LoadingMsgGlobal = "Loading..."

//CONTENTFUL
let CFTokenPreview = "02859c62f9d05747157b7e53486c50c1ccade9161802faa8a5362e4372d1d601"
let CFTokenProduction = "13d7f8a3b6f5a0e0c19b6ea11221332ea16fa23321e653afdd019e0085b77194"
let CFId = "cvjq6nv76z9n"
let client = Client(spaceIdentifier: CFId, accessToken: CFTokenProduction)

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}


func checkConnectivity() -> Bool {
    if Reachability.isConnectedToNetwork() {
        return true
    } else {
        
        return false
    }
}

func showErrorAlert(title: String, msg: String, VC: UIViewController) {
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alert.addAction(action)
    VC.presentViewController(alert, animated: true, completion: nil)
    
}

func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
    dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.rawValue), 0)) {
        if(background != nil){ background!(); }
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue()) {
            if(completion != nil){ completion!(); }
        }
    }
}
