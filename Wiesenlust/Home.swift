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
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        setupLocationNotifications()
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
        
        fetchDataCat()
        fetchDataFood()
        downloadManagerPin()
        if (foodItemsData.count == 0 || categoriesData.count == 0 ) && firstload{
            
            SwiftSpinner.show(LoadingMsgGlobal)
            firstload = false
        }
        
        if !checkConnectivity() {
             SwiftSpinner.hide()
            showErrorAlert("Network Error", msg: "Please check your internet connection.", VC: self)
        }
        setupLocationNotifications()
        downloadCategories()
     

    }
    
    
    func setupLocationNotifications(){
        
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
                    
                    if let name = placeMark.thoroughfare as String?,long = placeMark.location?.coordinate.longitude, lat = placeMark.location?.coordinate.latitude   {
                        
                        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude:
                            lat, longitude: long), radius: radiusOfInterest, identifier: name)
                        region.notifyOnEntry = true
                        region.notifyOnExit = false
                        //print("Name:\(name) Long:\(long) Lat:\(lat)")
                        
                        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
                            showErrorAlert("Location Services Disabled", msg: "Geo-location is not supported on this device.", VC: self)
                        } else {
                            self.locationManager.startMonitoringForRegion(region)
                            print("Region monitoring started for \(name)")
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
    
    func downloadManagerPin() {
        
        client.fetchEntries(["content_type": "security"]).1.next {
            for pin in $0.items{
               if let pinManager = pin.fields["pin"] as? String {
                    managerPin = pinManager
                    print("Manager PIN: \(managerPin)")
                }
            }
        }
    }
    
  func downloadCategories() {
        DataService.ds.logInAnonymously { (result) in
            
    }
    
        deleteCoreDataNil("Category")
        deleteCoreDataNil("FoodItem")
        
        let myGroupCat = dispatch_group_create()
        
        
        client.fetchEntries(["content_type": "category"]).1.next {
            
            categories.removeAll()
            
            if $0.items.count < categoriesData.count {
                print("items: \($0.items.count) data: \(categoriesData.count)")
                categoriesData.removeAll()
                foodItemsData.removeAll()
                self.clearCoreDataFoodMenu()
                print("Cleared core data.")
            }
            
            for entry in $0.items{
                dispatch_group_enter(myGroupCat)
                if let data = entry.fields["image"] as? Asset{
                    
                    do {
                        imgURL = try data.URL()
                        //CHECKING FOR UPDATES FROM SERVER, SKIP IF STILL UPDATED
                        if categoriesData.count > 0 {
                            
                            for item in categoriesData {
                                
                                if let _ = item.valueForKey("name"), _ = entry.fields["categoryName"] where "\(item.valueForKey("name"))" == "\(entry.fields["categoryName"])" {
                                    
                                    
                                    if let _ = item.valueForKey("imageURL"), _ = imgURL, _ = item.valueForKey("order"), _ = entry.fields["order"] where "\(item.valueForKey("imageURL")!)" != "\(imgURL)" ||
                                        "\(item.valueForKey("order")!)" != "\(entry.fields["order"]!)" {
                                        
                                        print("Did detect change for \(item.valueForKey("name"))")
                                        
                                        print("\(item.valueForKey("name"))")
                                        print("\(entry.fields["categoryName"])")
                                        print("\(item.valueForKey("imageURL")!)")
                                        print("\(imgURL)")
                                        
                                        //If data in client is not updated
                                        
                                        dispatch_group_enter(myGroupCat)
                                        
                                        downloadImage(imgURL, completionHandler: { (isResponse) in
                                            
                                            print("Did download the update")
                                            categories.append(Category(name: "\(entry.fields["categoryName"]!)", order: Int("\(entry.fields["order"]!)")!, image: isResponse.0, imgURL: "\(isResponse.1)"))
                                            dispatch_group_leave(myGroupCat)
                                            
                                        })
                                    }
                                }
                                
                            }
                            
                            dispatch_group_leave(myGroupCat)
                        }
                            
                        else if categoriesData.count == 0{
                            //If zero data yet saved in client
                            downloadImage(imgURL, completionHandler: { (isResponse) in
                                
                                categories.append(Category(name: "\(entry.fields["categoryName"]!)", order: Int("\(entry.fields["order"]!)")!, image: isResponse.0, imgURL: "\(isResponse.1)"))
                                dispatch_group_leave(myGroupCat)
                            })
                        }
                        
                        
                    } catch {
                        print("Error Code: FJ3D85")
                        dispatch_group_leave(myGroupCat)
                    }
                    
                } else {
                    //If no image is uploaded for this item, user default or blank
                    categories.append(Category(name: "\(entry.fields["categoryName"]!)", order: Int("\(entry.fields["order"]!)")!, image: UIImage(), imgURL: ""))
                    dispatch_group_leave(myGroupCat)
                }
                
                
                
            }
            
            dispatch_group_notify(myGroupCat, dispatch_get_main_queue(), {
                
                
                categories.sortInPlace({ $0.order < $1.order })
                
                for cat in categories {
                    self.saveCategory(cat)
                }
                self.downloadFoodItems()
                //SwiftSpinner.hide()
            })
            
            
        }
        
        
    }
    
    func downloadFoodItems() {
        
        var categoryFood: String!
        let myGroupFood = dispatch_group_create()
        var likes: Int = 0
        
        client.fetchEntries(["content_type": "menuItem"]).1.next {
            
            foodItems.removeAll()
            
            if $0.items.count < foodItemsData.count {
                print("items: \($0.items.count) data: \(categoriesData.count)")
                categoriesData.removeAll()
                foodItemsData.removeAll()
                self.clearCoreDataFoodMenu()
                print("Cleared core data.")
            }
            
            for entry in $0.items{
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
                        if let data = entry.fields["image"] as? Asset{
                            
                            do {
                                imgURL = try data.URL()
                                //CHECKING FOR UPDATES FROM SERVER, SKIP IF STILL UPDATED
                                if foodItemsData.count > 0 {
                                    
                                    for item in foodItemsData {
                                        
                                        if let cat = entry.fields["category"] as? Entry {
                                            categoryFood = cat.fields["categoryName"] as! String
                                        }
                                        
                                        if let _ = item.valueForKey("name"), _ = entry.fields["itemName"] where "\(item.valueForKey("name"))" == "\(entry.fields["itemName"])" {
                                            
                                            
                                            if let _ = item.valueForKey("imageURL") as? String, _ = imgURL, _ = item.valueForKey("price"), _ = entry.fields["price"] where "\(item.valueForKey("imageURL")!)" != "\(imgURL)" ||
                                                "\(item.valueForKey("price")!)" != "\(entry.fields["price"]!)" ||
                                                "\(item.valueForKey("descriptionInfo")!)" != "\(entry.fields["itemDescription"]!)" ||
                                                "\(item.valueForKey("category")!)" != "\(categoryFood)" {
                                                
                                                print("Did detect change for \(item.valueForKey("name")!)")
                                                
                                                print("\(item.valueForKey("name")!)")
                                                print("\(entry.fields["itemName"]!)")
                                                print("\(item.valueForKey("imageURL")!)")
                                                print("\(imgURL)")
                                                
                                                //If data in client is not updated
                                                
                                                dispatch_group_enter(myGroupFood)
                                                
                                                downloadImage(imgURL, completionHandler: { (isResponse) in
                                                    
                                                    print("Did download the update")
                                                    foodItems.append(FoodItem(cat: "\(categoryFood)", name: "\(entry.fields["itemName"]!)", desc: "\(entry.fields["itemDescription"]!)" , price: (entry.fields["price"]! as? Double)!, image: isResponse.0, imgURL: "\(isResponse.1)", key: entry.identifier, likes: likes))
                                                    dispatch_group_leave(myGroupFood)
                                                    
                                                })
                                            }
                                        }
                                        
                                    }
                                    
                                    dispatch_group_leave(myGroupFood)
                                }
                                    
                                else if foodItemsData.count == 0{
                                    //If zero data yet saved in client
                                    downloadImage(imgURL, completionHandler: { (isResponse) in
                                        
                                        if let cat = entry.fields["category"] as? Entry {
                                            categoryFood = cat.fields["categoryName"] as! String
                                        }
                                        
                                        foodItems.append(FoodItem(cat: "\(categoryFood)", name: "\(entry.fields["itemName"]!)", desc: "\(entry.fields["itemDescription"]!)" , price: (entry.fields["price"]! as? Double)!, image: isResponse.0, imgURL: "\(isResponse.1)", key: entry.identifier, likes: likes))
                                        
                                        dispatch_group_leave(myGroupFood)
                                    })
                                }
                                
                                
                            } catch {
                                print("Error Code: KF2048J")
                                dispatch_group_leave(myGroupFood)
                            }
                            
                        } else {
                            if let cat = entry.fields["category"] as? Entry {
                                categoryFood = cat.fields["categoryName"] as! String
                            }
                            //If no image is uploaded for this item, user default or blank
                            foodItems.append(FoodItem(cat: "\(categoryFood)", name: "\(entry.fields["itemName"]!)", desc: "\(entry.fields["itemDescription"]!)" , price: (entry.fields["price"]! as? Double)!, image: nil, imgURL: nil, key: entry.identifier, likes: likes))
                            dispatch_group_leave(myGroupFood)
                        }

                    }
                })
                
                
                
            }
            
            dispatch_group_notify(myGroupFood, dispatch_get_main_queue(), {
                
                
                foodItems.sortInPlace({ $0.price < $1.price })
                
                for food in foodItems {
                    
                    self.saveFood(food)
                }
                print("Update Check Complete.")
                SwiftSpinner.hide()
            })
            
            
        }
        
        
    }
    
 
    
    func saveCategory(category: Category) {
        let appDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Category", inManagedObjectContext:managedContext)
        let categoryTemp = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        let fetchRequest = NSFetchRequest(entityName: "Category")
        
        
        fetchRequest.predicate = NSPredicate(format: "name = %@", category.name)
        do {
            if let fetchResults = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0{
                    
                    
                    fetchResults.first?.setValue(category.name, forKey: "name")
                    fetchResults.first?.setValue(category.order, forKey: "order")
                    fetchResults.first?.setValue(category.img, forKey: "image")
                    fetchResults.first?.setValue(category.imgURL, forKey: "imageURL")
                    
                    do {
                        try fetchResults.first?.managedObjectContext?.save()
                        fetchDataCat()
                        print("Updated: \(category.name) mit order \(category.order) und \(category.imgURL) ")
                        
                    } catch let error as NSError {
                        print("Could not fetch \(error), \(error.userInfo)")
                    }
                    
                    
                } else {
                    
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
        
        
        fetchRequest.predicate = NSPredicate(format: "name = %@", foodItem.name)
        do {
            if let fetchResults = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0{
                    
                    
                    fetchResults.first?.setValue(foodItem.name, forKey: "name")
                    fetchResults.first?.setValue(foodItem.price, forKey: "price")
                    fetchResults.first?.setValue(foodItem.descriptionInfo, forKey: "descriptionInfo")
                    fetchResults.first?.setValue(foodItem.img, forKey: "image")
                    fetchResults.first?.setValue(foodItem.imgURL, forKey: "imageURL")
                    fetchResults.first?.setValue(foodItem.postRef, forKey: "key")
                    fetchResults.first?.setValue(foodItem.postLikes, forKey: "likes")
                    
                    do {
                        try fetchResults.first?.managedObjectContext?.save()
                        fetchDataCat()
                        print("Updated Food: \(foodItem.name) mit preis \(foodItem.price) und \(foodItem.imgURL), \(foodItem.postLikes) ")
                        
                    } catch let error as NSError {
                        print("Could not fetch \(error), \(error.userInfo)")
                    }
                    
                    
                } else {
                    
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

    func fetchDataCat() {
        categoriesData.removeAll()
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "name != %@", "")
        
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            
            categoriesData = results as! [NSManagedObject]
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    func fetchDataFood() {
        
        foodItemsData.removeAll()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
     
        let fetchRequestFood = NSFetchRequest(entityName: "FoodItem")
        fetchRequestFood.predicate = NSPredicate(format: "name != %@", "")
        
        do {
         
            
            let resultsFood =
                try managedContext.executeFetchRequest(fetchRequestFood)
            
            foodItemsData = resultsFood as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}

