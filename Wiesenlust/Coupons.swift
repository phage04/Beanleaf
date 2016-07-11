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
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.Plain, target:self, action:#selector(Coupons.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:nil)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = COLOR2
        downloadCoupons()
        
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
            
            cell.configureCell(couponNow.title, discountTxt: couponNow.discount, validityTxt: couponNow.validity, termsTxt: couponNow.terms, discType: couponNow.discountType)
            return cell
            
        } else {
            return UITableViewCell()
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func downloadCoupons() {
        
        
        
        //ADD THREADING for refresh
        // Add star image
        // create other promo types
        
        
        client.fetchEntries(["content_type": "coupon"]).1.next {
            self.coupons.removeAll()
            
            for entry in $0.items{
                
                if let date = entry.fields["validUntil"] {
                    dateFormatter.dateFormat = DATE_FULL_FORMAT
                    let dateFormatted = dateFormatter.dateFromString("\(date) 00:00:00 +0000")!
                    dateFormatter.dateFormat = DATE_FORMAT1
                    let dateDateFormattedVal = dateFormatter.stringFromDate(dateFormatted)
                    
                    
                    
                    self.coupons.append(Coupon(titleTxt: "\(entry.fields["title"]!)", discountTxt: "\(entry.fields["discountValue"]!)", validityTxt: dateDateFormattedVal, termsTxt: "\(entry.fields["termsConditions"] as! String)", discType: "\(entry.fields["discountType"]!)"))
                } else {
                    self.coupons.append(Coupon(titleTxt: "\(entry.fields["title"]!)", discountTxt: "\(entry.fields["discountValue"]!)", validityTxt: nil, termsTxt: "\(entry.fields["termsConditions"] as! String)", discType: "\(entry.fields["discountType"]!)"))
                }
                
                
                
                
            }
            self.tableView.reloadData()
            
        }
        
        
    
    }
    
    func backButtonPressed(sender:UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
