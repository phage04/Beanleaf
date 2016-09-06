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
import CoreData
import Alamofire
import Firebase
import FirebaseDatabase


let storeName = "Onion Apps"
let minimumReceipt = "10€"
var managerPin = NSUserDefaults.standardUserDefaults().valueForKey("managerPin")
let branches:[String] = ["28 Jupiter St. Bel-Air, Makati City, Philippines", "ELJCC Bldg. Mother Ignacia Ave., South Triangle 4, Quezon City, Philippines", "C-403 Central Precint, Filinvest Ave, Alabang, Muntinlupa City, Philippines", "The Fort Strip, Fort Bonifacio, Taguig City, Philippines", "11 Aguirre Avenue, BF Homes, Paranaque City, Philippines"]
let contacts:[String] = ["028961989", "024319360", "027711706", "027711706", "027711706"]
let storeHours:[String] = ["Mon-Fri: 10AM-10PM Sat/Sun: 9AM-11PM", "Mon-Fri: 10AM-10PM Sat/Sun: 9AM-11PM", "Mon-Fri: 10AM-10PM Sat/Sun: 9AM-11PM", "Mon-Fri: 10AM-10PM Sat/Sun: 9AM-11PM", "Mon-Fri: 10AM-10PM Sat/Sun: 9AM-11PM"]

var freeItems = [String]()

let radiusOfInterest = 100.0

let defaultFree = "Free coffee"
let distanceToClaim = 300000
let currencyShort = "P"
let currencyLong = "Php"
let freeItemMax = 6

var categoriesData = [NSManagedObject]()
var categories = [Category]()
var announcementsData = [NSManagedObject]()
var announcements = [Announcements]()
var foodItemsData = [NSManagedObject]()
var foodItems = [FoodItem]()
var validForLocationOffer = false


var imgURL: NSURL!

//let COLOR1 = UIColor(red: CGFloat(103.0 / 255.0), green: CGFloat(58.0 / 255.0), blue: CGFloat(183.0 / 255.0), alpha: 1.0)
//let COLOR2 = UIColor(red: CGFloat(24.0 / 255.0), green: CGFloat(188.0 / 255.0), blue: CGFloat(156.0 / 255.0), alpha: 1.0)
//let COLOR2_DARK = UIColor(red: CGFloat(24.0 / 255.0), green: CGFloat(188.0 / 255.0), blue: CGFloat(156.0 / 255.0), alpha: 1.0)
//let COLOR_YELLOW = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(255.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: 1.0)
//WIESEN
let COLOR1 = UIColor(red: CGFloat(24.0 / 255.0), green: CGFloat(188.0 / 255.0), blue: CGFloat(156.0 / 255.0), alpha: 1.0)
let COLOR2 = UIColor(red: CGFloat(103.0 / 255.0), green: CGFloat(58.0 / 255.0), blue: CGFloat(183.0 / 255.0), alpha: 1.0)
let COLOR2_DARK = UIColor(red: CGFloat(78.0 / 255.0), green: CGFloat(31.0 / 255.0), blue: CGFloat(160.0 / 255.0), alpha: 1.0)
let COLOR_YELLOW = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(255.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: 1.0)

let SHADOW_COLOR: CGFloat = 30.0 / 255.0

let logo1 = UIImage(named: "logo02.png")
let stampIcon = UIImage(named: "stamp")
let phoneIcon = UIImage(named: "phone")
let menuIcon1 = UIImage(named: "menuIcon1.png")
let menuIcon2 = UIImage(named: "menuIcon2.png")
let menuIcon3 = UIImage(named: "menuIcon3.png")
let menuIcon4 = UIImage(named: "menuIcon4.png")
let menuIcon5 = UIImage(named: "menuIcon5.png")
let menuIcon6 = UIImage(named: "menuIcon6.png")


let font1Thin = "HelveticaNeue-Thin"
let font1Medium = "HelveticaNeue-Medium"
let font1Regular = "HelveticaNeue"
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
let socialButtonTitle = "WRITE US A REVIEW"

let LoadingMsgTapToExit = "Tap anytime to exit"
let LoadingMsgGlobal = "Downloading updates..."


let DATE_FULL_FORMAT = "yyyy-MM-dd HH:mm:ss Z"
let DATE_FORMAT1 = "MMM dd, yyyy"
let DATE_FORMAT2 = "MMMM dd, yyyy (EEE) h:mma"

//MAILGUN
let mailGunKey = "key-5b34852ee5f4c8467b150056b0b5ca1e"
let mailGunURL = "onionapps.com"
let mailGunOwnerEmail = "jover.lyle@gmail.com"

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

func downloadImage(URL: NSURL, completionHandler : ((isResponse : (UIImage, String)) -> Void)) {
    
    
    
        var imgData: UIImage!
        let myGroupImg = dispatch_group_create()
        
        
        if let urlLink = URL as NSURL? {
            
            dispatch_group_enter(myGroupImg)
            Alamofire.request(.GET, urlLink).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                
                if err == nil {
                    imgData = UIImage(data: data!)!
                    
                } else {
                    imgData = UIImage()
                }
                dispatch_group_leave(myGroupImg)
                
            })
            
            dispatch_group_notify(myGroupImg, dispatch_get_main_queue(), {
                
                
                completionHandler(isResponse : (imgData, "\(URL)"))
                
            })
        }
 
    
}

func deleteCoreData(entity: String) {
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    let context = appDel.managedObjectContext
    let coord = appDel.persistentStoreCoordinator
    
    let fetchRequest = NSFetchRequest(entityName: entity)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
        try coord.executeRequest(deleteRequest, withContext: context)
        print("Deleted: \(entity)")
    } catch let error as NSError {
        debugPrint(error)
    }
}

func deleteCoreDataNil(entity: String) {
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    let context = appDel.managedObjectContext
    let coord = appDel.persistentStoreCoordinator
    
    let fetchRequest = NSFetchRequest(entityName: entity)
    fetchRequest.predicate = NSPredicate(format: "id == %@", "")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
        try coord.executeRequest(deleteRequest, withContext: context)
    } catch let error as NSError {
        debugPrint(error)
    }
}

func randomStringWithLength (len : Int) -> NSString {
    
    let letters : NSString = "0123456789"
    
    var randomString : NSMutableString = NSMutableString(capacity: len)
    
    for (var i=0; i < len; i += 1){
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
    }
    
    return randomString
}

func downloadFreeItems(completion: (result: Bool) -> Void){
    var index = 0
    
    DataService.ds.REF_STAMPITEMS.observeSingleEventOfType(.Value, withBlock: { (
        snapshot) in
        freeItems.removeAll()
        if snapshot.exists() {
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    
                    if let val = snap.value as? String {
                        freeItems.append(val)
                        index += 1
                        if index == freeItemMax {
                            completion(result: true)
                        }
                    }
                   
                }
            }
        }
    })
   
}



let currentDate = NSDate()
let dateFormatter = NSDateFormatter()



