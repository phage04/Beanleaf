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
    
    var couponsData = [NSManagedObject]()
    var coupons = [Coupon]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coupons.count
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
            
            cell.configureCell(couponNow.title, discountTxt: couponNow.discount, validityTxt: couponNow.validity, termsTxt: couponNow.terms, special: couponNow.special)
            return cell
            
        } else {
            return UITableViewCell()
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func downloadCategories() {
        
        deleteCoreDataNil("Coupons")
      //  fetchDataFood()
        
        let myGroupCoup = dispatch_group_create()
        
        
        client.fetchEntries(["content_type": "coupon"]).1.next {
            
            self.coupons.removeAll()

            
            for entry in $0.items{
                dispatch_group_enter(myGroupCoup)
                if let data = entry.fields["image"] as? Asset{
 
                
            }
            
            dispatch_group_notify(myGroupCoup, dispatch_get_main_queue(), {
                
                
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
