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

class Coupons: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var couponsData = [NSManagedObject]()
    var coupons = [Coupon]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.Plain, target:self, action:#selector(Coupons.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:nil)
  
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = COLOR2
        activityIndicator.color = COLOR1
        
        downloadCoupons()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.coupons.count
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
            let couponNow = coupons[indexPath.row]
            
            cell.configureCell(couponNow.title, discountTxt: couponNow.discount, validityTxt: couponNow.validity, termsTxt: couponNow.terms, discType: couponNow.discountType, desc: couponNow.subtitle)
            return cell
            
        } else {
            return UITableViewCell()
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func downloadCoupons() {
        
        
        // Add star image
        // create other promo types
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        
        
        
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
                    self.tableView.reloadData()
                    dispatch_group_leave(myGroupCoup)
                    
                }     
                
            }
            
            dispatch_group_notify(myGroupCoup, dispatch_get_main_queue(), {
                
                for each in self.coupons {
                    self.saveCoupon(each)
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.tableView.reloadData()
            })
           
           
            
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
            foodItemsData.append(couponTemp)
            print("Saved: \(coupon.title) mit discount \(coupon.discount)")
            
        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
  
        
        
    }

    
    func backButtonPressed(sender:UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
