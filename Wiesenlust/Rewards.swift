//
//  Loyalty.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 12/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit

class Rewards: UIViewController {
    
    
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
    
    var numberOfStamps: Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topLbl.font = UIFont(name: font1Regular, size: 18)
        topLbl.textColor = COLOR2
        topLbl.text = "Earn stamps and receive special \(storeName) coupons as you collect! "
        
        bottomLbl.font = UIFont(name: font1Regular, size: 14)
        bottomLbl.textColor = COLOR2
        bottomLbl.text = "For every transaction with minimum amount of \(minimumReceipt), earn one stamp."
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.Plain, target:self, action:#selector(Rewards.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:nil)
        


        topLbl.hidden = false
        bottomLbl.hidden = false
        
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
        updateStamps(numberOfStamps)


        
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
        
        
      
    }

    func backButtonPressed(sender:UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
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
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Add One Stamp", style: .Default)
        { action -> Void in
            self.numberOfStamps = NSUserDefaults.standardUserDefaults().integerForKey("numberOfStamps") + 1
            
            if self.numberOfStamps <= 12 && self.numberOfStamps > 0 {
                NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "numberOfStamps")
            } else if self.numberOfStamps > 12 {
                self.numberOfStamps = 1
                NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "numberOfStamps")
            }
            
            self.updateStamps(self.numberOfStamps)
            
            
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Subtract One Stamp", style: .Default)
        { action -> Void in
            self.numberOfStamps = NSUserDefaults.standardUserDefaults().integerForKey("numberOfStamps") - 1
            
            if self.numberOfStamps >= 0 {
                NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "numberOfStamps")
            } else {
                self.numberOfStamps = 0
                NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "numberOfStamps")
            }
            
            self.updateStamps(self.numberOfStamps)

        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        
        let resetActionButton: UIAlertAction = UIAlertAction(title: "Reset", style: .Default)
        { action -> Void in
            self.numberOfStamps = 0
            
            NSUserDefaults.standardUserDefaults().setInteger(self.numberOfStamps, forKey: "numberOfStamps")
            
            self.updateStamps(self.numberOfStamps)

        }
        actionSheetControllerIOS8.addAction(resetActionButton)
        
        self.presentViewController(actionSheetControllerIOS8, animated: true, completion: nil)

    }

    
    func showAlert() {
        let alertController = UIAlertController(title: "Manager PIN Required", message: "", preferredStyle: .Alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (_) in
            if let field = alertController.textFields![0] as? UITextField{
                field.resignFirstResponder()
                if field.text == managerPin {
                    self.showActionSheet()
                } else {
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
}
