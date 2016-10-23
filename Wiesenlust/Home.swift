//
//  ViewController.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 01/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftSpinner
import Firebase
import FirebaseDatabase
import CoreLocation





class Home: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet var backgroundView: UIView!    
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var menuItem1: UIButton!
    
    @IBOutlet weak var menuItem2: UIButton!
    
    @IBOutlet weak var menuItem3: UIButton!
    
    @IBOutlet weak var menuItem4: UIButton!
    
    @IBOutlet weak var menuItem5: UIButton!
    
    @IBOutlet weak var menuItem6: UIButton!

    @IBOutlet weak var menuLbl1: UILabel!
    
    @IBOutlet weak var menuLbl2: UILabel!
    
    @IBOutlet weak var menuLbl3: UILabel!
    
    @IBOutlet weak var menuLbl4: UILabel!
    
    @IBOutlet weak var menuLbl5: UILabel!
    
    @IBOutlet weak var menuLbl6: UILabel!
    
    @IBOutlet weak var socialButton: UIButton!
    
    var firstload = true
    let locationManager = CLLocationManager()
    var nameTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
  

        
        homeSetup()
        
        navigationController?.isNavigationBarHidden = true
        
        backgroundImg.image = UIImage(named: "bg")
        backgroundView.backgroundColor = UIColor.white
        backgroundImg.alpha = 0.25
        
        socialButton.backgroundColor = UIColor.clear
        socialButton.layer.cornerRadius = 5
        socialButton.layer.borderWidth = 1
        socialButton.layer.borderColor = COLOR1.cgColor
        socialButton.setTitle(socialButtonTitle, for: UIControlState())
        socialButton.setTitleColor(COLOR2, for: UIControlState())
        socialButton.titleLabel?.font = UIFont(name: font1Regular, size: 18)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    
    func homeSetup(){
        var image = menuIcon1!
        let targetWidth : CGFloat = 92
        let targetHeight : CGFloat = 92
        var scaledImage = image
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: targetWidth, height: targetHeight),false,0)
        image.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        menuItem1.setImage(scaledImage.withRenderingMode(.alwaysTemplate), for: UIControlState())
        
        
        image = menuIcon2!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: targetWidth, height: targetHeight),false,0)
        image.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        menuItem2.setImage(scaledImage.withRenderingMode(.alwaysTemplate), for: UIControlState())
        
        
        image = menuIcon3!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: targetWidth, height: targetHeight),false,0)
        image.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        menuItem3.setImage(scaledImage.withRenderingMode(.alwaysTemplate), for: UIControlState())
        
        image = menuIcon4!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: targetWidth, height: targetHeight),false,0)
        image.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        menuItem4.setImage(scaledImage.withRenderingMode(.alwaysTemplate), for: UIControlState())
        
        image = menuIcon5!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: targetWidth, height: targetHeight),false,0)
        image.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        menuItem5.setImage(scaledImage.withRenderingMode(.alwaysTemplate), for: UIControlState())
        
        image = menuIcon6!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: targetWidth, height: targetHeight),false,0)
        image.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        menuItem6.setImage(scaledImage.withRenderingMode(.alwaysTemplate), for: UIControlState())
        
        
        menuItem1.tintColor = COLOR1
        menuItem2.tintColor = COLOR1
        menuItem3.tintColor = COLOR1
        menuItem4.tintColor = COLOR1
        menuItem5.tintColor = COLOR1
        menuItem6.tintColor = COLOR1
        
        
        menuLbl1.text = menuLblText1
        menuLbl2.text = menuLblText2
        menuLbl3.text = menuLblText3
        menuLbl4.text = menuLblText4
        menuLbl5.text = menuLblText5
        menuLbl6.text = menuLblText6
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        downloadManagerPin()
        fetchDataCat { (result) in
            if result {
                self.fetchDataFood({ (result) in
                    if result {
                        self.fetchDataAnn({ (result) in
                            if result {
                                if (foodItemsData.count == 0 || categoriesData.count == 0 ) && self.firstload{
                                    
                                    SwiftSpinner.show(LoadingMsgGlobal)
                                    self.firstload = false
                                }
                                
                                if !checkConnectivity() {
                                    SwiftSpinner.hide()
                                    showErrorAlert("Network Error", msg: "Please check your internet connection.", VC: self)
                                }
                                self.downloadCategories()
                            }
                            
                        })
                        
                    }
                })
            }
        }

     

    }
    
    
    func setupLocationNotifications(){
        UIApplication.shared.cancelAllLocalNotifications()
         //Check if location is set to enabled always
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showErrorAlert("Location Services Disabled", msg: "Please enable location services for Onion Apps in your device settings.", VC: self)
        } else {
            print("Location Auth Confirmed: Always")
        }
        
        //setup geofences to monitor
        
        for loc in branches {
            
            let geoCoder = CLGeocoder()
            
            geoCoder.geocodeAddressString(loc, completionHandler: { (placemarks, error) in
        
                if let placeMark = placemarks?[0] {
                    
                    if let long = placeMark.location?.coordinate.longitude, let lat = placeMark.location?.coordinate.latitude   {
                        
                        
                        if let name = placeMark.thoroughfare as String? {
                            self.nameTitle = name
                        } else if let name = placeMark.subLocality as String? {
                            self.nameTitle = name
                        }
                        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude:
                            lat, longitude: long), radius: radiusOfInterest, identifier: self.nameTitle)
                        region.notifyOnEntry = true
                        region.notifyOnExit = false
                        print("Name:\(self.nameTitle) Long:\(long) Lat:\(lat)")
                        
                        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                            showErrorAlert("Location Services Disabled", msg: "Geo-location is not supported on this device.", VC: self)
                        } else {
                            self.locationManager.startMonitoring(for: region)
                            //print("Region monitoring started for \(self.nameTitle)")
                        }
                        
                        
                    }
                    
                }
                
            })
        }

        let settings = UIUserNotificationSettings(types: .alert, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        
        
        
    }
    

    @IBAction func socialBtnPressed(_ sender: AnyObject) {
        if let appURL = URL(string: socialURLApp) {
            let canOpen = UIApplication.shared.canOpenURL(appURL)
            
            if canOpen {
                UIApplication.shared.openURL(URL(string: socialURLApp)!)
            } else {
                UIApplication.shared.openURL(URL(string: socialURLWeb)!)
            }
        }
    }
   

    
    func clearCoreDataFoodMenu() {
        deleteCoreData("Category")
        deleteCoreData("FoodItem")
    }
    func clearCoreDataFoodMenuExCat() {

        deleteCoreData("FoodItem")
    }
    
    func downloadManagerPin() {
        var mPin: String = ""
        
        
        Alamofire.request("https://cdn.contentful.com/spaces/\(CFSpaceId)/entries?select=fields&access_token=\(CFTokenProduction)&content_type=security").responseJSON { (result) in
            
            if let data = result.result.value as? Dictionary<String, AnyObject>, let items = data["items"] as? [Dictionary<String, AnyObject>], let fields = items[0]["fields"] as? Dictionary<String, AnyObject>, let pinManager = fields["pin"] as? String{
                    mPin = pinManager
                    UserDefaults.standard.setValue(mPin, forKey: "managerPin")
                    print("Manager PIN: \(managerPin!)")
            
            }
            
        }
 

    }
    
    func clearDataAll() {
        categoriesData.removeAll()
        foodItemsData.removeAll()
        clearCoreDataFoodMenu()
        print("Cleared core data.")
    }
    
    func clearDataExCat() {
        
        foodItemsData.removeAll()
        clearCoreDataFoodMenuExCat()
        print("Cleared core data Ex Cat.")
    }
    
    func clearDataAnn() {
        
        announcementsData.removeAll()
        deleteCoreData("Announcements")
        print("Cleared core data Announcements.")
    }
    
  func downloadCategories() {
        DataService.ds.logInAnonymously { (result) in
        }
    
    var changes: Int = 0
    
        deleteCoreDataNil("Category")
        deleteCoreDataNil("FoodItem")
        deleteCoreDataNil("Announcements")
        
        let myGroupCat = DispatchGroup()
        let myGroupCat2 = DispatchGroup()
        
         //CONTENTFULTHING
    
    Alamofire.request("https://cdn.contentful.com/spaces/\(CFSpaceId)/entries?select=fields&access_token=\(CFTokenProduction)&content_type=category").responseJSON { (result) in
        
        if let dataResult = result.result.value as? Dictionary<String, AnyObject>{
            
            if let items = dataResult["items"] as? [Dictionary<String, AnyObject>]{
                
                categories.removeAll()
                let data = items
                if data.count < categoriesData.count {
                    print("Data: \(data.count) DataFromCore:\(categoriesData.count)")
                    self.clearDataAll()
                    
                }
                
                if categoriesData.count > 0 {
                    print("Checking for data changes...")
                    //IF DATA IS EXISTING, CHECK IF THERE ARE CHANGES. IF YES, REDOWNLOAD EVERYTHING. Else, do nothing.
                    for entry in data{
                        
                        if let fields = entry["fields"] as? Dictionary<String, AnyObject>{
                            
                            if let dataURL = fields["image"] as? Dictionary<String, AnyObject>,let sysItem = dataURL["sys"] as? Dictionary<String, AnyObject>, let id = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let assets = includes["Asset"] as? [Dictionary<String, AnyObject>]{
                                
                                for asset in assets{
                                    if let sys = asset["sys"] as? Dictionary<String, AnyObject>, let idRef = sys["id"] as? String, idRef == id{
                                        if let fieldAss = asset["fields"] as? Dictionary<String, AnyObject>, let file = fieldAss["file"] as? Dictionary<String, AnyObject>, let imageURL = file["url"] as? String{
                                            imgURL = URL(string: "https:\(imageURL)")
                                            print("Checking: \(fields["categoryName"]!)")
                                            
                                            for item in categoriesData {
                                                
                                                
                                                print("with...\(item.value(forKey: "name")!)")
                                                if let _ = item.value(forKey: "id") , "\(item.value(forKey: "id")!)" == "\(idRef)" {
                                                    
                                                    
                                                    if let _ = item.value(forKey: "name"), let _ = item.value(forKey: "imageURL"), let _ = imgURL, let _ = item.value(forKey: "order"), let _ = fields["order"] , "\(item.value(forKey: "imageURL")!)" != "\(imgURL!)" ||
                                                        "\(item.value(forKey: "order")!)" != "\(fields["order"]!)" || "\(item.value(forKey: "name")!)" != "\(fields["categoryName"]!)" {
                                                      
    
                                                        print("Did detect change in CATEGORIES: \(item.value(forKey: "name")!)")
                                                        changes += 1
                                                        
                                                    }
                                                }
                                                
                                            }

                                        }else {
                                            print("Checking NoImage: \(fields["categoryName"]!)")
                                            
                                            for item in categoriesData {
                                                
                                                
                                                print("with...\(item.value(forKey: "name")!)")
                                                if let _ = item.value(forKey: "id") , "\(item.value(forKey: "id")!)" == "\(idRef)" {
                                                    
                                                    
                                                    if let _ = item.value(forKey: "name"), let _ = item.value(forKey: "order"), let _ = fields["order"] ,
                                                        "\(item.value(forKey: "order")!)" != "\(fields["order"]!)" || "\(item.value(forKey: "name")!)" != "\(fields["categoryName"]!)" {
                                                        
                                                        print("Did detect change in CATEGORIES: \(item.value(forKey: "name")!)")
                                                        changes += 1
                                                        
                                                    }
                                                }
                                                
                                            }
                                            
                                        }
                                    }
                                }
                            }
                            
  
                        }
                        
                        
                    }
            
                    if changes > 0 {
                        self.clearDataAll()
                        changes = 0
                        SwiftSpinner.show(LoadingMsgGlobal)
                        //DOWNLOAD FRESH
                        print("Downloading fresh data...")
                        if categoriesData.count == 0 {
                            for entry in data{
                                myGroupCat2.enter()
                                if let fields = entry["fields"] as? Dictionary<String, AnyObject>{
   
                                  if let dataURL = fields["image"] as? Dictionary<String, AnyObject>,let sysItem = dataURL["sys"] as? Dictionary<String, AnyObject>, let id = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let assets = includes["Asset"] as? [Dictionary<String, AnyObject>]{
                                        
                                        for asset in assets{
                                            if let sys = asset["sys"] as? Dictionary<String, AnyObject>, let idRef = sys["id"] as? String, idRef == id{
                                                if let fieldAss = asset["fields"] as? Dictionary<String, AnyObject>, let file = fieldAss["file"] as? Dictionary<String, AnyObject>, let imageURL = file["url"] as? String{
                                                    imgURL = URL(string: "https:\(imageURL)")
                                                    
                                                    //If zero data yet saved in client
                                                    downloadImage(imgURL, completionHandler: { (isResponse) in
                                                        print(idRef)
                                                        categories.append(Category(id: "\(idRef)", name: "\(fields["categoryName"]!)", order: Int("\(fields["order"]!)")!, image: isResponse.0, imgURL: "\(isResponse.1)"))
                                                        myGroupCat2.leave()
                                                    })
                                                }else{
                                                    //If no image is uploaded for this item, user default or blank
                                                    categories.append(Category(id: "\(id)", name: "\(fields["categoryName"]!)", order: Int("\(fields["order"]!)")!, image: UIImage(), imgURL: ""))
                                                    myGroupCat2.leave()
                                                }
                                            }
                                        }
                                        
                                        
                                    }

                                }
                                
                            }
                            
                            myGroupCat2.notify(queue: DispatchQueue.main, execute: {
                                
                                print("Download complete.")
                                
                                categories.sort(by: { $0.order < $1.order })
                                
                                for cat in categories {
                                    
                                    self.saveCategory(cat)
                                }
                                self.downloadFoodItems()
                                
                            })
                        }
                        
                    }else {
                        self.downloadFoodItems()
                        print("No changes in CATEGORIES detected.")
                    }
                    
                }else {
                    //DOWNLOAD FRESH
                    SwiftSpinner.show(LoadingMsgGlobal)
                    print("Downloading fresh data...")
                    if categoriesData.count == 0 {
                        for entry in data{
                            myGroupCat2.enter()
                            if let fields = entry["fields"] as? Dictionary<String, AnyObject>{
                                
                                if let dataURL = fields["image"] as? Dictionary<String, AnyObject>,let sysItem = dataURL["sys"] as? Dictionary<String, AnyObject>, let id = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let assets = includes["Asset"] as? [Dictionary<String, AnyObject>]{
                                    
                                    for asset in assets{
                                        if let sys = asset["sys"] as? Dictionary<String, AnyObject>, let idRef = sys["id"] as? String, idRef == id{
                                            if let fieldAss = asset["fields"] as? Dictionary<String, AnyObject>, let file = fieldAss["file"] as? Dictionary<String, AnyObject>, let imageURL = file["url"] as? String{
                                                imgURL = URL(string: "https:\(imageURL)")
                                                
                                                //If zero data yet saved in client
                                                downloadImage(imgURL, completionHandler: { (isResponse) in
                                                    print(idRef)
                                                    categories.append(Category(id: "\(idRef)", name: "\(fields["categoryName"]!)", order: Int("\(fields["order"]!)")!, image: isResponse.0, imgURL: "\(isResponse.1)"))
                                                    myGroupCat2.leave()
                                                })
                                            }else{
                                                //If no image is uploaded for this item, user default or blank
                                                categories.append(Category(id: "\(id)", name: "\(fields["categoryName"]!)", order: Int("\(fields["order"]!)")!, image: UIImage(), imgURL: ""))
                                                myGroupCat2.leave()
                                            }
                                        }
                                    }
                                    
                                    
                                }
                                
                            }
                            
                        }
                        
                        myGroupCat2.notify(queue: DispatchQueue.main, execute: {
                            
                            print("Download complete. Category count: \(categories.count)")
                            
                            categories.sort(by: { $0.order < $1.order })
                            
                            for cat in categories {
                                
                                self.saveCategory(cat)
                            }
                            self.downloadFoodItems()
                           
                        })
                    }

                }
              
        }
    
    }
    }
  }
    func downloadFoodItems() {
        
        var categoryFood: String!
        let myGroupFood = DispatchGroup()
        let myGroupFood2 = DispatchGroup()
        var likes: Int = 0
        var changes: Int = 0
//        
//        client.fetchEntries(["content_type": "menuItem"]).1.next {
//            
//            foodItems.removeAll()
//            let data = $0.items
//            if data.count < foodItemsData.count {
//                print("Data \(data.count) DataLocal: \(foodItemsData.count)")
//                categoriesData.removeAll()
//                foodItemsData.removeAll()
//                self.clearCoreDataFoodMenu()
//                print("Cleared core data.")
//            }
//            if foodItemsData.count > 0 {
//                print("Checking for data changes...")
//                for entry in data{
//                    dispatch_group_enter(myGroupFood)
//                    //setup likes
//                    DataService.ds.REF_LIKES.child("\(entry.identifier)").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
//                        
//                        if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                            if snapshot.value is NSNull {
//                                likes = 0
//                                DataService.ds.REF_LIKES.child("\(entry.identifier)").setValue(["likes": 0], withCompletionBlock: { (error, FIRDatabaseReference) in
//                                })
//                            }
//                            
//                            //download data
//                            if let dataURL = entry.fields["image"] as? Asset{
//                                
//                                do {
//                                    imgURL = try dataURL.URL()
//                                    //CHECKING FOR UPDATES FROM SERVER, SKIP IF STILL UPDATED
//                                    
//                                    print("Checking: \(entry.fields["itemName"]!)")
//                                    for item in foodItemsData {
//                                        
//                                        if let cat = entry.fields["category"] as? Entry {
//                                            categoryFood = cat.fields["categoryName"] as! String
//                                        }
//                                        print("with...\(item.valueForKey("name")!)")
//                                        if let _ = item.valueForKey("id") , "\(item.valueForKey("id")!)" == "\(entry.identifier)" {
//                                            
//                                            
//                                            if let _ = item.valueForKey("imageURL") as? String, let _ = imgURL, let _ = item.valueForKey("price"), let _ = entry.fields["price"] , "\(item.valueForKey("imageURL")!)" != "\(imgURL)" ||
//                                                "\(item.valueForKey("price")!)" != "\(entry.fields["price"]!)" ||
//                                                "\(item.valueForKey("descriptionInfo")!)" != "\(entry.fields["itemDescription"]!)" ||
//                                                "\(item.valueForKey("category")!)" != "\(categoryFood)" || "\(item.valueForKey("name")!)" != "\(entry.fields["itemName"]!)" {
//                                                
//                                                print("Did detect change in FOOD ITEM: \(item.valueForKey("name")!)")
//                                                changes += 1
//                                            }
//                                        }
//                                        
//                                    }
//                                    dispatch_group_leave(myGroupFood)
//                                    
//                                } catch {
//                                    dispatch_group_leave(myGroupFood)
//                                }
//                                
//                            }else {
//                                print("Checking NoImage: \(entry.fields["itemName"]!)")
//                                for item in foodItemsData {
//                                    
//                                    if let cat = entry.fields["category"] as? Entry {
//                                        categoryFood = cat.fields["categoryName"] as! String
//                                    }
//                                    if let _ = item.valueForKey("id") , "\(item.valueForKey("id")!)" == "\(entry.identifier)" {
//                                        if let _ = item.valueForKey("price"), let _ = entry.fields["price"] , "\(item.valueForKey("price")!)" != "\(entry.fields["price"]!)" ||
//                                            "\(item.valueForKey("descriptionInfo")!)" != "\(entry.fields["itemDescription"]!)" ||
//                                            "\(item.valueForKey("category")!)" != "\(categoryFood)" || "\(item.valueForKey("name")!)" != "\(entry.fields["itemName"]!)" || (entry.fields["image"] == nil && "\(item.valueForKey("imageURL")!)" != "") {
//                                            
//                                            print("Did detect change in FOOD ITEM: \(item.valueForKey("name")!) \(item.valueForKey("imageURL"))")
//                                            changes += 1
//                                        }
//                                        
//                                    }
//                                    
//                                }
//                                dispatch_group_leave(myGroupFood)
//                            }
//                            
//                        }
//                    })
//                }
//                dispatch_group_notify(myGroupFood, dispatch_get_main_queue(), {
//                    if changes > 0 {
//                        self.clearDataExCat()
//                        changes = 0
//                        print("Downloading fresh data...")
//                        SwiftSpinner.show(LoadingMsgGlobal)
//                        if foodItemsData.count == 0 {
//                            for entry in data{
//                                dispatch_group_enter(myGroupFood2)
//                                if let dataURL = entry.fields["image"] as? Asset{
//                                    do {
//                                        imgURL = try dataURL.URL()
//                                        
//                                        downloadImage(imgURL, completionHandler: { (isResponse) in
//                                            
//                                            if let cat = entry.fields["category"] as? Entry {
//                                                categoryFood = cat.fields["categoryName"] as! String
//                                            }
//                                            
//                                            foodItems.append(FoodItem(id: "\(entry.identifier)", cat: "\(categoryFood)", name: "\(entry.fields["itemName"]!)", desc: "\(entry.fields["itemDescription"]!)" , price: (entry.fields["price"]! as? Double)!, image: isResponse.0, imgURL: "\(isResponse.1)", key: entry.identifier, likes: likes))
//                                            
//                                            dispatch_group_leave(myGroupFood2)
//                                        })
//                                        
//                                        
//                                    } catch {
//                                        
//                                        dispatch_group_leave(myGroupFood2)
//                                    }
//                                    
//                                } else {
//                                    //If no image is uploaded for this item, user default or blank
//                                    if let cat = entry.fields["category"] as? Entry {
//                                        categoryFood = cat.fields["categoryName"] as! String
//                                    }
//                                   
//                                    foodItems.append(FoodItem(id: "\(entry.identifier)", cat: "\(categoryFood)", name: "\(entry.fields["itemName"]!)", desc: "\(entry.fields["itemDescription"]!)" , price: (entry.fields["price"]! as? Double)!, image: nil, imgURL: nil, key: entry.identifier, likes: likes))
//                                    dispatch_group_leave(myGroupFood2)
//                                }
//                                
//                            }
//                        }
//                        dispatch_group_notify(myGroupFood2, dispatch_get_main_queue(), {
//                            
//                            print("Download complete.")
//                            foodItems.sortInPlace({ $0.price < $1.price })
//                            
//                            for food in foodItems {
//                                
//                                self.saveFood(food)
//                            }
//                            
//                            self.downloadAnnouncements()
//                        })
//                    }
//                    else {
//                        self.downloadAnnouncements()
//                        print("No changes in FOOD detected.")
//                    }
//                })
//            } else {
//                print("Downloading fresh data...")
//                SwiftSpinner.show(LoadingMsgGlobal)
//                if foodItemsData.count == 0 {
//                    for entry in data{
//                        dispatch_group_enter(myGroupFood2)
//                        if let dataURL = entry.fields["image"] as? Asset{
//                            do {
//                                imgURL = try dataURL.URL()
//                                
//                                downloadImage(imgURL, completionHandler: { (isResponse) in
//                                    
//                                    if let cat = entry.fields["category"] as? Entry {
//                                        categoryFood = cat.fields["categoryName"] as! String
//                                    }
//                                    
//                                    foodItems.append(FoodItem(id: "\(entry.identifier)", cat: "\(categoryFood)", name: "\(entry.fields["itemName"]!)", desc: "\(entry.fields["itemDescription"]!)" , price: (entry.fields["price"]! as? Double)!, image: isResponse.0, imgURL: "\(isResponse.1)", key: entry.identifier, likes: likes))
//                                    
//                                    dispatch_group_leave(myGroupFood2)
//                                })
//                                
//                                
//                            } catch {
//                                
//                                dispatch_group_leave(myGroupFood2)
//                            }
//                            
//                        } else {
//                            //If no image is uploaded for this item, user default or blank
//                            if let cat = entry.fields["category"] as? Entry {
//                                categoryFood = cat.fields["categoryName"] as! String
//                            }
//                            
//                            foodItems.append(FoodItem(id: "\(entry.identifier)", cat: "\(categoryFood)", name: "\(entry.fields["itemName"]!)", desc: "\(entry.fields["itemDescription"]!)" , price: (entry.fields["price"]! as? Double)!, image: nil, imgURL: nil, key: entry.identifier, likes: likes))
//                            dispatch_group_leave(myGroupFood2)
//                        }
//                        
//                    }
//                }
//                dispatch_group_notify(myGroupFood2, dispatch_get_main_queue(), {
//                    
//                    print("Download complete.")
//                    foodItems.sortInPlace({ $0.price < $1.price })
//                    
//                    for food in foodItems {
//                        
//                        self.saveFood(food)
//                    }
//                    
//                    self.downloadAnnouncements()
//                })
//            }
// 
//        }
//        
        
    }
    
    func downloadAnnouncements() {
        
        var changes: Int = 0
        
        let myGroupCat = DispatchGroup()
        let myGroupCat2 = DispatchGroup()
        
         //CONTENTFULTHING
//       client.fetchEntries(["content_type": "announcements"]).1.next {
//            
//            announcements.removeAll()
//            let data = $0.items
//            if data.count < announcementsData.count {
//                print("Data: \(data.count) DataFromCore:\(announcementsData.count)")
//                self.clearDataAnn()
//                
//            }
//            
//            if announcementsData.count > 0 {
//                print("Checking for data changes in ANNOUNCEMENTS...")
//                //IF DATA IS EXISTING, CHECK IF THERE ARE CHANGES. IF YES, REDOWNLOAD EVERYTHING. Else, do nothing.
//                for entry in data{
//                    dispatch_group_enter(myGroupCat)
//                    if let dataURL = entry.fields["image"] as? Asset{
//                        do {
//                            imgURL = try dataURL.URL()
//                            
//                            print("Checking: \(entry.fields["title"]!)")
//                            
//                            for item in announcementsData {
//                                
//                                
//                                print("with...\(item.valueForKey("title")!)")
//                                if let _ = item.valueForKey("id") , "\(item.valueForKey("id")!)" == "\(entry.identifier)" && "\(item.valueForKey("imageURL")!)" != "\(imgURL)" {
//                                
//                                        
//                                        print("Did detect change in ANNOUNCEMENTS: \(item.valueForKey("title")!)")
//                                        changes += 1
//                                        
//                                    
//                                }
//                                
//                            }
//                            
//                            dispatch_group_leave(myGroupCat)
//                        } catch {
//                            dispatch_group_leave(myGroupCat)
//                        }
//                        
//                    } else {
//                       dispatch_group_leave(myGroupCat)
//                    }
//                    
//                    
//                }
//                
//                dispatch_group_notify(myGroupCat, dispatch_get_main_queue(), {
//                    
//                    if changes > 0 {
//                        self.clearDataAnn()
//                        changes = 0
//                        SwiftSpinner.show(LoadingMsgGlobal)
//                        //DOWNLOAD FRESH
//                        print("Downloading fresh data...")
//                        if categoriesData.count == 0 {
//                            for entry in data{
//                                dispatch_group_enter(myGroupCat2)
//                                if let data = entry.fields["image"] as? Asset{
//                                    do {
//                                        imgURL = try data.URL()
//                                        
//                                        //If zero data yet saved in client
//                                        downloadImage(imgURL, completionHandler: { (isResponse) in
//                                            print(entry.identifier)
//                                            announcements.append(Announcements(id: "\(entry.identifier)", title: "\(entry.fields["title"]!)", image: isResponse.0, imgURL: "\(isResponse.1)"))
//                                            dispatch_group_leave(myGroupCat2)
//                                        })
//                                        
//                                        
//                                    } catch {
//                                        
//                                        dispatch_group_leave(myGroupCat2)
//                                    }
//                                    
//                                } else {
//                                    //If no image is uploaded for this item, user default or blank
//                                    announcements.append(Announcements(id: "\(entry.identifier)", title: "\(entry.fields["title"]!)", image: UIImage(), imgURL: ""))
//                                    dispatch_group_leave(myGroupCat2)
//                                }
//                                
//                            }
//                            
//                            dispatch_group_notify(myGroupCat2, dispatch_get_main_queue(), {
//                                
//                                print("Download complete.")
//                                
//                                for ann in announcements {
//                                    
//                                    self.saveAnnouncement(ann)
//                                }
//                                print("Update Check Complete.")
//                                self.setupLocationNotifications()
//                                SwiftSpinner.hide()
//                            })
//                        }
//                        
//                    }else {
//                        print("No changes in ANNOUNCEMENTS detected.")
//                        print("Update Check Complete.")
//                        self.setupLocationNotifications()
//                        SwiftSpinner.hide()
//                    }
//                })
//            }else {
//                //DOWNLOAD FRESH
//                SwiftSpinner.show(LoadingMsgGlobal)
//                print("Downloading fresh data...")
//                if announcementsData.count == 0 {
//                    for entry in data{
//                        dispatch_group_enter(myGroupCat2)
//                        if let data = entry.fields["image"] as? Asset{
//                            do {
//                                imgURL = try data.URL()
//                                
//                                //If zero data yet saved in client
//                                downloadImage(imgURL, completionHandler: { (isResponse) in
//                                    print(entry.identifier)
//                                    announcements.append(Announcements(id: "\(entry.identifier)", title: "\(entry.fields["title"]!)", image: isResponse.0, imgURL: "\(isResponse.1)"))
//                                    dispatch_group_leave(myGroupCat2)
//                                })
//                                
//                                
//                            } catch {
//                                
//                                dispatch_group_leave(myGroupCat2)
//                            }
//                            
//                        } else {
//                            //If no image is uploaded for this item, user default or blank
//                            announcements.append(Announcements(id: "\(entry.identifier)", title: "\(entry.fields["title"]!)", image: UIImage(), imgURL: ""))
//                            dispatch_group_leave(myGroupCat2)
//                        }
//                        
//                    }
//                    
//                    dispatch_group_notify(myGroupCat2, dispatch_get_main_queue(), {
//                        
//                        print("Download complete.")
//         
//                        for ann in announcements {
//                            self.saveAnnouncement(ann)
//                        }
//                        print("Update Check Complete.")
//                        self.setupLocationNotifications()
//                        SwiftSpinner.hide()
//                    })
//                }
//            }
//            
//            
//        }
//        
        
    }

    
    func saveCategory(_ category: Category) {
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "Category", in:managedContext)
        let categoryTemp = NSManagedObject(entity: entity!, insertInto: managedContext)
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Category")
        
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", category.id)
        do {
            if let fetchResults = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0{
                    
                    fetchResults.first?.setValue(category.id, forKey: "id")
                    fetchResults.first?.setValue(category.name, forKey: "name")
                    fetchResults.first?.setValue(category.order, forKey: "order")
                    fetchResults.first?.setValue(category.img, forKey: "image")
                    fetchResults.first?.setValue(category.imgURL, forKey: "imageURL")
                    
                    do {
                        try fetchResults.first?.managedObjectContext?.save()
                        fetchDataCat({ (result) in
                            if result {
                                 print("Updated: \(category.name) mit order \(category.order) und \(category.imgURL) with id \(category.id) ")
                            }
                        })
                       
                        
                    } catch let error as NSError {
                        print("Could not fetch \(error), \(error.userInfo)")
                    }
                    
                    
                } else {
                    
                    categoryTemp.setValue(category.id, forKey: "id")
                    categoryTemp.setValue(category.name, forKey: "name")
                    categoryTemp.setValue(category.order, forKey: "order")
                    categoryTemp.setValue(category.img, forKey: "image")
                    categoryTemp.setValue(category.imgURL, forKey: "imageURL")
                    
                    do {
                        try managedContext.save()
                        categoriesData.append(categoryTemp)
                        print("Saved: \(category.name) mit order \(category.order) und \(category.imgURL) ")
                        
                    }catch let error as NSError {
                        print("Could not fetch \(error), \(error.userInfo)")
                    }
                }
                
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
    }
    
    func saveFood(_ foodItem: FoodItem) {
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "FoodItem", in:managedContext)
        let categoryTemp = NSManagedObject(entity: entity!, insertInto: managedContext)
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FoodItem")
        
        
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", foodItem.id)
        do {
            if let fetchResults = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0{
                    
                    fetchResults.first?.setValue(foodItem.id, forKey: "id")
                    fetchResults.first?.setValue(foodItem.category, forKey: "category")
                    fetchResults.first?.setValue(foodItem.name, forKey: "name")
                    fetchResults.first?.setValue(foodItem.price, forKey: "price")
                    fetchResults.first?.setValue(foodItem.descriptionInfo, forKey: "descriptionInfo")
                    fetchResults.first?.setValue(foodItem.img, forKey: "image")
                    fetchResults.first?.setValue(foodItem.imgURL, forKey: "imageURL")
                    fetchResults.first?.setValue(foodItem.postRef, forKey: "key")
                    fetchResults.first?.setValue(foodItem.postLikes, forKey: "likes")
                    
                    do {
                        try fetchResults.first?.managedObjectContext?.save()
                        fetchDataCat({ (result) in
                            if result {
                               print("Updated Food: \(foodItem.name) mit preis \(foodItem.price) und \(foodItem.imgURL), \(foodItem.postLikes) ")
                            }
                        })
                        
                        
                    } catch let error as NSError {
                        print("Could not fetch \(error), \(error.userInfo)")
                    }
                    
                    
                } else {
                    
                    categoryTemp.setValue(foodItem.id, forKey: "id")
                    categoryTemp.setValue(foodItem.category, forKey: "category")
                    categoryTemp.setValue(foodItem.name, forKey: "name")
                    categoryTemp.setValue(foodItem.price, forKey: "price")
                    categoryTemp.setValue(foodItem.descriptionInfo, forKey: "descriptionInfo")
                    categoryTemp.setValue(foodItem.img, forKey: "image")
                    categoryTemp.setValue(foodItem.imgURL, forKey: "imageURL")
                    categoryTemp.setValue(foodItem.postRef, forKey: "key")
                    categoryTemp.setValue(foodItem.postLikes, forKey: "likes")
                    
                    do {
                        try managedContext.save()
                        foodItemsData.append(categoryTemp)
                        print("Saved: \(foodItem.name) mit preis \(foodItem.price) und \(foodItem.imgURL), \(foodItem.postLikes)")
                        
                    }catch let error as NSError {
                        print("Could not fetch \(error), \(error.userInfo)")
                    }
                }
                
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
    }
    
    func saveAnnouncement(_ announcement: Announcements) {
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "Announcements", in:managedContext)
        let categoryTemp = NSManagedObject(entity: entity!, insertInto: managedContext)
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Announcements")
        
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", announcement.id)
        do {
            if let fetchResults = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0{
                    
                    fetchResults.first?.setValue(announcement.id, forKey: "id")
                    fetchResults.first?.setValue(announcement.title, forKey: "title")
                    fetchResults.first?.setValue(announcement.img, forKey: "image")
                    fetchResults.first?.setValue(announcement.imgURL, forKey: "imageURL")
                    
                    do {
                        try fetchResults.first?.managedObjectContext?.save()
                        fetchDataAnn({ (result) in
                      
                        })
                        
                        
                    } catch let error as NSError {
                        print("Could not fetch \(error), \(error.userInfo)")
                    }
                    
                    
                } else {
                    
                    categoryTemp.setValue(announcement.id, forKey: "id")
                    categoryTemp.setValue(announcement.title, forKey: "title")
                    categoryTemp.setValue(announcement.img, forKey: "image")
                    categoryTemp.setValue(announcement.imgURL, forKey: "imageURL")
                    
                    do {
                        try managedContext.save()
                        announcementsData.append(categoryTemp)
                        print("Saved \(announcementsData.count) announcements")
                        
                    }catch let error as NSError {
                        print("Could not fetch \(error), \(error.userInfo)")
                    }
                }
                
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
    }


    func fetchDataCat(_ completion: (_ result: Bool) -> Void) {
        categoriesData.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "id != %@", "")
        
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            
            categoriesData = results as! [NSManagedObject]
            if categoriesData.count > 0 {
                print("Category: Local data fetched.")
                completion(true)
            }else{
                print("Category: No data available in local.")
                completion(true)
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    func fetchDataFood(_ completion: (_ result: Bool) -> Void) {
        
        foodItemsData.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
     
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FoodItem")
        fetchRequest.predicate = NSPredicate(format: "id != %@", "")
        
        do {
         
            
            let resultsFood =
                try managedContext.fetch(fetchRequest)
            
            foodItemsData = resultsFood as! [NSManagedObject]
            if foodItemsData.count > 0 {
                print("Food: Local data fetched.")
                completion(true)
            }else{
                print("FoodNo data available in local.")
                completion(true)
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func fetchDataAnn(_ completion: (_ result: Bool) -> Void) {
        announcementsData.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Announcements")
        fetchRequest.predicate = NSPredicate(format: "id != %@", "")
        
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            
            announcementsData = results as! [NSManagedObject]
            if announcementsData.count > 0 {
                print("Announcements: Local data fetched.")
                completion(true)
            }else{
                print("Announcements: No data available in local.")
                completion(true)
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}

