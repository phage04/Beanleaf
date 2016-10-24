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
        
        navigationItem.backBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.plain, target:self, action:#selector(Rewards.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.plain, target:self, action:#selector(Rewards.showMenu))
        
        navigationController?.isNavigationBarHidden = false

        topLbl.isHidden = false
        bottomLbl.isHidden = false
        
        activityIndicator.color = COLOR1
        activityIndicator.isHidden = true
        
        gift1.text = "Loading..."
        gift2.text = ""
        gift3.text = "Loading..."
        gift4.text = ""
        gift5.text = ""
        gift6.text = "Loading..."
        gift7.text = ""
        gift8.text = "Loading..."
        gift9.text = ""
        gift10.text = "Loading..."
        gift11.text = ""
        gift12.text = "Loading..."
        
        
        numberOfStamps = UserDefaults.standard.integer(forKey: "numberOfStamps")
        numberOfClaims = UserDefaults.standard.integer(forKey: "claims")
        updateStamps(numberOfStamps)
        updateClaim()
        
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            
        }
        
        locationManager.startUpdatingLocation()

        
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        self.addBtn.isUserInteractionEnabled = false
        self.addBtn.isEnabled = false
            downloadFreeItems({ (result) in
                if result {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.addBtn.isUserInteractionEnabled = true
                    self.addBtn.isEnabled = true
                    
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
                }
               
            })
    }
    
    
    func showMenu() {
        performSegue(withIdentifier: "menuSegue", sender: nil)
    }
    
    func needMoreStamps(){
        self.removeClaims()
        showErrorAlert("Insufficient Stamps", msg: "The customer need more stamps to claim the next reward.", VC: self)
    }
    
    
    func logTransaction(_ refLvl: Int, firstLoadVal: Bool, completion: @escaping (_ result: Bool) -> Void) {
      
        if firstLoadVal && self.numberOfClaims == 0 {
            self.firstLoad = false
            completion(true)
        } else {
      
            DataService.ds.REF_REWARDCLAIMS.child("\(UserDefaults.standard.value(forKey: "userId")!)/\(refLvl)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss xxxx"
                dateFormatter.timeZone = TimeZone(identifier: "GMT+8")
                let dateString = dateFormatter.string(from: Date())
                
                if snapshot.value is NSNull && self.numberOfClaims > 0 {
                    DataService.ds.REF_REWARDCLAIMS.updateChildValues(["\(UserDefaults.standard.value(forKey: "userId")!)/\(refLvl)/\(dateString)/long": self.long, "\(UserDefaults.standard.value(forKey: "userId")!)/\(refLvl)/\(dateString)/lat": self.lat], withCompletionBlock: { (error, FIRDatabaseReference) in
                        
                        if error == nil {
                            completion(true)
                        } else {
                            self.removeClaims()
                            completion(false)
                        }
                    })
                } else {
                    completion(true)
                }
            })

        }
        
        
    }
    
    func addClaims(){
        self.numberOfClaims = UserDefaults.standard.integer(forKey: "claims") + 1
        
        UserDefaults.standard.set(self.numberOfClaims, forKey: "claims")
        
        self.numberOfClaims = UserDefaults.standard.integer(forKey: "claims")
    }

    func removeClaims(){
        self.numberOfClaims = UserDefaults.standard.integer(forKey: "claims") - 1
        
        UserDefaults.standard.set(self.numberOfClaims, forKey: "claims")
        
        self.numberOfClaims = UserDefaults.standard.integer(forKey: "claims")
    }

    func updateClaim(){
 
        switch numberOfClaims {
        case maxRewards-5:
            if numberOfStamps >= 1 {
          
                logTransaction(numberOfClaims, firstLoadVal: self.firstLoad, completion: { (result) in
                    if result {
                        self.star1.tintColor = UIColor.green
                        
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
                        self.star1.tintColor = UIColor.green
                        self.star3.tintColor = UIColor.green
                        
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
                        self.star1.tintColor = UIColor.green
                        self.star3.tintColor = UIColor.green
                        self.star6.tintColor = UIColor.green
                        
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
                        self.star1.tintColor = UIColor.green
                        self.star3.tintColor = UIColor.green
                        self.star6.tintColor = UIColor.green
                        self.star8.tintColor = UIColor.green
                        
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
                        self.star1.tintColor = UIColor.green
                        self.star3.tintColor = UIColor.green
                        self.star6.tintColor = UIColor.green
                        self.star8.tintColor = UIColor.green
                        self.star10.tintColor = UIColor.green
                        
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
                        self.star1.tintColor = UIColor.green
                        self.star3.tintColor = UIColor.green
                        self.star6.tintColor = UIColor.green
                        self.star8.tintColor = UIColor.green
                        self.star10.tintColor = UIColor.green
                        self.star12.tintColor = UIColor.green
                        
                    }else {
                        self.showErrorAlert("Network Error", msg: "Please check your internet connection and try again.", VC: self)
                    }
                })
                
            } else {
                self.needMoreStamps()
            }


        default:
            numberOfClaims = 0
            UserDefaults.standard.set(self.numberOfClaims, forKey: "claims")
            break
        }
    }
    
    func updateStamps(_ numberStamps: Int) {
        
        switch(numberOfStamps){
        case maxStamps-12:
            star1.tintColor = UIColor.gray
            star2.tintColor = UIColor.gray
            star3.tintColor = UIColor.gray
            star4.tintColor = UIColor.gray
            star5.tintColor = UIColor.gray
            star6.tintColor = UIColor.gray
            star7.tintColor = UIColor.gray
            star8.tintColor = UIColor.gray
            star9.tintColor = UIColor.gray
            star10.tintColor = UIColor.gray
            star11.tintColor = UIColor.gray
            star12.tintColor = UIColor.gray
            break
            
        case maxStamps-11:
            star1.tintColor = COLOR2
            star2.tintColor = UIColor.gray
            star3.tintColor = UIColor.gray
            star4.tintColor = UIColor.gray
            star5.tintColor = UIColor.gray
            star6.tintColor = UIColor.gray
            star7.tintColor = UIColor.gray
            star8.tintColor = UIColor.gray
            star9.tintColor = UIColor.gray
            star10.tintColor = UIColor.gray
            star11.tintColor = UIColor.gray
            star12.tintColor = UIColor.gray
            break
            
        case maxStamps-10:
            star1.tintColor = COLOR2
            star2.tintColor = COLOR2
            star3.tintColor = UIColor.gray
            star4.tintColor = UIColor.gray
            star5.tintColor = UIColor.gray
            star6.tintColor = UIColor.gray
            star7.tintColor = UIColor.gray
            star8.tintColor = UIColor.gray
            star9.tintColor = UIColor.gray
            star10.tintColor = UIColor.gray
            star11.tintColor = UIColor.gray
            star12.tintColor = UIColor.gray
            break
            
        case maxStamps-9:
            star1.tintColor = COLOR2
            star2.tintColor = COLOR2
            star3.tintColor = COLOR2
            star4.tintColor = UIColor.gray
            star5.tintColor = UIColor.gray
            star6.tintColor = UIColor.gray
            star7.tintColor = UIColor.gray
            star8.tintColor = UIColor.gray
            star9.tintColor = UIColor.gray
            star10.tintColor = UIColor.gray
            star11.tintColor = UIColor.gray
            star12.tintColor = UIColor.gray
            break
            
        case maxStamps-8:
            star1.tintColor = COLOR2
            star2.tintColor = COLOR2
            star3.tintColor = COLOR2
            star4.tintColor = COLOR2
            star5.tintColor = UIColor.gray
            star6.tintColor = UIColor.gray
            star7.tintColor = UIColor.gray
            star8.tintColor = UIColor.gray
            star9.tintColor = UIColor.gray
            star10.tintColor = UIColor.gray
            star11.tintColor = UIColor.gray
            star12.tintColor = UIColor.gray
            break
            
        case maxStamps-7:
            star1.tintColor = COLOR2
            star2.tintColor = COLOR2
            star3.tintColor = COLOR2
            star4.tintColor = COLOR2
            star5.tintColor = COLOR2
            star6.tintColor = UIColor.gray
            star7.tintColor = UIColor.gray
            star8.tintColor = UIColor.gray
            star9.tintColor = UIColor.gray
            star10.tintColor = UIColor.gray
            star11.tintColor = UIColor.gray
            star12.tintColor = UIColor.gray
            break
            
        case maxStamps-6:
            star1.tintColor = COLOR2
            star2.tintColor = COLOR2
            star3.tintColor = COLOR2
            star4.tintColor = COLOR2
            star5.tintColor = COLOR2
            star6.tintColor = COLOR2
            star7.tintColor = UIColor.gray
            star8.tintColor = UIColor.gray
            star9.tintColor = UIColor.gray
            star10.tintColor = UIColor.gray
            star11.tintColor = UIColor.gray
            star12.tintColor = UIColor.gray
            break
            
        case maxStamps-5:
            star1.tintColor = COLOR2
            star2.tintColor = COLOR2
            star3.tintColor = COLOR2
            star4.tintColor = COLOR2
            star5.tintColor = COLOR2
            star6.tintColor = COLOR2
            star7.tintColor = COLOR2
            star8.tintColor = UIColor.gray
            star9.tintColor = UIColor.gray
            star10.tintColor = UIColor.gray
            star11.tintColor = UIColor.gray
            star12.tintColor = UIColor.gray
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
            star9.tintColor = UIColor.gray
            star10.tintColor = UIColor.gray
            star11.tintColor = UIColor.gray
            star12.tintColor = UIColor.gray
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
            star10.tintColor = UIColor.gray
            star11.tintColor = UIColor.gray
            star12.tintColor = UIColor.gray
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
            star11.tintColor = UIColor.gray
            star12.tintColor = UIColor.gray
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
            star12.tintColor = UIColor.gray
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

    func backButtonPressed(_ sender:UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func addBtnPressed(_ sender: AnyObject) {
    
        showAlert()
    }
    
    func showErrorAlert(_ title: String, msg: String, VC: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        VC.present(alert, animated: true, completion: nil)
        
    }
    
    func showErrorAlertAction(_ title: String, msg: String, VC: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            self.addBtn.isUserInteractionEnabled = true
            self.addBtn.isEnabled = true
            
        })
        alert.addAction(actionOK)
        VC.present(alert, animated: true, completion: nil)
        
    }
    
    func addStamp(){
        
        if let _ = self.long as Double?, let _ = self.lat as Double?{
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.addBtn.isUserInteractionEnabled = false
            self.addBtn.isEnabled = false
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            dateFormatter.timeZone = TimeZone(identifier: "GMT+8")
            let dateString = dateFormatter.string(from: Date())
            
            var stampTrack = 0
            
            if numberOfStamps >= 12 {
                stampTrack = 0
            }else {
                stampTrack = numberOfStamps
            }
            
            DataService.ds.REF_STAMPREPORT.updateChildValues(["\(dateString)/\(UserDefaults.standard.value(forKey: "userId")!)/\(stampTrack+1)": "Long: \(self.long) Lat: \(self.lat) "], withCompletionBlock: { (error, FIRDatabaseReference) in
                
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.addBtn.isUserInteractionEnabled = true
                self.addBtn.isEnabled = true
                if error == nil {
                    self.numberOfStamps = UserDefaults.standard.integer(forKey: "numberOfStamps") + 1
                    
                    if self.numberOfStamps <= 12 && self.numberOfStamps > 0 {
                        UserDefaults.standard.set(self.numberOfStamps, forKey: "numberOfStamps")
                        self.updateStamps(self.numberOfStamps)
                    } else if self.numberOfStamps > 12 {
                        self.resetFirebase({ (result) in
                            if result {
                                self.numberOfStamps = 1
                                UserDefaults.standard.set(self.numberOfStamps, forKey: "numberOfStamps")
                                self.numberOfClaims = 0
                                UserDefaults.standard.set(self.numberOfStamps, forKey: "claims")
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
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Select an option", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionNotifyButton: UIAlertAction = UIAlertAction(title: "Add Stamp & Ask Review", style: .default)
        { action -> Void in
            
            
            self.addStamp()
            //time based notification
            
            let timeNotif: UILocalNotification = UILocalNotification()
            
            timeNotif.alertBody = "Thank you for dining! Care to write us a review on Yelp?"
            timeNotif.soundName = UILocalNotificationDefaultSoundName
            timeNotif.userInfo = ["time": "min"]
            timeNotif.alertTitle = "Write us a review"
            //fire after 20 secs for demo purposes
            timeNotif.fireDate = Date(timeIntervalSinceNow: 15)
            
            UIApplication.shared.scheduleLocalNotification(timeNotif)
            
            let settings = UIUserNotificationSettings(types: .alert, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            
            
        }
        
        if !(numberOfStamps == maxStamps && numberOfClaims < maxRewards) {
            actionSheetControllerIOS8.addAction(saveActionNotifyButton)
        }
        
        
        let saveActionNoNotifyButton: UIAlertAction = UIAlertAction(title: "Add Stamp & No Review", style: .default)
        { action -> Void in
            self.addStamp()
    
        }
         if !(numberOfStamps == maxStamps && numberOfClaims < maxRewards) {
            actionSheetControllerIOS8.addAction(saveActionNoNotifyButton)
         }
        
        
        
        let claimActionButton: UIAlertAction = UIAlertAction(title: "Claim Reward", style: .default)
        { action -> Void in
            self.addClaims()
            self.updateClaim()
            
        }
        
        if numberOfClaims < maxRewards {
          actionSheetControllerIOS8.addAction(claimActionButton)
        }
        
        
        let resetActionButton: UIAlertAction = UIAlertAction(title: "Reset", style: .default)
        { action -> Void in
            
            self.resetFirebase({ (result) in
                
                if result {
                    self.numberOfClaims = 0
                    
                    UserDefaults.standard.set(self.numberOfStamps, forKey: "claims")
                    self.numberOfStamps = 0
                    
                    UserDefaults.standard.set(self.numberOfStamps, forKey: "numberOfStamps")
                    
                    
                    
                    self.updateStamps(self.numberOfStamps)
                } else {
                    self.showErrorAlert("Something Went Wrong", msg: "Please try again and verify that you have an internet connection.", VC: self)
                }
            })


        }
        actionSheetControllerIOS8.addAction(resetActionButton)
        
        
        
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)

    }
    
    func resetFirebase(_ completion: @escaping (_ result: Bool) -> Void){
        DataService.ds.REF_REWARDCLAIMS.child("\(UserDefaults.standard.value(forKey: "userId")!)").removeValue(completionBlock: { (error, FIRDatabaseReference) in
            
            if error == nil {
                completion(true)
            } else {
                self.removeClaims()
                completion(false)
            }
        })
        
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
    
    func showAlert() {
        let alertController = UIAlertController(title: "Manager PIN Required", message: "Have the manager enter the PIN to update your stamps.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields![0] as? UITextField{
                field.resignFirstResponder()
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                self.addBtn.isUserInteractionEnabled = false
                self.addBtn.isEnabled = false
                
                if field.text == "\(managerPin!)" {
                    
                    self.checkIfWithinVicinity(distanceToClaim, completion: { (result) in
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.addBtn.isUserInteractionEnabled = true
                        self.addBtn.isEnabled = true
                        if result {
                            
                            if let _ = self.long as Double?, let _ = self.lat as Double? {
                                
                                self.showActionSheet()
                                
                            }
                        } else {
                            self.showErrorAlert("You're Too Far Away", msg: "Please come closer to our branch.", VC: self)
                        }
                        
                    })
                    
                    
                    
                } else {
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.showErrorAlertAction("Incorrect PIN", msg: "", VC: self)
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        long = userLocation.coordinate.longitude
        lat = userLocation.coordinate.latitude
        
    }

    
    
    
    

}
