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
   
    @IBOutlet weak var homeView: UIView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var firstload = true
    let locationManager = CLLocationManager()
    var nameTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        homeView.alpha = 0.0
        
        homeSetup()
        
        navigationController?.isNavigationBarHidden = true
        
        backgroundImg.image = UIImage(named: "bg")
        backgroundView.backgroundColor = UIColor.white
        backgroundImg.alpha = 1.0
        
        socialButton.backgroundColor = UIColor.clear
        socialButton.layer.cornerRadius = 5
        socialButton.layer.borderWidth = 1
        socialButton.layer.borderColor = COLOR1.cgColor
        socialButton.setTitle(socialButtonTitle, for: UIControlState())
        socialButton.setTitleColor(COLOR2, for: UIControlState())
        socialButton.titleLabel?.font = UIFont(name: font1Regular, size: 18)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        homeView.alpha = 0.0
        self.topConstraint.isActive = true
        self.bottomConstraint.isActive = true
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
        menuItem1.setImage(scaledImage.withRenderingMode(.automatic), for: UIControlState())
        
        
        image = menuIcon2!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: targetWidth, height: targetHeight),false,0)
        image.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        menuItem2.setImage(scaledImage.withRenderingMode(.automatic), for: UIControlState())
        
        
        image = menuIcon3!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: targetWidth, height: targetHeight),false,0)
        image.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        menuItem3.setImage(scaledImage.withRenderingMode(.automatic), for: UIControlState())
        
        image = menuIcon4!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: targetWidth, height: targetHeight),false,0)
        image.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        menuItem4.setImage(scaledImage.withRenderingMode(.automatic), for: UIControlState())
        
        image = menuIcon5!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: targetWidth, height: targetHeight),false,0)
        image.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        menuItem5.setImage(scaledImage.withRenderingMode(.automatic), for: UIControlState())
        
        image = menuIcon6!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: targetWidth, height: targetHeight),false,0)
        image.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        menuItem6.setImage(scaledImage.withRenderingMode(.automatic), for: UIControlState())
        
        
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
        
        UIView.animate(withDuration: 1.0, animations: {
            self.homeView.alpha = 1.0           
            self.topConstraint.isActive = false
            self.bottomConstraint.isActive = true
            
            // Make the animation happen
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            
            
        })
        
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
        backgroundThread(0, background: { 
            for each in foodItemsData {
                
                dishesMain.append(FoodItem(id: "\(each.value(forKey: "id"))",cat: each.value(forKey: "category")! as! String, name: each.value(forKey: "name")! as! String, desc: each.value(forKey: "descriptionInfo")! as? String, price: each.value(forKey: "price")! as! Double, image: UIImage(data: each.value(forKey: "image") as! Data), imgURL: each.value(forKey: "imageURL")! as? String, key: each.value(forKey: "key")! as! String, likes: each.value(forKey: "likes") as? Int))
                
            }

            }) {
                //DO NOTHING
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
                        
                        if let _ = self.nameTitle {
                            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude:
                                lat, longitude: long), radius: radiusOfInterest, identifier: self.nameTitle!)
                            region.notifyOnEntry = true
                            region.notifyOnExit = false
                            print("Name:\(self.nameTitle!) Long:\(long) Lat:\(lat)")
                            
                            if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                                showErrorAlert("Location Services Disabled", msg: "Geo-location is not supported on this device.", VC: self)
                            } else {
                                self.locationManager.startMonitoring(for: region)
                                //print("Region monitoring started for \(self.nameTitle)")
                            }
                        }
                        
                        
                        
                    }
                    
                }
                
            })
        }

        let settings = UIUserNotificationSettings(types: .alert, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        
        
        
    }
    

    @IBAction func socialBtnPressed(_ sender: AnyObject) {
      
        UIApplication.shared.openURL(URL(string: socialURLWeb)!)
      
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
    
        let myGroupCat2 = DispatchGroup()
        
         //CONTENTFULTHING
    
    Alamofire.request("https://cdn.contentful.com/spaces/\(CFSpaceId)/entries?access_token=\(CFTokenProduction)&content_type=category").responseJSON { (result) in
        
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
                        
                        if let fields = entry["fields"] as? Dictionary<String, AnyObject>, let sysTop = entry["sys"] as? Dictionary<String, AnyObject>, let catID = sysTop["id"] as? String{
                            
                            if let dataURL = fields["image"] as? Dictionary<String, AnyObject>,let sysItem = dataURL["sys"] as? Dictionary<String, AnyObject>, let id = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let assets = includes["Asset"] as? [Dictionary<String, AnyObject>]{
                                
                                for asset in assets{
                                    if let sys = asset["sys"] as? Dictionary<String, AnyObject>, let idRef = sys["id"] as? String, idRef == id{
                                        if let fieldAss = asset["fields"] as? Dictionary<String, AnyObject>, let file = fieldAss["file"] as? Dictionary<String, AnyObject>, let imageURL = file["url"] as? String{
                                            imgURL = URL(string: "https:\(imageURL)")
                                            print("Checking: \(fields["categoryName"]!)")
                                            
                                            for item in categoriesData {
                                                
                                                
                                                print("with...\(item.value(forKey: "name")!)")
                                                if let _ = item.value(forKey: "id") , "\(item.value(forKey: "id")!)" == "\(catID)" {
                                                    
                                                    
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
                                                if let _ = item.value(forKey: "id") , "\(item.value(forKey: "id")!)" == "\(catID)" {
                                                    
                                                    
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
                                if let fields = entry["fields"] as? Dictionary<String, AnyObject>, let sysTop = entry["sys"] as? Dictionary<String, AnyObject>, let catID = sysTop["id"] as? String{
   
                                  if let dataURL = fields["image"] as? Dictionary<String, AnyObject>,let sysItem = dataURL["sys"] as? Dictionary<String, AnyObject>, let id = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let assets = includes["Asset"] as? [Dictionary<String, AnyObject>]{
                                        
                                        for asset in assets{
                                            if let sys = asset["sys"] as? Dictionary<String, AnyObject>, let idRef = sys["id"] as? String, idRef == id{
                                                if let fieldAss = asset["fields"] as? Dictionary<String, AnyObject>, let file = fieldAss["file"] as? Dictionary<String, AnyObject>, let imageURL = file["url"] as? String{
                                                    imgURL = URL(string: "https:\(imageURL)")
                                                    
                                                    //If zero data yet saved in client
                                                    downloadImage(imgURL, completionHandler: { (isResponse) in
                                                        print(idRef)
                                                        categories.append(Category(id: "\(catID)", name: "\(fields["categoryName"]!)", order: Int("\(fields["order"]!)")!, image: isResponse.0, imgURL: "\(isResponse.1)"))
                                                        myGroupCat2.leave()
                                                    })
                                                }else{
                                                    //If no image is uploaded for this item, user default or blank
                                                    categories.append(Category(id: "\(catID)", name: "\(fields["categoryName"]!)", order: Int("\(fields["order"]!)")!, image: UIImage(), imgURL: ""))
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
                            if let fields = entry["fields"] as? Dictionary<String, AnyObject>, let sysTop = entry["sys"] as? Dictionary<String, AnyObject>, let catID = sysTop["id"] as? String{
                                
                                if let dataURL = fields["image"] as? Dictionary<String, AnyObject>,let sysItem = dataURL["sys"] as? Dictionary<String, AnyObject>, let id = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let assets = includes["Asset"] as? [Dictionary<String, AnyObject>]{
                                    
                                    for asset in assets{
                                        if let sys = asset["sys"] as? Dictionary<String, AnyObject>, let idRef = sys["id"] as? String, idRef == id{
                                            if let fieldAss = asset["fields"] as? Dictionary<String, AnyObject>, let file = fieldAss["file"] as? Dictionary<String, AnyObject>, let imageURL = file["url"] as? String{
                                                imgURL = URL(string: "https:\(imageURL)")
                                                
                                                //If zero data yet saved in client
                                                downloadImage(imgURL, completionHandler: { (isResponse) in
                                                    print(idRef)
                                                    categories.append(Category(id: "\(catID)", name: "\(fields["categoryName"]!)", order: Int("\(fields["order"]!)")!, image: isResponse.0, imgURL: "\(isResponse.1)"))
                                                    myGroupCat2.leave()
                                                })
                                            }else{
                                                //If no image is uploaded for this item, user default or blank
                                                categories.append(Category(id: "\(catID)", name: "\(fields["categoryName"]!)", order: Int("\(fields["order"]!)")!, image: UIImage(), imgURL: ""))
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
        let myGroupFood1 = DispatchGroup()
        let myGroupFood2 = DispatchGroup()
        var likes: Int = 0
        var changes: Int = 0
        
        Alamofire.request("https://cdn.contentful.com/spaces/\(CFSpaceId)/entries?access_token=\(CFTokenProduction)&content_type=menuItem").responseJSON { (result) in
                
            if let dataResult = result.result.value as? Dictionary<String, AnyObject>{
                    
                if let items = dataResult["items"] as? [Dictionary<String, AnyObject>]{
                
                foodItems.removeAll()
                let data = items
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
                        
                        if let fields = entry["fields"] as? Dictionary<String, AnyObject>, let sysTop = entry["sys"] as? Dictionary<String, AnyObject>, let foodItemID = sysTop["id"] as? String{
                            
                            if let dataURL = fields["image"] as? Dictionary<String, AnyObject>,let sysItem = dataURL["sys"] as? Dictionary<String, AnyObject>, let id = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let assets = includes["Asset"] as? [Dictionary<String, AnyObject>]{
                                
                                for asset in assets{
                                    if let sys = asset["sys"] as? Dictionary<String, AnyObject>, let idRef = sys["id"] as? String, idRef == id{
                                        if let fieldAss = asset["fields"] as? Dictionary<String, AnyObject>, let file = fieldAss["file"] as? Dictionary<String, AnyObject>, let imageURL = file["url"] as? String{
                                            imgURL = URL(string: "https:\(imageURL)")
                                            
                                            myGroupFood1.enter()
                                            //setup likes
                                            DataService.ds.REF_LIKES.child("\(foodItemID)").observeSingleEvent(of: .value, with: { (snapshot) in
                                                
                                                if snapshot.children.allObjects is [FIRDataSnapshot] {
                                                    if snapshot.value is NSNull {
                                                        likes = 0
                                                        DataService.ds.REF_LIKES.child("\(foodItemID)").setValue(["likes": 0], withCompletionBlock: { (error, FIRDatabaseReference) in
                                                        })
                                                    }
                                                    
                                                    //download data
                                                    imgURL = URL(string: "https:\(imageURL)")
                                                        //CHECKING FOR UPDATES FROM SERVER, SKIP IF STILL UPDATED
                                                    
                                                        print("Checking: \(fields["itemName"]!)")
                                                        for item in foodItemsData {
                                                            
                                                            if let cat = fields["category"] as? Dictionary<String, AnyObject>,let sysItem = cat["sys"] as? Dictionary<String, AnyObject>, let catID1 = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let entries = includes["Entry"] as? [Dictionary<String, AnyObject>] {
                                                              
                                                                for entry in entries{
                                                                    if let fieldEntry = entry["fields"] as? Dictionary<String, AnyObject>, let categoryName = fieldEntry["categoryName"] as? String, let sysEntry = entry["sys"] as? Dictionary<String, AnyObject>, let catID2 = sysEntry["id"] as? String, catID1 == catID2{
                                                                        categoryFood = categoryName
                                                                        
                                                                        print("with...\(item.value(forKey: "name")!)")
                                                                        if let _ = item.value(forKey: "id") , "\(item.value(forKey: "id")!)" == "\(foodItemID)" {
                                                                            
                                                                            
                                                                            if let _ = item.value(forKey: "imageURL") as? String, let _ = imgURL, let _ = item.value(forKey: "price"), let _ = fields["price"] , "\(item.value(forKey: "imageURL")!)" != "\(imgURL!)" ||
                                                                                "\(item.value(forKey: "price")!)" != "\(fields["price"]!)" ||
                                                                                "\(item.value(forKey: "descriptionInfo")!)" != "\(fields["itemDescription"]!)" ||
                                                                                "\(item.value(forKey: "category")!)" != "\(categoryFood!)" || "\(item.value(forKey: "name")!)" != "\(fields["itemName"]!)" {
                                                                                
                                                                                print("Did detect change in FOOD ITEM: \(item.value(forKey: "name")!)")
                                                                                
                                                                                changes += 1
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                
                                                            }
                                                           
                                                            
                                                        }
                                                    myGroupFood1.leave()
                                                    
                                                }
                                            })
                                        }else {
                                            
                                            print("Checking NoImage: \(fields["itemName"]!)")
                                            for item in foodItemsData {
                                                
                                                if let cat = fields["category"] as? Dictionary<String, AnyObject>,let sysItem = cat["sys"] as? Dictionary<String, AnyObject>, let catID1 = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let entries = includes["Entry"] as? [Dictionary<String, AnyObject>] {
                                                 
                                                    for entry in entries{
                                                        if let fieldEntry = entry["fields"] as? Dictionary<String, AnyObject>, let categoryName = fieldEntry["categoryName"] as? String, let sysEntry = entry["sys"] as? Dictionary<String, AnyObject>, let catID2 = sysEntry["id"] as? String, catID1 == catID2{
                                                            categoryFood = categoryName
                                                            
                                                            if let _ = item.value(forKey: "id") , "\(item.value(forKey: "id")!)" == "\(foodItemID)" {
                                                                if let _ = item.value(forKey: "price"), let _ = fields["price"] , "\(item.value(forKey: "price")!)" != "\(fields["price"]!)" ||
                                                                    "\(item.value(forKey: "descriptionInfo")!)" != "\(fields["itemDescription"]!)" ||
                                                                    "\(item.value(forKey: "category")!)" != "\(categoryFood!)" || "\(item.value(forKey: "name")!)" != "\(fields["itemName"]!)" || (fields["image"] == nil && "\(item.value(forKey: "imageURL")!)" != "") {
                                                                    
                                                                    print("Did detect change in FOOD ITEM: \(item.value(forKey: "name")!)")
                                                                    changes += 1
                                                                }
                                                                
                                                            }                                                        }
                                                    }
                                                    
                                                }
                                                
                                                
                                            }
                                            
                                            
                                        }

                                    }
                                }
                            }
                        }
                        
                    }
                    myGroupFood1.notify(queue: DispatchQueue.main, execute: {

                    if changes > 0 {
                        self.clearDataExCat()
                        changes = 0
                        print("Downloading fresh data...")
                        SwiftSpinner.show(LoadingMsgGlobal)
                        if foodItemsData.count == 0 {
                            for entry in data{
                                myGroupFood2.enter()
                                if let fields = entry["fields"] as? Dictionary<String, AnyObject>, let sysTop = entry["sys"] as? Dictionary<String, AnyObject>, let foodItemID = sysTop["id"] as? String{
                                    
                                    if let dataURL = fields["image"] as? Dictionary<String, AnyObject>,let sysItem = dataURL["sys"] as? Dictionary<String, AnyObject>, let id = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let assets = includes["Asset"] as? [Dictionary<String, AnyObject>]{
                                        
                                        for asset in assets{
                                            if let sys = asset["sys"] as? Dictionary<String, AnyObject>, let idRef = sys["id"] as? String, idRef == id{
                                                if let fieldAss = asset["fields"] as? Dictionary<String, AnyObject>, let file = fieldAss["file"] as? Dictionary<String, AnyObject>, let imageURL = file["url"] as? String{
                                                    imgURL = URL(string: "https:\(imageURL)")
                                        
                                                    downloadImage(imgURL, completionHandler: { (isResponse) in
                                                        
                                                        if let cat = fields["category"] as? Dictionary<String, AnyObject>,let sysItem = cat["sys"] as? Dictionary<String, AnyObject>, let catID1 = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let entries = includes["Entry"] as? [Dictionary<String, AnyObject>] {
                                                            
                                                            for entry in entries{
                                                                if let fieldEntry = entry["fields"] as? Dictionary<String, AnyObject>, let categoryName = fieldEntry["categoryName"] as? String, let sysEntry = entry["sys"] as? Dictionary<String, AnyObject>, let catID2 = sysEntry["id"] as? String, catID1 == catID2{
                                                                    categoryFood = categoryName
                                                                    foodItems.append(FoodItem(id: "\(foodItemID)", cat: "\(categoryFood!)", name: "\(fields["itemName"]!)", desc: "\(fields["itemDescription"]!)" , price: (fields["price"]! as? Double)!, image: isResponse.0, imgURL: "\(isResponse.1)", key: foodItemID, likes: likes))
                                                                }
                                                            }
                                                            
                                                        }
                                                        
                                                        
                                                        myGroupFood2.leave()
                                                    })
                                                }
                                            }
                                        }
                                    }else {
                                        //If no image is uploaded for this item, user default or blank
                                        if let cat = fields["category"] as? Dictionary<String, AnyObject>,let sysItem = cat["sys"] as? Dictionary<String, AnyObject>, let catID1 = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let entries = includes["Entry"] as? [Dictionary<String, AnyObject>] {
                                            
                                            for entry in entries{
                                                if let fieldEntry = entry["fields"] as? Dictionary<String, AnyObject>, let categoryName = fieldEntry["categoryName"] as? String, let sysEntry = entry["sys"] as? Dictionary<String, AnyObject>, let catID2 = sysEntry["id"] as? String, catID1 == catID2{
                                                    categoryFood = categoryName
                                                    foodItems.append(FoodItem(id: "\(foodItemID)", cat: "\(categoryFood!)", name: "\(fields["itemName"]!)", desc: "\(fields["itemDescription"]!)" , price: (fields["price"]! as? Double)!, image: nil, imgURL: nil, key: foodItemID, likes: likes))
                                                }
                                            }
                                            
                                        }
                                        
                                        myGroupFood2.leave()
                                    }

                                }
                                
                                
                                
                            }
                                
                        }
                        
              
                        myGroupFood2.notify(queue: DispatchQueue.main, execute: {

                            
                                    print("Download complete.")
                                    foodItems.sort(by: { $0.price < $1.price })
                                    
                                    for food in foodItems {
                                        
                                        self.saveFood(food)
                                    }
                                    
                                    self.downloadAnnouncements()
                        })
                    }
                    else{
                        self.downloadAnnouncements()
                        print("No changes in FOOD detected.")
                    }
                    })
            
                } else {
                    
                    print("Downloading fresh data...")
                    print("Food Item Count: \(data.count)")
                    SwiftSpinner.show(LoadingMsgGlobal)
                    if foodItemsData.count == 0 {
                        
                        for entry in data{
                            myGroupFood2.enter()
                            
                            if let fields = entry["fields"] as? Dictionary<String, AnyObject>, let sysTop = entry["sys"] as? Dictionary<String, AnyObject>, let foodItemID = sysTop["id"] as? String{
                                
                                if let dataURL = fields["image"] as? Dictionary<String, AnyObject>,let sysItem = dataURL["sys"] as? Dictionary<String, AnyObject>, let id = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let assets = includes["Asset"] as? [Dictionary<String, AnyObject>]{
                                    
                                    for asset in assets{
                                        if let sys = asset["sys"] as? Dictionary<String, AnyObject>, let idRef = sys["id"] as? String, idRef == id{
                                            if let fieldAss = asset["fields"] as? Dictionary<String, AnyObject>, let file = fieldAss["file"] as? Dictionary<String, AnyObject>, let imageURL = file["url"] as? String{
                                                imgURL = URL(string: "https:\(imageURL)")
                                    
                                                downloadImage(imgURL, completionHandler: { (isResponse) in
                                                    
                                                    if let cat = fields["category"] as? Dictionary<String, AnyObject>,let sysItem = cat["sys"] as? Dictionary<String, AnyObject>, let catID1 = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let entries = includes["Entry"] as? [Dictionary<String, AnyObject>] {
                                                        
                                                        for entry in entries{
                                                            if let fieldEntry = entry["fields"] as? Dictionary<String, AnyObject>, let categoryName = fieldEntry["categoryName"] as? String, let sysEntry = entry["sys"] as? Dictionary<String, AnyObject>, let catID2 = sysEntry["id"] as? String, catID1 == catID2{
                                                                categoryFood = categoryName
                                                                foodItems.append(FoodItem(id: "\(foodItemID)", cat: "\(categoryFood!)", name: "\(fields["itemName"]!)", desc: "\(fields["itemDescription"]!)" , price: (fields["price"]! as? Double)!, image: isResponse.0, imgURL: "\(isResponse.1)", key: foodItemID, likes: likes))
                                                            }
                                                        }
                                                        
                                                    }
                                                   
                                                    myGroupFood2.leave()
                                                    
                                                })
                                    
                                            }
                                        }
                                    }
                                }else {
                                    //If no image is uploaded for this item, user default or blank
                                    if let cat = fields["category"] as? Dictionary<String, AnyObject>,let sysItem = cat["sys"] as? Dictionary<String, AnyObject>, let catID1 = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let entries = includes["Entry"] as? [Dictionary<String, AnyObject>] {
                                        
                                        for entry in entries{
                                            if let fieldEntry = entry["fields"] as? Dictionary<String, AnyObject>, let categoryName = fieldEntry["categoryName"] as? String, let sysEntry = entry["sys"] as? Dictionary<String, AnyObject>, let catID2 = sysEntry["id"] as? String, catID1 == catID2{
                                                categoryFood = categoryName
                                                foodItems.append(FoodItem(id: "\(foodItemID)", cat: "\(categoryFood!)", name: "\(fields["itemName"]!)", desc: "\(fields["itemDescription"]!)" , price: (fields["price"]! as? Double)!, image: nil, imgURL: nil, key: foodItemID, likes: likes))
                                            }
                                        }
                                        
                                    }
                                    
                                   
                                    
                                    myGroupFood2.leave()
                                    
                                }

                                
                            }
                        }
                        
                    }
                    
                    myGroupFood2.notify(queue: DispatchQueue.main, execute: {

                        
                        print("Download complete.")
                        foodItems.sort(by: { $0.name < $1.name })
                        
                        for food in foodItems {
                            
                            self.saveFood(food)
                        }
                        
                        self.downloadAnnouncements()
                    })
                }
     
                }
            
        }
    }
    }
    
    func downloadAnnouncements() {
        
        var changes: Int = 0
        
        let myGroupCat = DispatchGroup()
        let myGroupCat2 = DispatchGroup()
        
         //CONTENTFULTHING
        Alamofire.request("https://cdn.contentful.com/spaces/\(CFSpaceId)/entries?access_token=\(CFTokenProduction)&content_type=announcements").responseJSON { (result) in
            
            if let dataResult = result.result.value as? Dictionary<String, AnyObject>{
                
            if let items = dataResult["items"] as? [Dictionary<String, AnyObject>]{
            
                announcements.removeAll()
                let data = items
                if data.count < announcementsData.count {
                    print("Data: \(data.count) DataFromCore:\(announcementsData.count)")
                    self.clearDataAnn()
                    
                }
                
                if announcementsData.count > 0 {
                    print("Checking for data changes in ANNOUNCEMENTS...")
                    //IF DATA IS EXISTING, CHECK IF THERE ARE CHANGES. IF YES, REDOWNLOAD EVERYTHING. Else, do nothing.
                    for entry in data{
                        if let fields = entry["fields"] as? Dictionary<String, AnyObject>, let sysTop = entry["sys"] as? Dictionary<String, AnyObject>, let annID = sysTop["id"] as? String{
                            
                            if let dataURL = fields["image"] as? Dictionary<String, AnyObject>,let sysItem = dataURL["sys"] as? Dictionary<String, AnyObject>, let id = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let assets = includes["Asset"] as? [Dictionary<String, AnyObject>]{
                                
                                for asset in assets{
                                    if let sys = asset["sys"] as? Dictionary<String, AnyObject>, let idRef = sys["id"] as? String, idRef == id{
                                        if let fieldAss = asset["fields"] as? Dictionary<String, AnyObject>, let file = fieldAss["file"] as? Dictionary<String, AnyObject>, let imageURL = file["url"] as? String{
                                            imgURL = URL(string: "https:\(imageURL)")
                                            print("Checking: \(fields["title"]!)")
                                            
                                            for item in announcementsData {
                                                
                                                print("with...\(item.value(forKey: "title")!)")
                                                if let _ = item.value(forKey: "id") , "\(item.value(forKey: "id")!)" == "\(annID)" && "\(item.value(forKey: "imageURL")!)" != "\(imgURL!)" {
                                                    
                                                    
                                                    print("Did detect change in ANNOUNCEMENTS: \(item.value(forKey: "title")!)")
                                                    changes += 1
                                                    
                                                    
                                                }
                                                
                                            }

                                        }
                                    }
                                }
                            }
                        }
                        
                        
                        
                    }
                    
                   
                        
                        if changes > 0 {
                            self.clearDataAnn()
                            changes = 0
                            SwiftSpinner.show(LoadingMsgGlobal)
                            //DOWNLOAD FRESH
                            print("Downloading fresh data...")
                            if categoriesData.count == 0 {
                                for entry in data{
                                    
                                    for entry in data{
                                        myGroupCat2.enter()
                                        if let fields = entry["fields"] as? Dictionary<String, AnyObject>, let sysTop = entry["sys"] as? Dictionary<String, AnyObject>, let annID = sysTop["id"] as? String{
                                            
                                            if let dataURL = fields["image"] as? Dictionary<String, AnyObject>,let sysItem = dataURL["sys"] as? Dictionary<String, AnyObject>, let id = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let assets = includes["Asset"] as? [Dictionary<String, AnyObject>]{
                                                
                                                for asset in assets{
                                                    if let sys = asset["sys"] as? Dictionary<String, AnyObject>, let idRef = sys["id"] as? String, idRef == id{
                                                        if let fieldAss = asset["fields"] as? Dictionary<String, AnyObject>, let file = fieldAss["file"] as? Dictionary<String, AnyObject>, let imageURL = file["url"] as? String{
                                                            imgURL = URL(string: "https:\(imageURL)")
                                                            
                                                            //If zero data yet saved in client
                                                            downloadImage(imgURL, completionHandler: { (isResponse) in
                                                                print(annID)
                                                                announcements.append(Announcements(id: "\(annID)", title: "\(fields["title"]!)", image: isResponse.0, imgURL: "\(isResponse.1)"))
                                                                myGroupCat2.leave()
                                                            })

                                                        }else {
                                                            //If no image is uploaded for this item, user default or blank
                                                            announcements.append(Announcements(id: "\(annID)", title: "\(fields["title"]!)", image: UIImage(), imgURL: ""))
                                                            myGroupCat2.leave()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                
                                myGroupCat2.notify(queue: DispatchQueue.main, execute: {
                                    print("Download complete.")
                                    
                                    for ann in announcements {
                                        
                                        self.saveAnnouncement(ann)
                                    }
                                    print("Update Check Complete.")
                                    self.setupLocationNotifications()
                                    SwiftSpinner.hide()
                                })
                            }
                            
                        }else {
                            print("No changes in ANNOUNCEMENTS detected.")
                            print("Update Check Complete.")
                            self.setupLocationNotifications()
                            SwiftSpinner.hide()
                        }
                    
                }else {
                    //DOWNLOAD FRESH
                    SwiftSpinner.show(LoadingMsgGlobal)
                    print("Downloading fresh data...")
                    if announcementsData.count == 0 {
                        for entry in data{
                            myGroupCat2.enter()
                            if let fields = entry["fields"] as? Dictionary<String, AnyObject>, let sysTop = entry["sys"] as? Dictionary<String, AnyObject>, let annID = sysTop["id"] as? String{
                                
                                if let dataURL = fields["image"] as? Dictionary<String, AnyObject>,let sysItem = dataURL["sys"] as? Dictionary<String, AnyObject>, let id = sysItem["id"] as? String, let includes = dataResult["includes"] as? Dictionary<String, AnyObject>, let assets = includes["Asset"] as? [Dictionary<String, AnyObject>]{
                                    
                                    for asset in assets{
                                        if let sys = asset["sys"] as? Dictionary<String, AnyObject>, let idRef = sys["id"] as? String, idRef == id{
                                            if let fieldAss = asset["fields"] as? Dictionary<String, AnyObject>, let file = fieldAss["file"] as? Dictionary<String, AnyObject>, let imageURL = file["url"] as? String{
                                                imgURL = URL(string: "https:\(imageURL)")
                                                //If zero data yet saved in client
                                                downloadImage(imgURL, completionHandler: { (isResponse) in
                                                    print(annID)
                                                    announcements.append(Announcements(id: "\(annID)", title: "\(fields["title"]!)", image: isResponse.0, imgURL: "\(isResponse.1)"))
                                                    myGroupCat2.leave()
                                                })
                                            }else {
                                                //If no image is uploaded for this item, user default or blank
                                                announcements.append(Announcements(id: "\(annID)", title: "\(fields["title"]!)", image: UIImage(), imgURL: ""))
                                                myGroupCat2.leave()
                                            }
                                        }
                                    }
                                }
                            }
                     
                            
                        }
                        
                        myGroupCat2.notify(queue: DispatchQueue.main, execute: {
                            
                            print("Download complete.")
             
                            for ann in announcements {
                                self.saveAnnouncement(ann)
                            }
                            print("Update Check Complete.")
                            self.setupLocationNotifications()
                            SwiftSpinner.hide()
                        })
                    }
                }
                }
            }
            
            
        }
        
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

