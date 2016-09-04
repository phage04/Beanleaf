//
//  ViewController.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 01/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit
import CoreData
import Contentful
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
        
        navigationController?.navigationBarHidden = true
        
        backgroundImg.image = UIImage(named: "bg")
        backgroundView.backgroundColor = UIColor.whiteColor()
        backgroundImg.alpha = 0.25
        
        socialButton.backgroundColor = UIColor.clearColor()
        socialButton.layer.cornerRadius = 5
        socialButton.layer.borderWidth = 1
        socialButton.layer.borderColor = COLOR1.CGColor
        socialButton.setTitle(socialButtonTitle, forState: .Normal)
        socialButton.setTitleColor(COLOR2, forState: .Normal)
        socialButton.titleLabel?.font = UIFont(name: font1Regular, size: 18)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
    }
    
    
    func homeSetup(){
        var image = menuIcon1!
        let targetWidth : CGFloat = 92
        let targetHeight : CGFloat = 92
        var scaledImage = image
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight),false,0)
        image.drawInRect(CGRectMake(0, 0, targetWidth, targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        menuItem1.setImage(scaledImage.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        
        
        image = menuIcon2!
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight),false,0)
        image.drawInRect(CGRectMake(0, 0, targetWidth, targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        menuItem2.setImage(scaledImage.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        
        
        image = menuIcon3!
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight),false,0)
        image.drawInRect(CGRectMake(0, 0, targetWidth, targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        menuItem3.setImage(scaledImage.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        
        image = menuIcon4!
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight),false,0)
        image.drawInRect(CGRectMake(0, 0, targetWidth, targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        menuItem4.setImage(scaledImage.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        
        image = menuIcon5!
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight),false,0)
        image.drawInRect(CGRectMake(0, 0, targetWidth, targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        menuItem5.setImage(scaledImage.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        
        image = menuIcon6!
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight),false,0)
        image.drawInRect(CGRectMake(0, 0, targetWidth, targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        menuItem6.setImage(scaledImage.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        
        
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
    
    override func viewDidAppear(animated: Bool) {
        downloadManagerPin()
        fetchDataCat { (result) in
            if result {
                self.fetchDataFood({ (result) in
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
        }

     

    }
    
    
    func setupLocationNotifications(){
        UIApplication.sharedApplication().cancelAllLocalNotifications()
         //Check if location is set to enabled always
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            showErrorAlert("Location Services Disabled", msg: "Please enable location services for Onion Apps in your device settings.", VC: self)
        } else {
            print("Location Auth Confirmed: Always")
        }
        
        //setup geofences to monitor
        
        for loc in branches {
            
            let geoCoder = CLGeocoder()
            
            geoCoder.geocodeAddressString(loc, completionHandler: { (placemarks, error) in
        
                if let placeMark = placemarks?[0] {
                    
                    if let long = placeMark.location?.coordinate.longitude, lat = placeMark.location?.coordinate.latitude   {
                        
                        
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
                        
                        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
                            showErrorAlert("Location Services Disabled", msg: "Geo-location is not supported on this device.", VC: self)
                        } else {
                            self.locationManager.startMonitoringForRegion(region)
                            //print("Region monitoring started for \(self.nameTitle)")
                        }
                        
                        
                    }
                    
                }
                
            })
        }

        let settings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        
        
    }
    

    @IBAction func socialBtnPressed(sender: AnyObject) {
        if let appURL = NSURL(string: socialURLApp) {
            let canOpen = UIApplication.sharedApplication().canOpenURL(appURL)
            
            if canOpen {
                UIApplication.sharedApplication().openURL(NSURL(string: socialURLApp)!)
            } else {
                UIApplication.sharedApplication().openURL(NSURL(string: socialURLWeb)!)
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
        client.fetchEntries(["content_type": "security"]).1.next {
            for pin in $0.items{
               if let pinManager = pin.fields["pin"] as? String {
                    mPin = pinManager
                    NSUserDefaults.standardUserDefaults().setValue(mPin, forKey: "managerPin")
                    print("Manager PIN: \(managerPin)")
                }
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
    
  func downloadCategories() {
        DataService.ds.logInAnonymously { (result) in
            
    }
    
    var changes: Int = 0
    
        deleteCoreDataNil("Category")
        deleteCoreDataNil("FoodItem")
        
        let myGroupCat = dispatch_group_create()
        let myGroupCat2 = dispatch_group_create()
        
        
        client.fetchEntries(["content_type": "category"]).1.next {
            
            categories.removeAll()
            let data = $0.items
            if data.count < categoriesData.count {
                print("Data: \(data.count) DataFromCore:\(categoriesData.count)")
                self.clearDataAll()
           
            }
            
            if categoriesData.count > 0 {
                print("Checking for data changes...")
                //IF DATA IS EXISTING, CHECK IF THERE ARE CHANGES. IF YES, REDOWNLOAD EVERYTHING. Else, do nothing.
                for entry in data{
                    dispatch_group_enter(myGroupCat)
                    if let dataURL = entry.fields["image"] as? Asset{
                        do {
                        imgURL = try dataURL.URL()
                        
                        print("Checking: \(entry.fields["categoryName"]!)")
                        
                        for item in categoriesData {
                            
                            
                            print("with...\(item.valueForKey("name")!)")
                            if let _ = item.valueForKey("id") where "\(item.valueForKey("id")!)" == "\(entry.identifier)" {
                                
                                
                                if let _ = item.valueForKey("name"), _ = item.valueForKey("imageURL"), _ = imgURL, _ = item.valueForKey("order"), _ = entry.fields["order"] where "\(item.valueForKey("imageURL")!)" != "\(imgURL)" ||
                                    "\(item.valueForKey("order")!)" != "\(entry.fields["order"]!)" || "\(item.valueForKey("name")!)" != "\(entry.fields["categoryName"]!)" {
                                    
                                    print("Did detect change in CATEGORIES: \(item.valueForKey("name")!)")
                                    changes += 1
                                    
                                }
                            }
                            
                        }
                        
                        dispatch_group_leave(myGroupCat)
                        } catch {
                            dispatch_group_leave(myGroupCat)
                        }
                        
                    } else {
                        print("Checking NoImage: \(entry.fields["categoryName"]!)")
                        
                        for item in categoriesData {
                            
                            
                            print("with...\(item.valueForKey("name")!)")
                            if let _ = item.valueForKey("id") where "\(item.valueForKey("id")!)" == "\(entry.identifier)" {
                                
                                
                                if let _ = item.valueForKey("name"), _ = item.valueForKey("order"), _ = entry.fields["order"] where
                                    "\(item.valueForKey("order")!)" != "\(entry.fields["order"]!)" || "\(item.valueForKey("name")!)" != "\(entry.fields["categoryName"]!)" {
                                    
                                    print("Did detect change in CATEGORIES: \(item.valueForKey("name")!)")
                                    changes += 1
                                    
                                }
                            }
                            
                        }
                        dispatch_group_leave(myGroupCat)
                    }
                    
                    
                }
                
                dispatch_group_notify(myGroupCat, dispatch_get_main_queue(), {
                    
                    if changes > 0 {
                        self.clearDataAll()
                        changes = 0
                        SwiftSpinner.show(LoadingMsgGlobal)
                        //DOWNLOAD FRESH
                        print("Downloading fresh data...")
                        if categoriesData.count == 0 {
                            for entry in data{
                                dispatch_group_enter(myGroupCat2)
                                if let data = entry.fields["image"] as? Asset{
                                    do {
                                        imgURL = try data.URL()
                                        
                                        //If zero data yet saved in client
                                        downloadImage(imgURL, completionHandler: { (isResponse) in
                                            print(entry.identifier)
                                            categories.append(Category(id: "\(entry.identifier)", name: "\(entry.fields["categoryName"]!)", order: Int("\(entry.fields["order"]!)")!, image: isResponse.0, imgURL: "\(isResponse.1)"))
                                            dispatch_group_leave(myGroupCat2)
                                        })
                                        
                                        
                                    } catch {
                                        
                                        dispatch_group_leave(myGroupCat2)
                                    }
                                    
                                } else {
                                    //If no image is uploaded for this item, user default or blank
                                    categories.append(Category(id: "\(entry.identifier)", name: "\(entry.fields["categoryName"]!)", order: Int("\(entry.fields["order"]!)")!, image: UIImage(), imgURL: ""))
                                    dispatch_group_leave(myGroupCat2)
                                }
                                
                            }
                            
                            dispatch_group_notify(myGroupCat2, dispatch_get_main_queue(), {
                                
                                print("Download complete.")
                                
                                categories.sortInPlace({ $0.order < $1.order })
                                
                                for cat in categories {
                                    
                                    self.saveCategory(cat)
                                }
                                self.downloadFoodItems()
                                //SwiftSpinner.hide()
                            })
                        }

                    }else {
                        self.downloadFoodItems()
                        print("No changes in CATEGORIES detected.")
                    }
                })
            }else {
                //DOWNLOAD FRESH
                SwiftSpinner.show(LoadingMsgGlobal)
                print("Downloading fresh data...")
                if categoriesData.count == 0 {
                    for entry in data{
                        dispatch_group_enter(myGroupCat2)
                        if let data = entry.fields["image"] as? Asset{
                            do {
                                imgURL = try data.URL()
                                
                                //If zero data yet saved in client
                                downloadImage(imgURL, completionHandler: { (isResponse) in
                                    print(entry.identifier)
                                    categories.append(Category(id: "\(entry.identifier)", name: "\(entry.fields["categoryName"]!)", order: Int("\(entry.fields["order"]!)")!, image: isResponse.0, imgURL: "\(isResponse.1)"))
                                    dispatch_group_leave(myGroupCat2)
                                })
                                
                                
                            } catch {
                                
                                dispatch_group_leave(myGroupCat2)
                            }
                            
                        } else {
                            //If no image is uploaded for this item, user default or blank
                            categories.append(Category(id: "\(entry.identifier)", name: "\(entry.fields["categoryName"]!)", order: Int("\(entry.fields["order"]!)")!, image: UIImage(), imgURL: ""))
                            dispatch_group_leave(myGroupCat2)
                        }
                        
                    }
                    
                    dispatch_group_notify(myGroupCat2, dispatch_get_main_queue(), {
                        
                        print("Download complete.")
                        
                        categories.sortInPlace({ $0.order < $1.order })
                        
                        for cat in categories {
                            self.saveCategory(cat)
                        }
                        self.downloadFoodItems()
                        //SwiftSpinner.hide()
                    })
                }
            }
            
            
        }
    
    
    }
    
    func downloadFoodItems() {
        
        var categoryFood: String!
        let myGroupFood = dispatch_group_create()
        let myGroupFood2 = dispatch_group_create()
        var likes: Int = 0
        var changes: Int = 0
        
        client.fetchEntries(["content_type": "menuItem"]).1.next {
            
            foodItems.removeAll()
            let data = $0.items
            if data.count < foodItemsData.count {
                print("Data \(data.count) DataLocal: \(foodItemsData.count)")
                categoriesData.removeAll()
                foodItemsData.removeAll()
                self.clearCoreDataFoodMenu()
                print("Cleared core data.")
            }
            if foodItemsData.count > 0 {
                print("Checking for data changes...")
                for entry in data{
                    dispatch_group_enter(myGroupFood)
                    //setup likes
                    DataService.ds.REF_LIKES.child("\(entry.identifier)").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        
                        if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            if snapshot.value is NSNull {
                                likes = 0
                                DataService.ds.REF_LIKES.child("\(entry.identifier)").setValue(["likes": 0], withCompletionBlock: { (error, FIRDatabaseReference) in
                                })
                            }
                            
                            //download data
                            if let dataURL = entry.fields["image"] as? Asset{
                                
                                do {
                                    imgURL = try dataURL.URL()
                                    //CHECKING FOR UPDATES FROM SERVER, SKIP IF STILL UPDATED
                                    
                                    print("Checking: \(entry.fields["itemName"]!)")
                                    for item in foodItemsData {
                                        
                                        if let cat = entry.fields["category"] as? Entry {
                                            categoryFood = cat.fields["categoryName"] as! String
                                        }
                                        print("with...\(item.valueForKey("name")!)")
                                        if let _ = item.valueForKey("id") where "\(item.valueForKey("id")!)" == "\(entry.identifier)" {
                                            
                                            
                                            if let _ = item.valueForKey("imageURL") as? String, _ = imgURL, _ = item.valueForKey("price"), _ = entry.fields["price"] where "\(item.valueForKey("imageURL")!)" != "\(imgURL)" ||
                                                "\(item.valueForKey("price")!)" != "\(entry.fields["price"]!)" ||
                                                "\(item.valueForKey("descriptionInfo")!)" != "\(entry.fields["itemDescription"]!)" ||
                                                "\(item.valueForKey("category")!)" != "\(categoryFood)" || "\(item.valueForKey("name")!)" != "\(entry.fields["itemName"]!)" {
                                                
                                                print("Did detect change in FOOD ITEM: \(item.valueForKey("name")!)")
                                                changes += 1
                                            }
                                        }
                                        
                                    }
                                    dispatch_group_leave(myGroupFood)
                                    
                                } catch {
                                    dispatch_group_leave(myGroupFood)
                                }
                                
                            }else {
                                print("Checking NoImage: \(entry.fields["itemName"]!)")
                                for item in foodItemsData {
                                    
                                    if let cat = entry.fields["category"] as? Entry {
                                        categoryFood = cat.fields["categoryName"] as! String
                                    }
                                    if let _ = item.valueForKey("id") where "\(item.valueForKey("id")!)" == "\(entry.identifier)" {
                                        if let _ = item.valueForKey("price"), _ = entry.fields["price"] where "\(item.valueForKey("price")!)" != "\(entry.fields["price"]!)" ||
                                            "\(item.valueForKey("descriptionInfo")!)" != "\(entry.fields["itemDescription"]!)" ||
                                            "\(item.valueForKey("category")!)" != "\(categoryFood)" || "\(item.valueForKey("name")!)" != "\(entry.fields["itemName"]!)" || (entry.fields["image"] == nil && "\(item.valueForKey("imageURL")!)" != "") {
                                            
                                            print("Did detect change in FOOD ITEM: \(item.valueForKey("name")!) \(item.valueForKey("imageURL"))")
                                            changes += 1
                                        }
                                        
                                    }
                                    
                                }
                                dispatch_group_leave(myGroupFood)
                            }
                            
                        }
                    })
                }
                dispatch_group_notify(myGroupFood, dispatch_get_main_queue(), {
                    if changes > 0 {
                        self.clearDataExCat()
                        changes = 0
                        print("Downloading fresh data...")
                        SwiftSpinner.show(LoadingMsgGlobal)
                        if foodItemsData.count == 0 {
                            for entry in data{
                                dispatch_group_enter(myGroupFood2)
                                if let dataURL = entry.fields["image"] as? Asset{
                                    do {
                                        imgURL = try dataURL.URL()
                                        
                                        downloadImage(imgURL, completionHandler: { (isResponse) in
                                            
                                            if let cat = entry.fields["category"] as? Entry {
                                                categoryFood = cat.fields["categoryName"] as! String
                                            }
                                            
                                            foodItems.append(FoodItem(id: "\(entry.identifier)", cat: "\(categoryFood)", name: "\(entry.fields["itemName"]!)", desc: "\(entry.fields["itemDescription"]!)" , price: (entry.fields["price"]! as? Double)!, image: isResponse.0, imgURL: "\(isResponse.1)", key: entry.identifier, likes: likes))
                                            
                                            dispatch_group_leave(myGroupFood2)
                                        })
                                        
                                        
                                    } catch {
                                        
                                        dispatch_group_leave(myGroupFood2)
                                    }
                                    
                                } else {
                                    //If no image is uploaded for this item, user default or blank
                                    if let cat = entry.fields["category"] as? Entry {
                                        categoryFood = cat.fields["categoryName"] as! String
                                    }
                                   
                                    foodItems.append(FoodItem(id: "\(entry.identifier)", cat: "\(categoryFood)", name: "\(entry.fields["itemName"]!)", desc: "\(entry.fields["itemDescription"]!)" , price: (entry.fields["price"]! as? Double)!, image: nil, imgURL: nil, key: entry.identifier, likes: likes))
                                    dispatch_group_leave(myGroupFood2)
                                }
                                
                            }
                        }
                        dispatch_group_notify(myGroupFood2, dispatch_get_main_queue(), {
                            
                            print("Download complete.")
                            foodItems.sortInPlace({ $0.price < $1.price })
                            
                            for food in foodItems {
                                
                                self.saveFood(food)
                            }
                            print("Update Check Complete.")
                            self.setupLocationNotifications()
                            SwiftSpinner.hide()
                        })
                    }
                    else {
                        SwiftSpinner.hide()
                        print("No changes in FOOD detected.")
                    }
                })
            } else {
                print("Downloading fresh data...")
                SwiftSpinner.show(LoadingMsgGlobal)
                if foodItemsData.count == 0 {
                    for entry in data{
                        dispatch_group_enter(myGroupFood2)
                        if let dataURL = entry.fields["image"] as? Asset{
                            do {
                                imgURL = try dataURL.URL()
                                
                                downloadImage(imgURL, completionHandler: { (isResponse) in
                                    
                                    if let cat = entry.fields["category"] as? Entry {
                                        categoryFood = cat.fields["categoryName"] as! String
                                    }
                                    
                                    foodItems.append(FoodItem(id: "\(entry.identifier)", cat: "\(categoryFood)", name: "\(entry.fields["itemName"]!)", desc: "\(entry.fields["itemDescription"]!)" , price: (entry.fields["price"]! as? Double)!, image: isResponse.0, imgURL: "\(isResponse.1)", key: entry.identifier, likes: likes))
                                    
                                    dispatch_group_leave(myGroupFood2)
                                })
                                
                                
                            } catch {
                                
                                dispatch_group_leave(myGroupFood2)
                            }
                            
                        } else {
                            //If no image is uploaded for this item, user default or blank
                            if let cat = entry.fields["category"] as? Entry {
                                categoryFood = cat.fields["categoryName"] as! String
                            }
                            
                            foodItems.append(FoodItem(id: "\(entry.identifier)", cat: "\(categoryFood)", name: "\(entry.fields["itemName"]!)", desc: "\(entry.fields["itemDescription"]!)" , price: (entry.fields["price"]! as? Double)!, image: nil, imgURL: nil, key: entry.identifier, likes: likes))
                            dispatch_group_leave(myGroupFood2)
                        }
                        
                    }
                }
                dispatch_group_notify(myGroupFood2, dispatch_get_main_queue(), {
                    
                    print("Download complete.")
                    foodItems.sortInPlace({ $0.price < $1.price })
                    
                    for food in foodItems {
                        
                        self.saveFood(food)
                    }
                    print("Update Check Complete.")
                    self.setupLocationNotifications()
                    
                    SwiftSpinner.hide()
                })
            }
 
        }
        
        
    }
    
 
    
    func saveCategory(category: Category) {
        let appDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Category", inManagedObjectContext:managedContext)
        let categoryTemp = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        let fetchRequest = NSFetchRequest(entityName: "Category")
        
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", category.id)
        do {
            if let fetchResults = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
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
    
    func saveFood(foodItem: FoodItem) {
        let appDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("FoodItem", inManagedObjectContext:managedContext)
        let categoryTemp = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        let fetchRequest = NSFetchRequest(entityName: "FoodItem")
        
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", foodItem.id)
        do {
            if let fetchResults = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
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

    func fetchDataCat(completion: (result: Bool) -> Void) {
        categoriesData.removeAll()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "id != %@", "")
        
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            
            categoriesData = results as! [NSManagedObject]
            if categoriesData.count > 0 {
                print("Category: Local data fetched.")
                completion(result: true)
            }else{
                print("Category: No data available in local.")
                completion(result: true)
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    func fetchDataFood(completion: (result: Bool) -> Void) {
        
        foodItemsData.removeAll()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
     
        let fetchRequestFood = NSFetchRequest(entityName: "FoodItem")
        fetchRequestFood.predicate = NSPredicate(format: "id != %@", "")
        
        do {
         
            
            let resultsFood =
                try managedContext.executeFetchRequest(fetchRequestFood)
            
            foodItemsData = resultsFood as! [NSManagedObject]
            if foodItemsData.count > 0 {
                print("Food: Local data fetched.")
                completion(result: true)
            }else{
                print("FoodNo data available in local.")
                completion(result: true)
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}

