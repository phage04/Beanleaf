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



class Home: UIViewController {

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
    
    var didLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        backgroundView.backgroundColor = COLOR1
        
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
        
        
        menuItem1.tintColor = COLOR2
        menuItem2.tintColor = COLOR2
        menuItem3.tintColor = COLOR2
        menuItem4.tintColor = COLOR2
        menuItem5.tintColor = COLOR2
        menuItem6.tintColor = COLOR2
        
        menuLbl1.font = UIFont(name: font1Medium, size: 14)
        menuLbl2.font = UIFont(name: font1Medium, size: 14)
        menuLbl3.font = UIFont(name: font1Medium, size: 14)
        menuLbl4.font = UIFont(name: font1Medium, size: 14)
        menuLbl5.font = UIFont(name: font1Medium, size: 14)
        menuLbl6.font = UIFont(name: font1Medium, size: 14)
        
        menuLbl1.textColor = COLOR2
        menuLbl2.textColor = COLOR2
        menuLbl3.textColor = COLOR2
        menuLbl4.textColor = COLOR2
        menuLbl5.textColor = COLOR2
        menuLbl6.textColor = COLOR2
        
        menuLbl1.text = menuLblText1
        menuLbl2.text = menuLblText2
        menuLbl3.text = menuLblText3
        menuLbl4.text = menuLblText4
        menuLbl5.text = menuLblText5
        menuLbl6.text = menuLblText6
        
        socialButton.backgroundColor = UIColor.clearColor()
        socialButton.layer.cornerRadius = 5
        socialButton.layer.borderWidth = 1
        socialButton.layer.borderColor = COLOR2.CGColor
        socialButton.setTitle(socialButtonTitle, forState: .Normal)
        socialButton.setTitleColor(COLOR2, forState: .Normal)
        socialButton.titleLabel?.font = UIFont(name: font1Regular, size: 12)
        
        

        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        

        if foodItemsData.count == 0 || categoriesData.count == 0 {
            
            SwiftSpinner.show(LoadingMsgGlobal).addTapHandler({
               
                }, subtitle: LoadingMsgTapToExit)
            didLoad = true
        }
        
        if !checkConnectivity() {
             SwiftSpinner.hide()
            showErrorAlert("Network Error", msg: "Please check your internet connection.", VC: self)
        }
        

     
        downloadCategories()

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
   
    @IBAction func menuItem1Pressed(sender: AnyObject) {
        
    }
    
    @IBAction func menuItem2Pressed(sender: AnyObject) {
    }

    @IBAction func menuItem3Pressed(sender: AnyObject) {
    }

    @IBAction func menuItem4Pressed(sender: AnyObject) {
    }
    
    @IBAction func menuItem5Pressed(sender: AnyObject) {
    }

    @IBAction func menuItem6Pressed(sender: AnyObject) {
    }
    
    func clearCoreData() {
        deleteCoreData("Category")
        deleteCoreData("FoodItem")
    }
    
    func downloadCategories() {
        
        deleteCoreDataNil("Category")
        deleteCoreDataNil("FoodItem")
        fetchDataCat()
        fetchDataFood()
        
        let myGroupCat = dispatch_group_create()
        
        
        client.fetchEntries(["content_type": "category"]).1.next {
            
            categories.removeAll()
            
            if $0.items.count < categoriesData.count {
                categoriesData.removeAll()
                foodItemsData.removeAll()
                self.clearCoreData()
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
        
        
        client.fetchEntries(["content_type": "menuItem"]).1.next {
            
            foodItems.removeAll()
            
            if $0.items.count < foodItemsData.count {
                categoriesData.removeAll()
                foodItemsData.removeAll()
                self.clearCoreData()
                print("Cleared core data.")
            }
            
            for entry in $0.items{
                dispatch_group_enter(myGroupFood)
                
                
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
                                            foodItems.append(FoodItem(cat: "\(categoryFood)", name: "\(entry.fields["itemName"]!)", desc: "\(entry.fields["itemDescription"]!)" , price: (entry.fields["price"]! as? Double)!, image: isResponse.0, imgURL: "\(isResponse.1)"))
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
                                
                               foodItems.append(FoodItem(cat: "\(categoryFood)", name: "\(entry.fields["itemName"]!)", desc: "\(entry.fields["itemDescription"]!)" , price: (entry.fields["price"]! as? Double)!, image: isResponse.0, imgURL: "\(isResponse.1)"))
                                
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
                    foodItems.append(FoodItem(cat: "\(categoryFood)", name: "\(entry.fields["itemName"]!)", desc: "\(entry.fields["itemDescription"]!)" , price: (entry.fields["price"]! as? Double)!, image: nil, imgURL: nil))
                    dispatch_group_leave(myGroupFood)
                }
                
                
                
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
                    
                    do {
                        try fetchResults.first?.managedObjectContext?.save()
                        fetchDataCat()
                        print("Updated Food: \(foodItem.name) mit preis \(foodItem.price) und \(foodItem.imgURL) ")
                        
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
                    
                    do {
                        try managedContext.save()
                        foodItemsData.append(categoryTemp)
                        print("Saved: \(foodItem.name) mit preis \(foodItem.price) und \(foodItem.imgURL) ")
                        
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

