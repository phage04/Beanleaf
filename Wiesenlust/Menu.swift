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
        
        
        //deleteIncidents()
        downloadCategories()
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
                       
                                if item.valueForKey("name")! as? String == "\(entry.fields["categoryName"]!)" {
                                    print(item.valueForKey("name")!)
                                    print("\(entry.fields["categoryName"]!)")
                                    print((item.valueForKey("imageURL")!))
                                    print("\(self.imgURL)")
                                    print(item.valueForKey("order")!)
                                    print("\(entry.fields["order"]!)")
             
                                    if "\(item.valueForKey("imageURL")!)" != "\(self.imgURL)" ||
                                        "\(item.valueForKey("order")!)" != "\(entry.fields["order"]!)" {
                                    
                                    //If data in client is not updated
                                    
                                        dispatch_group_enter(myGroupCat)
      
                                        self.downloadImage(self.imgURL, completionHandler: { (isResponse) in
                                            
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
  
                
                    print("Finished downloading and updating category images.")
                    self.categories.sortInPlace({ $0.order < $1.order })
                    
                    for cat in self.categories {
                        self.saveCategory(cat)
                    }
                
                    self.collectionView.reloadData()
            })


        }
        

    }
    
    func downloadImage(URL: NSURL, completionHandler : ((isResponse : (UIImage, String)) -> Void)) {
        
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
    }
    
    func deleteIncidents() {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest(entityName: "Category")
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
        
        categoryTemp.setValue(category.name, forKey: "name")
        categoryTemp.setValue(category.order, forKey: "order")
        categoryTemp.setValue(category.img, forKey: "image")
        categoryTemp.setValue(category.imgURL, forKey: "imageURL")
        
   
        do {
            try managedContext.save()
            categoriesData.append(categoryTemp)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func fetchCategories () {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Category")
        
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
