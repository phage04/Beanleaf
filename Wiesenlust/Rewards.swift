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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topLbl.font = UIFont(name: font1Regular, size: 17)
        topLbl.textColor = COLOR2
        topLbl.text = "Earn stamps and receive special \(storeName) coupons as you collect! "
        
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
        
        gift1.text = defaultFree
        gift2.text = ""
        gift3.text = defaultFree
        gift4.text = ""
        gift5.text = ""
        gift6.text = defaultFree
        gift7.text = ""
        gift8.text = defaultFree
        gift9.text = ""
        gift10.text = defaultFree
        gift11.text = ""
        gift12.text = defaultFree
        
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
                
                if snapshot.value is NSNull && self.numberOfClaims > 0 {
                    DataService.ds.REF_REWARDCLAIMS.updateChildValues(["\(NSUserDefaults.standardUserDefaults().valueForKey("userId")!)/\(refLvl)/\(NSDate())/long": self.long, "\(NSUserDefaults.standardUserDefaults().valueForKey("userId")!)/\(refLvl)/\(NSDate())/lat": self.lat], withCompletionBlock: { (error, FIRDatabaseReference) in
                        
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
        case 1:
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
 
        case 2:
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

        case 3:
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

            
        case 4:
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

        case 5:
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

        case 6:
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
        case 0:
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
            
        case 1:
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
            
        case 2:
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
            
        case 3:
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
            
        case 4:
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
            
        case 5:
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
            
        case 6:
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
            
        case 7:
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
            
        case 8:
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
            
        case 9:
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
            
        case 10:
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
            
        case 11:
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
            
        case 12:
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
    
    
    
    func showActionSheet(){
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Select an option", message: "", preferredStyle: .ActionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionNotifyButton: UIAlertAction = UIAlertAction(title: "Add Stamp & Ask Review", style: .Default)
        { action -> Void in
            self.numberOfStamps = NSUserDefaults.standardUserDefaults().integerForKey("numberOfStamps") + 1
            
            if self.numberOfStamps <= 12 && self.numberOfStamps > 0 {
                NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "numberOfStamps")
            } else if self.numberOfStamps > 12 {
                self.numberOfStamps = 1
                NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "numberOfStamps")
                self.numberOfClaims = 0
                NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "claims")
            }
            
            self.updateStamps(self.numberOfStamps)
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
        actionSheetControllerIOS8.addAction(saveActionNotifyButton)
        
        let saveActionNoNotifyButton: UIAlertAction = UIAlertAction(title: "Add Stamp & No Review", style: .Default)
        { action -> Void in
            self.numberOfStamps = NSUserDefaults.standardUserDefaults().integerForKey("numberOfStamps") + 1
            
            if self.numberOfStamps <= 12 && self.numberOfStamps > 0 {
                NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "numberOfStamps")
            } else if self.numberOfStamps > 12 {
                self.numberOfStamps = 1
                NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "numberOfStamps")
                self.numberOfClaims = 0
                NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "claims")
            }
            
            self.updateStamps(self.numberOfStamps)
            
            
        }
        actionSheetControllerIOS8.addAction(saveActionNoNotifyButton)
        
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
        actionSheetControllerIOS8.addAction(claimActionButton)
        
        let resetActionButton: UIAlertAction = UIAlertAction(title: "Reset", style: .Default)
        { action -> Void in
            
                self.numberOfClaims = 0
                
                NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "claims")
                self.numberOfStamps = 0
                
                NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "numberOfStamps")
                
                self.updateStamps(self.numberOfStamps)


        }
        actionSheetControllerIOS8.addAction(resetActionButton)
        
        
        
        self.presentViewController(actionSheetControllerIOS8, animated: true, completion: nil)

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
                if field.text == "\(managerPin!)" {
                    
                    self.checkIfWithinVicinity(distanceToClaim, completion: { (result) in
                        self.activityIndicator.hidden = true
                        self.activityIndicator.stopAnimating()
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
