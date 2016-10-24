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
import CoreData
import Alamofire
import Firebase
import FirebaseDatabase


let storeName = "Onion Apps"
let minimumReceipt = "10€"
var managerPin = UserDefaults.standard.value(forKey: "managerPin")
let branches:[String] = ["28 Jupiter St. Bel-Air, Makati City, Philippines", "ELJCC Bldg. Mother Ignacia Ave., South Triangle 4, Quezon City, Philippines", "C-403 Central Precint, Filinvest Ave, Alabang, Muntinlupa City, Philippines", "The Fort Strip, Fort Bonifacio, Taguig City, Philippines", "11 Aguirre Avenue, BF Homes, Paranaque City, Philippines"]
let contacts:[String] = ["028961989", "024319360", "027711706", "027711706", "027711706"]
let storeHours:[String] = ["Mon-Fri: 10AM-10PM Sat/Sun: 9AM-11PM", "Mon-Fri: 10AM-10PM Sat/Sun: 9AM-11PM", "Mon-Fri: 10AM-10PM Sat/Sun: 9AM-11PM", "Mon-Fri: 10AM-10PM Sat/Sun: 9AM-11PM", "Mon-Fri: 10AM-10PM Sat/Sun: 9AM-11PM"]

var freeItems = [String]()

let radiusOfInterest: Double = 150.0

let listView: Bool = false

let defaultFree = "Free coffee"
let distanceToClaim: Int = 9000000

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


var imgURL: URL!

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
let CFSpaceId = "cvjq6nv76z9n"
//let client = Clent(spaceIdentifier: CFId, accessToken: CFTokenProduction)

open class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
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

func showErrorAlert(_ title: String, msg: String, VC: UIViewController) {
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    
    VC.present(alert, animated: true, completion: nil)
    
}

func backgroundThread(_ delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
    DispatchQueue.global(qos: .background).async  {
        if(background != nil){ background!(); }
        
        let popTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            if(completion != nil){ completion!(); }
        }
    }
}

func downloadImage(_ URL: Foundation.URL, completionHandler : @escaping ((_ isResponse : (UIImage, String)) -> Void)) {
    
    
    
        var imgData: UIImage!
        let myGroupImg = DispatchGroup()
        
        
        if let urlLink = URL as Foundation.URL? {
            
            myGroupImg.enter()
            
          
            
            
            Alamofire.request(urlLink).validate(contentType: ["image/*"]).responseData(completionHandler: { (response) in
                
                switch response.result{
                case .success:
                    imgData = UIImage(data: response.data!)!
                    break
                case .failure:
                    imgData = UIImage()
                    break
                }
                myGroupImg.leave()
            })
    
            
            myGroupImg.notify(queue: DispatchQueue.main, execute: {
                
                
                completionHandler((imgData, "\(URL)"))
                
            })
        }
 
    
}

func deleteCoreData(_ entity: String) {
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let context = appDel.managedObjectContext
    let coord = appDel.persistentStoreCoordinator
    
    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "\(entity)")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
        try coord.execute(deleteRequest, with: context)
        print("Deleted: \(entity)")
    } catch let error as NSError {
        debugPrint(error)
    }
}

func deleteCoreDataNil(_ entity: String) {
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let context = appDel.managedObjectContext
    let coord = appDel.persistentStoreCoordinator
    
    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "\(entity)")
    fetchRequest.predicate = NSPredicate(format: "id == %@", "")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
        try coord.execute(deleteRequest, with: context)
    } catch let error as NSError {
        debugPrint(error)
    }
}

func randomStringWithLength (_ len : Int) -> NSString {
    
    let letters : NSString = "0123456789"
    
    let randomString : NSMutableString = NSMutableString(capacity: len)
    
    for _ in 0 ..< len{
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.character(at: Int(rand)))
    }
    
    return randomString
}

func downloadFreeItems(_ completion: @escaping (_ result: Bool) -> Void){
    var index = 0
    
    DataService.ds.REF_STAMPITEMS.observeSingleEvent(of: .value, with: { (
        snapshot) in
        freeItems.removeAll()
        if snapshot.exists() {
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    
                    if let val = snap.value as? String {
                        freeItems.append(val)
                        index += 1
                        if index == freeItemMax {
                            completion(true)
                        }
                    }
                   
                }
            }
        }
    })
   
}



let currentDate = Date()
let dateFormatter = DateFormatter()


