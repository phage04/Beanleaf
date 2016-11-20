    //
//  Coupons.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 11/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit
import CoreData
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
        
        navigationItem.backBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.plain, target:self, action:#selector(Coupons.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.plain, target:self, action:#selector(Coupons.showMenu))
        
        navigationController?.isNavigationBarHidden = false
  
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = COLOR1
        refreshControl.addTarget(self, action: #selector(Coupons.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        activityIndicator.color = COLOR1
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func showMenu() {
        performSegue(withIdentifier: "menuSegue", sender: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchDataCoupon()
        downloadCoupons(false)
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return couponsData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let couponSelected = couponsData[(indexPath as NSIndexPath).row].value(forKey: "couponRef"), let flagLoc = couponsData[(indexPath as NSIndexPath).row].value(forKey: "locFlag") as? Bool{
            showCoupon("\(couponSelected)", locationEnabled: flagLoc)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell") as? CouponCell {
         
            cell.selectionStyle = .none
            cell.backgroundColor = cell.contentView.backgroundColor
            let couponNow = couponsData[(indexPath as NSIndexPath).row]
            
            cell.configureCell("\(couponNow.value(forKey: "title")!)", discountTxt: couponNow.value(forKey: "discount")! as? Int, validityTxt: "\(couponNow.value(forKey: "validity")!)", termsTxt: "\(couponNow.value(forKey: "terms")!)", discType: "\(couponNow.value(forKey: "discountType")!)", desc: "\(couponNow.value(forKey: "descriptionInfo")!)", locFlag: (couponNow.value(forKey: "locFlag") as? Bool)!)
            return cell
            
        } else {
            return UITableViewCell()
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func refresh(_ sender:AnyObject) {
       downloadCoupons(true)
    }
    
    func downloadCoupons(_ fromRefresh: Bool) {
        
        deleteCoreDataNil("Coupons")
        
        if checkConnectivity() {
         
            if !fromRefresh {
                activityIndicator.startAnimating()
                activityIndicator.isHidden = false
            }

           //CONTENTFULTHING
        Alamofire.request("https://cdn.contentful.com/spaces/\(CFSpaceId)/entries?access_token=\(CFTokenProduction)&content_type=coupon").responseJSON { (result) in
                
            if let dataResult = result.result.value as? Dictionary<String, AnyObject>{
                    
                    if let items = dataResult["items"] as? [Dictionary<String, AnyObject>]{
                        self.coupons.removeAll()
                        
                        let myGroupCoup = DispatchGroup()
                        let myGroupCoup2 = DispatchGroup()
                        
                        for entry in items{
                            myGroupCoup.enter()
                           
                            var desc: String = ""
                            var locationFlag: Bool = false
                            
                            if let fields = entry["fields"] as? Dictionary<String, AnyObject>, let sysTop = entry["sys"] as? Dictionary<String, AnyObject>, let coupID = sysTop["id"] as? String{
                                
                                if let descTxt = fields["description"] as? String {
                                    desc = descTxt
                                }
                                
                                if let locVal = fields["locationCoupon"] as? Bool , locVal == true{
                                    locationFlag = locVal
                                }
                                
                                if let date = fields["validUntil"] as? String {
                                    
                                    let endOfDomain = date.index(date.startIndex, offsetBy: 10)
                                    let rangeOfDomain = date.startIndex ..< endOfDomain
                    
                                    dateFormatter.dateFormat = DATE_FULL_FORMAT
                                    let dateFormatted = dateFormatter.date(from: "\(date[rangeOfDomain]) 00:00:00 +0000")!
                                    dateFormatter.dateFormat = DATE_FORMAT1
                                    let dateDateFormattedVal = dateFormatter.string(from: dateFormatted)
                                    
                                    
                                    
                                    self.coupons.append(Coupon(titleTxt: "\(fields["title"]!)", discountTxt: (fields["discountValue"]! as? Int)!, validityTxt: dateDateFormattedVal, termsTxt: "\(fields["termsConditions"] as! String)", discType: "\(fields["discountType"]!)", subtitle: desc, identifier: "\(coupID)", uses: (fields["usesAllowedPerPerson"] as? Int)!, location: locationFlag))
                                    
                                    myGroupCoup.leave()
                                    
                                } else {
                                    
                                    
                                    self.coupons.append(Coupon(titleTxt: "\(fields["title"]!)", discountTxt: (fields["discountValue"]! as? Int)!, validityTxt: nil, termsTxt: "\(fields["termsConditions"] as! String)", discType: "\(fields["discountType"]!)", subtitle: desc, identifier: "\(coupID)", uses: (fields["usesAllowedPerPerson"] as? Int)!, location: locationFlag))
                                    
                                    myGroupCoup.leave()
                                    
                                }
                            }
                            
                           
                            
                        }
                        
                         myGroupCoup2.notify(queue: DispatchQueue.main, execute: {
                            
                            
                            deleteCoreData("Coupons")
                            self.couponsData.removeAll()
                            
                            for each in self.coupons {
                                myGroupCoup2.enter()
                                DataService.ds.REF_COUPONUSES.child("\(UserDefaults.standard.value(forKey: "userId")!)/\(each.couponRef)").observeSingleEvent(of: .value, with: { (snapshot) in
                                    
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
                                            
                                            
                                            
                                            myGroupCoup2.leave()
                                            
                                            
                                            
                                        }
                                        
                                    } else {
                                        if each.location == true && validForLocationOffer == true {
                                            print("SAVED LOCATION COUPON.")
                                            self.saveCoupon(each)
                                        } else if each.location == false {
                                            self.saveCoupon(each)
                                        }
                                        
                                        myGroupCoup2.leave()
                                        
                                    }
                                    
                                })
                                
                            }
                             myGroupCoup2.notify(queue: DispatchQueue.main, execute: {
                                self.tableView.allowsSelection = true
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                                self.refreshControl.endRefreshing()
                                self.tableView.reloadData()
                            })
                        })
                    }
            }
        }
           
        }
    
    }
    
    func saveCoupon(_ coupon: Coupon) {
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "Coupons", in:managedContext)
        let couponTemp = NSManagedObject(entity: entity!, insertInto: managedContext)
        
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Coupons")
        fetchRequest.predicate = NSPredicate(format: "title != %@", "")
        
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            
            couponsData = results as! [NSManagedObject]
            self.tableView.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func deleteCoreDataNil(_ entity: String) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "\(entity)")
        fetchRequest.predicate = NSPredicate(format: "title == %@", "")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }

    
    func backButtonPressed(_ sender:UIButton) {
       _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        long = userLocation.coordinate.longitude
        lat = userLocation.coordinate.latitude
        
    }

    func checkIfWithinVicinity(_ distance: Int, completion: @escaping (_ result: Bool) -> Void) {
        var index = 0
        self.claimValid = false  
            for loc in branches {
                let geoCoder = CLGeocoder()
                
                geoCoder.geocodeAddressString(loc, completionHandler: { (placemarks, error) in
                    
                    if let placeMark = placemarks?[0] {
                        index += 1
                        if let _ = placeMark.location {
                            
                            if let dist = self.locationManager.location?.distance(from: placeMark.location!) , distance > Int(dist)  {
                                
                                print(dist)
                                self.claimValid = true
                                completion(self.claimValid)
                                
                                
                            } else if index == branches.count && self.claimValid == false {
                                completion(false)
                            }
                        }
                        }
                    
                })
            }
            

        
        
    }
    
    func showCoupon(_ ref: String, locationEnabled: Bool) {
        let alertController = UIAlertController(title: "Manager PIN Required", message: "Have the manager enter the PIN to claim this deal.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields![0] as? UITextField{
                field.resignFirstResponder()
                if field.text == "\(managerPin!)" {
                    let couponCode = randomStringWithLength(6)
                    
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.isHidden = false
                    self.tableView.allowsSelection = false
                    self.checkIfWithinVicinity(distanceToClaim, completion: { (result) in
                        if result {
                            
                            if let _ = self.long as Double?, let _ = self.lat as Double? {
                                
                                    DataService.ds.REF_COUPONUSES.updateChildValues(["\(UserDefaults.standard.value(forKey: "userId")!)/\(ref)/\(couponCode)/long": self.long, "\(UserDefaults.standard.value(forKey: "userId")!)/\(ref)/\(couponCode)/lat": self.lat], withCompletionBlock: { (error, FIRDatabaseReference) in

                                        if error == nil {
                   
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.dateFormat = "MM-dd-yyyy"
                                            dateFormatter.timeZone = TimeZone(identifier: "GMT+8")
                                            let dateString = dateFormatter.string(from: Date())
                                            
                                            DataService.ds.REF_COUPONREPORT.updateChildValues(["\(dateString)/\(ref)/\(couponCode)/\(UserDefaults.standard.value(forKey: "userId")!)": "Long: \(self.long) Lat: \(self.lat) "], withCompletionBlock: { (error, FIRDatabaseReference) in
                                                
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.isHidden = true
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
                                            self.activityIndicator.isHidden = true
                                            self.tableView.allowsSelection = true
                                            showErrorAlert("An Error Occured", msg: "Please try again later.", VC: self)
                                        }
                                        
                                        
                                    })
                                    
                                
                                
                            }
                        } else {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showErrorAlertWithAction(_ title: String, msg: String, VC: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) {(_) in
            self.tableView.allowsSelection = false
            self.downloadCoupons(true)
        }
        alert.addAction(action)
        
        VC.present(alert, animated: true, completion: nil)
        
    }
}
