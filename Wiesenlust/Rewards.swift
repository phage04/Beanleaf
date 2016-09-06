//
//  Loyalty.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 12/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit
import SideMenu
import CoreLocation
import Firebase
class Rewards: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var topLbl: UILabel!
    
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star6: UIImageView!
    @IBOutlet weak var star7: UIImageView!
    @IBOutlet weak var star8: UIImageView!
    @IBOutlet weak var star9: UIImageView!
    @IBOutlet weak var star10: UIImageView!
    @IBOutlet weak var star11: UIImageView!
    @IBOutlet weak var star12: UIImageView!
    
    @IBOutlet weak var gift1: UILabel!
    @IBOutlet weak var gift2: UILabel!
    @IBOutlet weak var gift3: UILabel!
    @IBOutlet weak var gift4: UILabel!
    @IBOutlet weak var gift5: UILabel!
    @IBOutlet weak var gift6: UILabel!
    @IBOutlet weak var gift7: UILabel!
    @IBOutlet weak var gift8: UILabel!
    @IBOutlet weak var gift9: UILabel!
    @IBOutlet weak var gift10: UILabel!
    @IBOutlet weak var gift11: UILabel!
    @IBOutlet weak var gift12: UILabel!
    
    @IBOutlet weak var bottomLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var numberOfStamps: Int = 0
    var numberOfClaims: Int = 0
    let locationManager = CLLocationManager()
    var lat: Double = 0.0
    var long: Double = 0.0
    var claimValid = false
    var firstLoad = true
    let maxRewards = 6
    let maxStamps = 12
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topLbl.font = UIFont(name: font1Regular, size: 17)
        topLbl.textColor = COLOR2
        topLbl.text = "Earn stamps and redeem a free item as you collect!"
        
        bottomLbl.font = UIFont(name: font1Regular, size: 14)
        bottomLbl.textColor = COLOR2
        bottomLbl.text = "For every transaction with minimum amount of \(minimumReceipt), earn one stamp. Uninstalling \(storeName) will cause stamps to be lost."
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.Plain, target:self, action:#selector(Rewards.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:#selector(Rewards.showMenu))
        
        navigationController?.navigationBarHidden = false

        topLbl.hidden = false
        bottomLbl.hidden = false
        
        activityIndicator.color = COLOR1
        activityIndicator.hidden = true
        
        gift1.text = ""
        gift2.text = ""
        gift3.text = ""
        gift4.text = ""
        gift5.text = ""
        gift6.text = ""
        gift7.text = ""
        gift8.text = ""
        gift9.text = ""
        gift10.text = ""
        gift11.text = ""
        gift12.text = ""
        
        numberOfStamps = NSUserDefaults.standardUserDefaults().integerForKey("numberOfStamps")
        numberOfClaims = NSUserDefaults.standardUserDefaults().integerForKey("claims")
        updateStamps(numberOfStamps)
        updateClaim()
        
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            
        }
        
        locationManager.startUpdatingLocation()

        
        
    }
    

    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false

    }
    
    override func viewDidAppear(animated: Bool) {
        
            downloadFreeItems({ (result) in
                print("Free items downloaded.")
                self.gift1.text = freeItems[0]
                self.gift2.text = ""
                self.gift3.text = freeItems[1]
                self.gift4.text = ""
                self.gift5.text = ""
                self.gift6.text = freeItems[2]
                self.gift7.text = ""
                self.gift8.text = freeItems[3]
                self.gift9.text = ""
                self.gift10.text = freeItems[4]
                self.gift11.text = ""
                self.gift12.text = freeItems[5]
            })
    }
    
    
    func showMenu() {
        performSegueWithIdentifier("menuSegue", sender: nil)
    }
    
    func needMoreStamps(){
        self.removeClaims()
        showErrorAlert("Insufficient Stamps", msg: "The customer need more stamps to claim the next reward.", VC: self)
    }
    
    
    func logTransaction(refLvl: Int, firstLoadVal: Bool, completion: (result: Bool) -> Void) {
      
        if firstLoadVal && self.numberOfClaims == 0 {
            self.firstLoad = false
            completion(result: true)
        } else {
      
            DataService.ds.REF_REWARDCLAIMS.child("\(NSUserDefaults.standardUserDefaults().valueForKey("userId")!)/\(refLvl)").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss xxxx"
                dateFormatter.timeZone = NSTimeZone(name: "GMT+8")
                let dateString = dateFormatter.stringFromDate(NSDate())
                
                if snapshot.value is NSNull && self.numberOfClaims > 0 {
                    DataService.ds.REF_REWARDCLAIMS.updateChildValues(["\(NSUserDefaults.standardUserDefaults().valueForKey("userId")!)/\(refLvl)/\(dateString)/long": self.long, "\(NSUserDefaults.standardUserDefaults().valueForKey("userId")!)/\(refLvl)/\(dateString)/lat": self.lat], withCompletionBlock: { (error, FIRDatabaseReference) in
                        
                        if error == nil {
                            completion(result: true)
                        } else {
                            self.removeClaims()
                            completion(result: false)
                        }
                    })
                } else {
                    completion(result: true)
                }
            })

        }
        
        
    }
    
    func addClaims(){
        self.numberOfClaims = NSUserDefaults.standardUserDefaults().integerForKey("claims") + 1
        
        NSUserDefaults.standardUserDefaults().setInteger(self.numberOfClaims, forKey: "claims")
        
        self.numberOfClaims = NSUserDefaults.standardUserDefaults().integerForKey("claims")
    }

    func removeClaims(){
        self.numberOfClaims = NSUserDefaults.standardUserDefaults().integerForKey("claims") - 1
        
        NSUserDefaults.standardUserDefaults().setInteger(self.numberOfClaims, forKey: "claims")
        
        self.numberOfClaims = NSUserDefaults.standardUserDefaults().integerForKey("claims")
    }

    func updateClaim(){
 
        switch numberOfClaims {
        case maxRewards-5:
            if numberOfStamps >= 1 {
          
                logTransaction(numberOfClaims, firstLoadVal: self.firstLoad, completion: { (result) in
                    if result {
                        self.star1.tintColor = UIColor.greenColor()
                        
                    } else {
                        
                        self.showErrorAlert("Network Error", msg: "Please check your internet connection and try again.", VC: self)
                    }
                })
                
            } else {
                self.needMoreStamps()
            }
 
        case maxRewards-4:
            if numberOfStamps >= 3 {
                logTransaction(numberOfClaims, firstLoadVal: self.firstLoad, completion:{ (result) in
                    if result {
                        self.star1.tintColor = UIColor.greenColor()
                        self.star3.tintColor = UIColor.greenColor()
                        
                    }else {
                        self.showErrorAlert("Network Error", msg: "Please check your internet connection and try again.", VC: self)
                    }
                })
       
            } else {
                self.needMoreStamps()
            }

        case maxRewards-3:
            if numberOfStamps >= 6 {
                logTransaction(numberOfClaims, firstLoadVal: self.firstLoad, completion:{ (result) in
                    if result {
                        self.star1.tintColor = UIColor.greenColor()
                        self.star3.tintColor = UIColor.greenColor()
                        self.star6.tintColor = UIColor.greenColor()
                        
                    }else {
                        self.showErrorAlert("Network Error", msg: "Please check your internet connection and try again.", VC: self)
                    }
                })
   
            } else {
                self.needMoreStamps()
            }

            
        case maxRewards-2:
            if numberOfStamps >= 8 {
                logTransaction(numberOfClaims, firstLoadVal: self.firstLoad, completion:{ (result) in
                    if result {
                        self.star1.tintColor = UIColor.greenColor()
                        self.star3.tintColor = UIColor.greenColor()
                        self.star6.tintColor = UIColor.greenColor()
                        self.star8.tintColor = UIColor.greenColor()
                        
                    }else {
                        self.showErrorAlert("Network Error", msg: "Please check your internet connection and try again.", VC: self)
                    }
                })
            
            } else {
                self.needMoreStamps()
            }

        case maxRewards-1:
            if numberOfStamps >= 10 {
                logTransaction(numberOfClaims, firstLoadVal: self.firstLoad, completion:{ (result) in
                    if result {
                        self.star1.tintColor = UIColor.greenColor()
                        self.star3.tintColor = UIColor.greenColor()
                        self.star6.tintColor = UIColor.greenColor()
                        self.star8.tintColor = UIColor.greenColor()
                        self.star10.tintColor = UIColor.greenColor()
                        
                    }else {
                        self.showErrorAlert("Network Error", msg: "Please check your internet connection and try again.", VC: self)
                    }
                })
                
            } else {
                self.needMoreStamps()
            }

        case maxRewards:
            if numberOfStamps >= 12 {
                logTransaction(numberOfClaims, firstLoadVal: self.firstLoad, completion:{ (result) in
                    if result {
                        self.star1.tintColor = UIColor.greenColor()
                        self.star3.tintColor = UIColor.greenColor()
                        self.star6.tintColor = UIColor.greenColor()
                        self.star8.tintColor = UIColor.greenColor()
                        self.star10.tintColor = UIColor.greenColor()
                        self.star12.tintColor = UIColor.greenColor()
                        
                    }else {
                        self.showErrorAlert("Network Error", msg: "Please check your internet connection and try again.", VC: self)
                    }
                })
                
            } else {
                self.needMoreStamps()
            }


        default:
            numberOfClaims = 0
            NSUserDefaults.standardUserDefaults().setInteger(self.numberOfClaims, forKey: "claims")
            break
        }
    }
    
    func updateStamps(numberStamps: Int) {
        
        switch(numberOfStamps){
        case maxStamps-12:
            star1.tintColor = UIColor.grayColor()
            star2.tintColor = UIColor.grayColor()
            star3.tintColor = UIColor.grayColor()
            star4.tintColor = UIColor.grayColor()
            star5.tintColor = UIColor.grayColor()
            star6.tintColor = UIColor.grayColor()
            star7.tintColor = UIColor.grayColor()
            star8.tintColor = UIColor.grayColor()
            star9.tintColor = UIColor.grayColor()
            star10.tintColor = UIColor.grayColor()
            star11.tintColor = UIColor.grayColor()
            star12.tintColor = UIColor.grayColor()
            break
            
        case maxStamps-11:
            star1.tintColor = COLOR2
            star2.tintColor = UIColor.grayColor()
            star3.tintColor = UIColor.grayColor()
            star4.tintColor = UIColor.grayColor()
            star5.tintColor = UIColor.grayColor()
            star6.tintColor = UIColor.grayColor()
            star7.tintColor = UIColor.grayColor()
            star8.tintColor = UIColor.grayColor()
            star9.tintColor = UIColor.grayColor()
            star10.tintColor = UIColor.grayColor()
            star11.tintColor = UIColor.grayColor()
            star12.tintColor = UIColor.grayColor()
            break
            
        case maxStamps-10:
            star1.tintColor = COLOR2
            star2.tintColor = COLOR2
            star3.tintColor = UIColor.grayColor()
            star4.tintColor = UIColor.grayColor()
            star5.tintColor = UIColor.grayColor()
            star6.tintColor = UIColor.grayColor()
            star7.tintColor = UIColor.grayColor()
            star8.tintColor = UIColor.grayColor()
            star9.tintColor = UIColor.grayColor()
            star10.tintColor = UIColor.grayColor()
            star11.tintColor = UIColor.grayColor()
            star12.tintColor = UIColor.grayColor()
            break
            
        case maxStamps-9:
            star1.tintColor = COLOR2
            star2.tintColor = COLOR2
            star3.tintColor = COLOR2
            star4.tintColor = UIColor.grayColor()
            star5.tintColor = UIColor.grayColor()
            star6.tintColor = UIColor.grayColor()
            star7.tintColor = UIColor.grayColor()
            star8.tintColor = UIColor.grayColor()
            star9.tintColor = UIColor.grayColor()
            star10.tintColor = UIColor.grayColor()
            star11.tintColor = UIColor.grayColor()
            star12.tintColor = UIColor.grayColor()
            break
            
        case maxStamps-8:
            star1.tintColor = COLOR2
            star2.tintColor = COLOR2
            star3.tintColor = COLOR2
            star4.tintColor = COLOR2
            star5.tintColor = UIColor.grayColor()
            star6.tintColor = UIColor.grayColor()
            star7.tintColor = UIColor.grayColor()
            star8.tintColor = UIColor.grayColor()
            star9.tintColor = UIColor.grayColor()
            star10.tintColor = UIColor.grayColor()
            star11.tintColor = UIColor.grayColor()
            star12.tintColor = UIColor.grayColor()
            break
            
        case maxStamps-7:
            star1.tintColor = COLOR2
            star2.tintColor = COLOR2
            star3.tintColor = COLOR2
            star4.tintColor = COLOR2
            star5.tintColor = COLOR2
            star6.tintColor = UIColor.grayColor()
            star7.tintColor = UIColor.grayColor()
            star8.tintColor = UIColor.grayColor()
            star9.tintColor = UIColor.grayColor()
            star10.tintColor = UIColor.grayColor()
            star11.tintColor = UIColor.grayColor()
            star12.tintColor = UIColor.grayColor()
            break
            
        case maxStamps-6:
            star1.tintColor = COLOR2
            star2.tintColor = COLOR2
            star3.tintColor = COLOR2
            star4.tintColor = COLOR2
            star5.tintColor = COLOR2
            star6.tintColor = COLOR2
            star7.tintColor = UIColor.grayColor()
            star8.tintColor = UIColor.grayColor()
            star9.tintColor = UIColor.grayColor()
            star10.tintColor = UIColor.grayColor()
            star11.tintColor = UIColor.grayColor()
            star12.tintColor = UIColor.grayColor()
            break
            
        case maxStamps-5:
            star1.tintColor = COLOR2
            star2.tintColor = COLOR2
            star3.tintColor = COLOR2
            star4.tintColor = COLOR2
            star5.tintColor = COLOR2
            star6.tintColor = COLOR2
            star7.tintColor = COLOR2
            star8.tintColor = UIColor.grayColor()
            star9.tintColor = UIColor.grayColor()
            star10.tintColor = UIColor.grayColor()
            star11.tintColor = UIColor.grayColor()
            star12.tintColor = UIColor.grayColor()
            break
            
        case maxStamps-4:
            star1.tintColor = COLOR2
            star2.tintColor = COLOR2
            star3.tintColor = COLOR2
            star4.tintColor = COLOR2
            star5.tintColor = COLOR2
            star6.tintColor = COLOR2
            star7.tintColor = COLOR2
            star8.tintColor = COLOR2
            star9.tintColor = UIColor.grayColor()
            star10.tintColor = UIColor.grayColor()
            star11.tintColor = UIColor.grayColor()
            star12.tintColor = UIColor.grayColor()
            break
            
        case maxStamps-3:
            star1.tintColor = COLOR2
            star2.tintColor = COLOR2
            star3.tintColor = COLOR2
            star4.tintColor = COLOR2
            star5.tintColor = COLOR2
            star6.tintColor = COLOR2
            star7.tintColor = COLOR2
            star8.tintColor = COLOR2
            star9.tintColor = COLOR2
            star10.tintColor = UIColor.grayColor()
            star11.tintColor = UIColor.grayColor()
            star12.tintColor = UIColor.grayColor()
            break
            
        case maxStamps-2:
            star1.tintColor = COLOR2
            star2.tintColor = COLOR2
            star3.tintColor = COLOR2
            star4.tintColor = COLOR2
            star5.tintColor = COLOR2
            star6.tintColor = COLOR2
            star7.tintColor = COLOR2
            star8.tintColor = COLOR2
            star9.tintColor = COLOR2
            star10.tintColor = COLOR2
            star11.tintColor = UIColor.grayColor()
            star12.tintColor = UIColor.grayColor()
            break
            
        case maxStamps-1:
            star1.tintColor = COLOR2
            star2.tintColor = COLOR2
            star3.tintColor = COLOR2
            star4.tintColor = COLOR2
            star5.tintColor = COLOR2
            star6.tintColor = COLOR2
            star7.tintColor = COLOR2
            star8.tintColor = COLOR2
            star9.tintColor = COLOR2
            star10.tintColor = COLOR2
            star11.tintColor = COLOR2
            star12.tintColor = UIColor.grayColor()
            break
            
        case maxStamps:
            star1.tintColor = COLOR2
            star2.tintColor = COLOR2
            star3.tintColor = COLOR2
            star4.tintColor = COLOR2
            star5.tintColor = COLOR2
            star6.tintColor = COLOR2
            star7.tintColor = COLOR2
            star8.tintColor = COLOR2
            star9.tintColor = COLOR2
            star10.tintColor = COLOR2
            star11.tintColor = COLOR2
            star12.tintColor = COLOR2
            break
            
        default:
            
            break
            
        
  
        }
        
        updateClaim()
        
      
    }

    func backButtonPressed(sender:UIButton) {
        navigationController?.popToRootViewControllerAnimated(true)
    }

    @IBAction func addBtnPressed(sender: AnyObject) {
    
        showAlert()
    }
    
    func showErrorAlert(title: String, msg: String, VC: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        VC.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func addStamp(){
        
        if let _ = self.long as Double?, _ = self.lat as Double?{
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
            self.addBtn.userInteractionEnabled = false
            self.addBtn.enabled = false
        
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            dateFormatter.timeZone = NSTimeZone(name: "GMT+8")
            let dateString = dateFormatter.stringFromDate(NSDate())
            
            var stampTrack = 0
            
            if numberOfStamps > 12 {
                stampTrack = 0
            }else {
                stampTrack = numberOfStamps
            }
            
            DataService.ds.REF_STAMPREPORT.updateChildValues(["\(dateString)/\(NSUserDefaults.standardUserDefaults().valueForKey("userId")!)/\(stampTrack+1)": "Long: \(self.long) Lat: \(self.lat) "], withCompletionBlock: { (error, FIRDatabaseReference) in
                
                self.activityIndicator.hidden = true
                self.activityIndicator.stopAnimating()
                self.addBtn.userInteractionEnabled = true
                self.addBtn.enabled = true
                if error == nil {
                    self.numberOfStamps = NSUserDefaults.standardUserDefaults().integerForKey("numberOfStamps") + 1
                    
                    if self.numberOfStamps <= 12 && self.numberOfStamps > 0 {
                        NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "numberOfStamps")
                        self.updateStamps(self.numberOfStamps)
                    } else if self.numberOfStamps > 12 {
                        self.resetFirebase({ (result) in
                            if result {
                                self.numberOfStamps = 1
                                NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "numberOfStamps")
                                self.numberOfClaims = 0
                                NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "claims")
                                self.updateStamps(self.numberOfStamps)
                            } else {
                                self.showErrorAlert("Something Went Wrong", msg: "Please try again and verify that you have an internet connection.", VC: self)
                            }
                        })
                        
                    }

                } else {
                    self.showErrorAlert("Something Went Wrong", msg: "Please try again and verify that you have an internet connection.", VC: self)
                }
                
            })
            
            
        } else {
            self.showErrorAlert("Something Went Wrong", msg: "Please try again and verify that you have an internet connection.", VC: self)
        }
    }
    
    func showActionSheet(){
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Select an option", message: "", preferredStyle: .ActionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionNotifyButton: UIAlertAction = UIAlertAction(title: "Add Stamp & Ask Review", style: .Default)
        { action -> Void in
            
            
            self.addStamp()
            //time based notification
            
            let timeNotif: UILocalNotification = UILocalNotification()
            
            timeNotif.alertBody = "Thank you for dining! Care to write us a review on Yelp?"
            timeNotif.soundName = UILocalNotificationDefaultSoundName
            timeNotif.userInfo = ["time": "min"]
            timeNotif.alertTitle = "Write us a review"
            //fire after 20 secs for demo purposes
            timeNotif.fireDate = NSDate(timeIntervalSinceNow: 15)
            
            UIApplication.sharedApplication().scheduleLocalNotification(timeNotif)
            
            let settings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            
            
        }
        
        if !(numberOfStamps == maxStamps && numberOfClaims < maxRewards) {
            actionSheetControllerIOS8.addAction(saveActionNotifyButton)
        }
        
        
        let saveActionNoNotifyButton: UIAlertAction = UIAlertAction(title: "Add Stamp & No Review", style: .Default)
        { action -> Void in
            self.addStamp()
    
        }
         if !(numberOfStamps == maxStamps && numberOfClaims < maxRewards) {
            actionSheetControllerIOS8.addAction(saveActionNoNotifyButton)
         }
        
        
//        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Subtract One Stamp", style: .Default)
//        { action -> Void in
//            self.numberOfStamps = NSUserDefaults.standardUserDefaults().integerForKey("numberOfStamps") - 1
//            
//            if self.numberOfStamps >= 0 {
//                NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "numberOfStamps")
//            } else {
//                self.numberOfStamps = 0
//                NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "numberOfStamps")
//            }
//            
//            self.updateStamps(self.numberOfStamps)
//
//        }
//        actionSheetControllerIOS8.addAction(deleteActionButton)
        
        let claimActionButton: UIAlertAction = UIAlertAction(title: "Claim Reward", style: .Default)
        { action -> Void in
            self.addClaims()
            self.updateClaim()
            
        }
        
        if numberOfClaims < maxRewards {
          actionSheetControllerIOS8.addAction(claimActionButton)
        }
        
        
        let resetActionButton: UIAlertAction = UIAlertAction(title: "Reset", style: .Default)
        { action -> Void in
            
            self.resetFirebase({ (result) in
                
                if result {
                    self.numberOfClaims = 0
                    
                    NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "claims")
                    self.numberOfStamps = 0
                    
                    NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "numberOfStamps")
                    
                    
                    
                    self.updateStamps(self.numberOfStamps)
                } else {
                    self.showErrorAlert("Something Went Wrong", msg: "Please try again and verify that you have an internet connection.", VC: self)
                }
            })


        }
        actionSheetControllerIOS8.addAction(resetActionButton)
        
        
        
        self.presentViewController(actionSheetControllerIOS8, animated: true, completion: nil)

    }
    
    func resetFirebase(completion: (result: Bool) -> Void){
        DataService.ds.REF_REWARDCLAIMS.child("\(NSUserDefaults.standardUserDefaults().valueForKey("userId")!)").removeValueWithCompletionBlock({ (error, FIRDatabaseReference) in
            
            if error == nil {
                completion(result: true)
            } else {
                self.removeClaims()
                completion(result: false)
            }
        })
        
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
    
    func showAlert() {
        let alertController = UIAlertController(title: "Manager PIN Required", message: "Have the manager enter the PIN to update your stamps.", preferredStyle: .Alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (_) in
            if let field = alertController.textFields![0] as? UITextField{
                field.resignFirstResponder()
                self.activityIndicator.hidden = false
                self.activityIndicator.startAnimating()
                self.addBtn.userInteractionEnabled = false
                self.addBtn.enabled = false
                
                if field.text == "\(managerPin!)" {
                    
                    self.checkIfWithinVicinity(distanceToClaim, completion: { (result) in
                        self.activityIndicator.hidden = true
                        self.activityIndicator.stopAnimating()
                        self.addBtn.userInteractionEnabled = true
                        self.addBtn.enabled = true
                        if result {
                            
                            if let _ = self.long as Double?, _ = self.lat as Double? {
                                
                                self.showActionSheet()
                                
                            }
                        } else {
                            self.showErrorAlert("You're Too Far Away", msg: "Please come closer to our branch.", VC: self)
                        }
                        
                    })
                    
                    
                    
                } else {
                    self.activityIndicator.hidden = true
                    self.activityIndicator.stopAnimating()
                    self.showErrorAlert("Incorrect PIN", msg: "", VC: self)
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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        long = userLocation.coordinate.longitude
        lat = userLocation.coordinate.latitude
        
    }

    
    
    
    

}
