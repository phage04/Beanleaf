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
import Firebase
import FirebaseDatabase
import CoreLocation

class Coupons: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var couponsData = [NSManagedObject]()
    var couponsFilter = [NSManagedObject]()
    var coupons = [Coupon]()
    var refreshControl: UIRefreshControl!
    let locationManager = CLLocationManager()
    var lat: Double = 0.0
    var long: Double = 0.0
    var claimValid = false
    
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
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidden = false
        deleteCoreDataNil("Coupons")
        
        self.locationManager.requestAlwaysAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            
        }
        
        locationManager.startUpdatingLocation()
        
        tableView.allowsSelection = false
        
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
        if let couponSelected = couponsData[indexPath.row].valueForKey("couponRef"), flagLoc = couponsData[indexPath.row].valueForKey("locFlag") as? Bool{
            showCoupon("\(couponSelected)", locationEnabled: flagLoc)
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("CouponCell") as? CouponCell {
         
            cell.selectionStyle = .None
            let couponNow = couponsData[indexPath.row]
            
            cell.configureCell("\(couponNow.valueForKey("title")!)", discountTxt: couponNow.valueForKey("discount")! as? Int, validityTxt: "\(couponNow.valueForKey("validity")!)", termsTxt: "\(couponNow.valueForKey("terms")!)", discType: "\(couponNow.valueForKey("discountType")!)", desc: "\(couponNow.valueForKey("descriptionInfo")!)", locFlag: (couponNow.valueForKey("locFlag") as? Bool)!)
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
            let myGroupCoup2 = dispatch_group_create()
            
            for entry in $0.items{
                dispatch_group_enter(myGroupCoup)
                var desc: String = ""
                var locationFlag: Bool = false
                
                if let descTxt = entry.fields["description"] as? String {
                    desc = descTxt
                }
                
                if let locVal = entry.fields["locationCoupon"] as? Bool where locVal == true{
                    locationFlag = locVal
                }
                
                if let date = entry.fields["validUntil"] {
                    dateFormatter.dateFormat = DATE_FULL_FORMAT
                    let dateFormatted = dateFormatter.dateFromString("\(date) 00:00:00 +0000")!
                    dateFormatter.dateFormat = DATE_FORMAT1
                    let dateDateFormattedVal = dateFormatter.stringFromDate(dateFormatted)
                    
                    
                    
                    self.coupons.append(Coupon(titleTxt: "\(entry.fields["title"]!)", discountTxt: (entry.fields["discountValue"]! as? Int)!, validityTxt: dateDateFormattedVal, termsTxt: "\(entry.fields["termsConditions"] as! String)", discType: "\(entry.fields["discountType"]!)", subtitle: desc, identifier: "\(entry.identifier)", uses: (entry.fields["usesAllowedPerPerson"] as? Int)!, location: locationFlag))
                    
                    dispatch_group_leave(myGroupCoup)
                   
                } else {
                    
                    
                    self.coupons.append(Coupon(titleTxt: "\(entry.fields["title"]!)", discountTxt: (entry.fields["discountValue"]! as? Int)!, validityTxt: nil, termsTxt: "\(entry.fields["termsConditions"] as! String)", discType: "\(entry.fields["discountType"]!)", subtitle: desc, identifier: "\(entry.identifier)", uses: (entry.fields["usesAllowedPerPerson"] as? Int)!, location: locationFlag))
                    
                    dispatch_group_leave(myGroupCoup)
                    
                }     
                
            }
            
            dispatch_group_notify(myGroupCoup, dispatch_get_main_queue(), {
                
                
                deleteCoreData("Coupons")
                self.couponsData.removeAll()
                
                for each in self.coupons {
                    dispatch_group_enter(myGroupCoup2)
                    DataService.ds.REF_COUPONUSES.child("\(NSUserDefaults.standardUserDefaults().valueForKey("userId")!)/\(each.couponRef)").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        
                        if snapshot.exists() {
                            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                
                                if each.location == false {
                                    if snapshots.count >= each.couponUses && each.couponUses > 0 {
                                        print("EXCLUDED CouponID: \(each.couponRef) User Count: \(snapshots.count) User Limit: \(each.couponUses)")
                                    } else if snapshots.count < each.couponUses || each.couponUses == 0{
                                        print("SAVED CouponID: \(each.couponRef) User Count: \(snapshots.count) User Limit: \(each.couponUses)")
                                        self.saveCoupon(each)
                                    }
                                } else if each.location == true && validForLocationOffer == true {
                                    print("SAVED LOC COUPON CouponID: \(each.couponRef) User Count: \(snapshots.count) User Limit: \(each.couponUses)")
                                    self.saveCoupon(each)
                                }
                               
                                
                                
                                dispatch_group_leave(myGroupCoup2)
                                
                                
                                
                            }

                        } else {
                            if each.location == true && validForLocationOffer == true {
                                print("SAVED LOCATION COUPON.")
                                self.saveCoupon(each)
                            } else if each.location == false {
                                self.saveCoupon(each)
                            }
                            
                            dispatch_group_leave(myGroupCoup2)
                           
                        }
                        
                    })
                    
                }
                dispatch_group_notify(myGroupCoup2, dispatch_get_main_queue(), {
                    self.tableView.allowsSelection = true
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                })
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
        couponTemp.setValue(coupon.couponRef, forKey: "couponRef")
        couponTemp.setValue(coupon.couponUses, forKey: "couponUses")
        couponTemp.setValue(coupon.location, forKey: "locFlag")
        
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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        long = userLocation.coordinate.longitude
        lat = userLocation.coordinate.latitude
        
    }

    func checkIfWithinVicinity(distance: Int, completion: (result: Bool) -> Void) {
        var index = 0
        self.claimValid = false  
            for loc in branches {
                let geoCoder = CLGeocoder()
                
                geoCoder.geocodeAddressString(loc, completionHandler: { (placemarks, error) in
                    
                    if let placeMark = placemarks?[0] {
                        index += 1
                        if let _ = placeMark.location {
                            
                            if let dist = self.locationManager.location?.distanceFromLocation(placeMark.location!) where distance > Int(dist)  {
                                
                                print(dist)
                                self.claimValid = true
                                completion(result: self.claimValid)
                                
                                
                            } else if index == branches.count && self.claimValid == false {
                                completion(result: false)
                            }
                        }
                        }
                    
                })
            }
            

        
        
    }
    
    func showCoupon(ref: String, locationEnabled: Bool) {
        let alertController = UIAlertController(title: "Manager PIN Required", message: "Have the manager enter the PIN to claim this deal.", preferredStyle: .Alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (_) in
            if let field = alertController.textFields![0] as? UITextField{
                field.resignFirstResponder()
                if field.text == "\(managerPin!)" {
                    let couponCode = randomStringWithLength(6)
                    
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.hidden = false
                    self.tableView.allowsSelection = false
                    self.checkIfWithinVicinity(distanceToClaim, completion: { (result) in
                        if result {
                            
                            if let _ = self.long as Double?, _ = self.lat as Double? {
                                
                                    DataService.ds.REF_COUPONUSES.updateChildValues(["\(NSUserDefaults.standardUserDefaults().valueForKey("userId")!)/\(ref)/\(couponCode)/long": self.long, "\(NSUserDefaults.standardUserDefaults().valueForKey("userId")!)/\(ref)/\(couponCode)/lat": self.lat], withCompletionBlock: { (error, FIRDatabaseReference) in

                                        if error == nil {
                   
                                            let dateFormatter = NSDateFormatter()
                                            dateFormatter.dateFormat = "MM-dd-yyyy"
                                            dateFormatter.timeZone = NSTimeZone(name: "GMT+8")
                                            let dateString = dateFormatter.stringFromDate(NSDate())
                                            
                                            DataService.ds.REF_COUPONREPORT.updateChildValues(["\(dateString)/\(ref)/\(couponCode)/\(NSUserDefaults.standardUserDefaults().valueForKey("userId")!)": "Long: \(self.long) Lat: \(self.lat) "], withCompletionBlock: { (error, FIRDatabaseReference) in
                                                
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.hidden = true
                                                self.tableView.allowsSelection = true
                                                
                                                if error == nil {
                                                    
                                                    if locationEnabled == true {
                                                        validForLocationOffer = false
                                                    }
                                                    
                                                     self.showErrorAlertWithAction("Coupon Code: \(couponCode)", msg: "To the Manager: Please keep this code on record.", VC: self)
                                                } else {
                                        
                                                    showErrorAlert("An Error Occured", msg: "Please try again later.", VC: self)
                                                }
                                               
                                            })
                    
                                            
                       
                                        } else {
                                            self.activityIndicator.stopAnimating()
                                            self.activityIndicator.hidden = true
                                            self.tableView.allowsSelection = true
                                            showErrorAlert("An Error Occured", msg: "Please try again later.", VC: self)
                                        }
                                        
                                        
                                    })
                                    
                                
                                
                            }
                        } else {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.hidden = true
                            showErrorAlert("You're Too Far Away", msg: "Please come closer to our branch.", VC: self)
                        }
                        
                    })
                   
                    
                    
                } else {
                    showErrorAlert("Incorrect PIN", msg: "", VC: self)
                }
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.keyboardType = .NumberPad
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func showErrorAlertWithAction(title: String, msg: String, VC: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default) {(_) in
            self.tableView.allowsSelection = false
            self.downloadCoupons(true)
        }
        alert.addAction(action)
        
        VC.presentViewController(alert, animated: true, completion: nil)
        
    }
}
