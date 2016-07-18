    //
//  Coupons.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 11/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit
import CoreData
import Contentful
import Alamofire
import SwiftSpinner
import SideMenu

class Coupons: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var couponsData = [NSManagedObject]()
    var coupons = [Coupon]()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.Plain, target:self, action:#selector(Coupons.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:#selector(Coupons.showMenu))
        
        navigationController?.navigationBarHidden = false
  
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = COLOR2
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = COLOR1
        refreshControl.addTarget(self, action: #selector(Coupons.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        activityIndicator.color = COLOR1
        activityIndicator.hidden = true
        deleteCoreDataNil("Coupons")
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
    }
    
    func showMenu() {
        performSegueWithIdentifier("menuSegue", sender: nil)
    }
    override func viewDidAppear(animated: Bool) {
        fetchDataCoupon()
        downloadCoupons(false)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return couponsData.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //DO SOMETHING WHEN CLICKED
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("CouponCell") as? CouponCell {
         
            cell.selectionStyle = .None
            let couponNow = couponsData[indexPath.row]
            
            cell.configureCell("\(couponNow.valueForKey("title")!)", discountTxt: couponNow.valueForKey("discount")! as? Int, validityTxt: "\(couponNow.valueForKey("validity")!)", termsTxt: "\(couponNow.valueForKey("terms")!)", discType: "\(couponNow.valueForKey("discountType")!)", desc: "\(couponNow.valueForKey("descriptionInfo")!)")
            return cell
            
        } else {
            return UITableViewCell()
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func refresh(sender:AnyObject) {
       downloadCoupons(true)
    }
    
    func downloadCoupons(fromRefresh: Bool) {
        
        deleteCoreDataNil("Coupons")
        
        if checkConnectivity() {
         
            if !fromRefresh {
                activityIndicator.startAnimating()
                activityIndicator.hidden = false
            }

 
        client.fetchEntries(["content_type": "coupon"]).1.next {
            self.coupons.removeAll()
            
            let myGroupCoup = dispatch_group_create()
            
            for entry in $0.items{
                dispatch_group_enter(myGroupCoup)
                var desc: String = ""
                
                if let descTxt = entry.fields["description"] as? String {
                    desc = descTxt
                }
                
                if let date = entry.fields["validUntil"] {
                    dateFormatter.dateFormat = DATE_FULL_FORMAT
                    let dateFormatted = dateFormatter.dateFromString("\(date) 00:00:00 +0000")!
                    dateFormatter.dateFormat = DATE_FORMAT1
                    let dateDateFormattedVal = dateFormatter.stringFromDate(dateFormatted)
                    
                    
                    
                    self.coupons.append(Coupon(titleTxt: "\(entry.fields["title"]!)", discountTxt: (entry.fields["discountValue"]! as? Int)!, validityTxt: dateDateFormattedVal, termsTxt: "\(entry.fields["termsConditions"] as! String)", discType: "\(entry.fields["discountType"]!)", subtitle: desc))
                    
                    dispatch_group_leave(myGroupCoup)
                   
                } else {
                    
                    
                    self.coupons.append(Coupon(titleTxt: "\(entry.fields["title"]!)", discountTxt: (entry.fields["discountValue"]! as? Int)!, validityTxt: nil, termsTxt: "\(entry.fields["termsConditions"] as! String)", discType: "\(entry.fields["discountType"]!)", subtitle: desc))
                    
                    dispatch_group_leave(myGroupCoup)
                    
                }     
                
            }
            
            dispatch_group_notify(myGroupCoup, dispatch_get_main_queue(), {
                
                deleteCoreData("Coupons")
                self.couponsData.removeAll()
                for each in self.coupons {
                    self.saveCoupon(each)
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            })
           
           
            
        }
        
        }
    
    }
    
    func saveCoupon(coupon: Coupon) {
        let appDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Coupons", inManagedObjectContext:managedContext)
        let couponTemp = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        couponTemp.setValue(coupon.title, forKey: "title")
        couponTemp.setValue(coupon.discountType, forKey: "discountType")
        couponTemp.setValue(coupon.discount, forKey: "discount")
        couponTemp.setValue(coupon.subtitle, forKey: "descriptionInfo")
        couponTemp.setValue(coupon.terms, forKey: "terms")
        couponTemp.setValue(coupon.validity, forKey: "validity")
        
        do {
            try managedContext.save()
            couponsData.append(couponTemp)
            print("Saved: \(coupon.title) mit discount \(coupon.discount)")
            
        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
  
        
        
    }
    
    func fetchDataCoupon() {
        couponsData.removeAll()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Coupons")
        fetchRequest.predicate = NSPredicate(format: "title != %@", "")
        
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            
            couponsData = results as! [NSManagedObject]
            self.tableView.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func deleteCoreDataNil(entity: String) {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "title == %@", "")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.executeRequest(deleteRequest, withContext: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }

    
    func backButtonPressed(sender:UIButton) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
}
