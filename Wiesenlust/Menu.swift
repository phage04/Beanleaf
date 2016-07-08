//
//  Menu.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 05/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit
import CoreData
import Auk
import moa
import Contentful
import Alamofire
import SwiftSpinner



class Menu: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categoriesData = [NSManagedObject]()
    var categories = [Category]()

    var imgURL: NSURL!
    static var imageCache = NSCache()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if checkConnectivity() {
            deleteCoreData("Category")
            deleteCoreDataNil("Category")
            SwiftSpinner.show(LoadingMsgGlobal).addTapHandler({
                SwiftSpinner.hide()
                }, subtitle: LoadingMsgTapToExit)
            
            downloadCategories()
            
            
        } else {
            showErrorAlert("Network Error", msg: "Please check your internet connection.", VC: self)
        }

        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.Plain, target:self, action:#selector(Menu.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:nil)
        
        scrollView.delegate = self
        scrollView.auk.settings.contentMode = .ScaleAspectFill
        scrollView.auk.settings.pageControl.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.30)
        scrollView.auk.settings.pageControl.marginToScrollViewBottom = 4.0
        scrollView.auk.settings.pageControl.pageIndicatorTintColor = COLOR2
        scrollView.auk.settings.pageControl.currentPageIndicatorTintColor = COLOR1
        
        scrollView.auk.show(url: "http://eblogfa.com/wp-content/uploads/2014/01/burger-chesseburger-fastfood.jpg")
        scrollView.auk.show(url: "http://robertsboxedmeats.ca/wp-content/uploads/2011/07/TGIF_Stacked-Burger-LR-1.jpg")
        scrollView.auk.show(url: "http://eatburgerburger.com/wp-content/uploads/2016/01/burger-slide-1.jpg")
        scrollView.auk.startAutoScroll(delaySeconds: 2)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.collectionViewLayout = CustomImageFlowLayout.init()
        self.collectionView.backgroundColor = COLOR1
        mainView.backgroundColor = COLOR1
        
        
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
     collectionView.collectionViewLayout.invalidateLayout()    
    }
    
    func downloadCategories() {
        
        fetchCategories()
    
        let myGroupCat = dispatch_group_create()
        
        
        client.fetchEntries(["content_type": "category"]).1.next {
            
            self.categories.removeAll()
            
            for entry in $0.items{
                dispatch_group_enter(myGroupCat)
                if let data = entry.fields["image"] as? Asset{
                 
                    do {
                        self.imgURL = try data.URL()
                        //CHECKING FOR UPDATES FROM SERVER, SKIP IF STILL UPDATED
                        if self.categoriesData.count > 0 {
                            
                            for item in self.categoriesData {
        
                                if let _ = item.valueForKey("name"), _ = entry.fields["categoryName"] where "\(item.valueForKey("name"))" == "\(entry.fields["categoryName"])" {
                                    
             
                                    if let _ = item.valueForKey("imageURL"), _ = self.imgURL, _ = item.valueForKey("order"), _ = entry.fields["order"] where "\(item.valueForKey("imageURL")!)" != "\(self.imgURL)" ||
                                        "\(item.valueForKey("order")!)" != "\(entry.fields["order"]!)" {
                                        
                                        print("Did detect change")
                                    
                                    //If data in client is not updated
                                    
                                        dispatch_group_enter(myGroupCat)
      
                                        self.downloadImage(self.imgURL, completionHandler: { (isResponse) in
                                           
                                            print("Did download the update")
                                            self.categories.append(Category(name: "\(entry.fields["categoryName"]!)", order: Int("\(entry.fields["order"]!)")!, image: isResponse.0, imgURL: "\(isResponse.1)"))
                                            dispatch_group_leave(myGroupCat)
                                            
                                        })
                                    }
                                }
               
                            }
                            
                            dispatch_group_leave(myGroupCat)
                        }
                        
                        else if self.categoriesData.count == 0{
                            //If zero data yet saved in client
                            self.downloadImage(self.imgURL, completionHandler: { (isResponse) in
                                
                                self.categories.append(Category(name: "\(entry.fields["categoryName"]!)", order: Int("\(entry.fields["order"]!)")!, image: isResponse.0, imgURL: "\(isResponse.1)"))
                              dispatch_group_leave(myGroupCat)
                            })
                        }
            
                        
                    } catch {
                        print("Error Code: FJ3D85")
                        dispatch_group_leave(myGroupCat)
                    }
                    
                } else {
                    //If no image is uploaded for this item, user default or blank
                    self.categories.append(Category(name: "\(entry.fields["categoryName"]!)", order: Int("\(entry.fields["order"]!)")!, image: UIImage(), imgURL: ""))
                    dispatch_group_leave(myGroupCat)
                }
                

                
            }
            
            dispatch_group_notify(myGroupCat, dispatch_get_main_queue(), {
  
                
                    self.categories.sortInPlace({ $0.order < $1.order })
                    
                    for cat in self.categories {
                        self.saveCategory(cat)
                    }
                
                    self.collectionView.reloadData()
                    SwiftSpinner.hide()
            })


        }
        

    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.collectionView.reloadData()
    }
    
    func downloadImage(URL: NSURL, completionHandler : ((isResponse : (UIImage, String)) -> Void)) {
        
        
        if checkConnectivity(){
            var imgData: UIImage!
            let myGroupImg = dispatch_group_create()
            dispatch_group_enter(myGroupImg)
            
            Alamofire.request(.GET, URL).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                
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
        } else {
            showErrorAlert("Network Error", msg: "Please check your internet connection.", VC: self)
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
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    func deleteCoreDataNil(entity: String) {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "name == %@", "")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.executeRequest(deleteRequest, withContext: context)
        } catch let error as NSError {
            debugPrint(error)
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
                        fetchCategories()
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
    
    func fetchCategories () {
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesData.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let catItem = categoriesData[indexPath.row]
        
        performSegueWithIdentifier("categorySegue", sender: catItem.valueForKey("name"))
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MenuCategoryCell", forIndexPath: indexPath) as? MenuCategoryCell {

            let catItem = categoriesData[indexPath.row]
            
            cell.configureCell("\(catItem.valueForKey("name")!)", imgData: catItem.valueForKey("image") as! NSData)
    
            return cell
        } else {
            
            return UICollectionViewCell()
            
        }
    }
    
    func backButtonPressed(sender:UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "categorySegue" {
            if let selectedCategory = segue.destinationViewController as? CategoryView{
                if let catSelect = sender as? String {
                    selectedCategory.categorySelected = catSelect
                }
            }
        }
    }

}
