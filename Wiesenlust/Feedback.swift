//
//  Feedback.swift
//  OnionApps
//
//  Created by Lyle Christianne Jover on 18/07/2016.
//  Copyright © 2016 OnionApps. All rights reserved.
//

import UIKit
import Alamofire
import SideMenu

class Feedback: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var headerLbl: UILabel!
    
    @IBOutlet weak var nameLbl: UITextField!
    
    @IBOutlet weak var emailLbl: UITextField!
    
    @IBOutlet weak var msgLbl: UITextView!
    
    //THESE ARE ACTUALLY TEXTFIELDS
    
    let msgPlaceholder = "What would you like to tell us?"

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.Plain, target:self, action:#selector(Feedback.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:#selector(Feedback.showMenu))
        navigationController?.navigationBarHidden = false
        
        msgLbl.text = msgPlaceholder
        msgLbl.textColor = UIColor.lightGrayColor()
        msgLbl.font = UIFont(name: font1Regular, size: 18)
        msgLbl.layer.borderWidth = 1.0
        msgLbl.layer.borderColor = COLOR2.CGColor
        msgLbl.layer.cornerRadius = 10.0
        
        self.msgLbl.delegate = self
        
        headerLbl.textColor = COLOR2
        headerLbl.font = UIFont(name: font1Medium, size: 18)
     
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = COLOR2
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = msgPlaceholder
            textView.textColor = UIColor.lightGrayColor()
        }
    }

    func backButtonPressed(sender:UIButton) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func sendBtn(sender: AnyObject) {
        
        
        if checkConnectivity()  {
            
            if nameLbl.text! != "" && emailLbl.text! != "" && msgLbl.text! != "" {
                
                let key = mailGunKey
                let Message = "Sender: \(nameLbl.text!) Email: \(emailLbl.text!) Message: \(msgLbl.text!)"
                
                let parameters = [
                    "Authorization" : "api:\(key)",
                    "from": "info@\(mailGunURL)",
                    "to": "\(mailGunOwnerEmail)",
                    "subject": "Customer Feedback: \(NSDate())",
                    "text": "\(Message)"
                ]
                
                _ = Alamofire.request(.POST, "https://api.mailgun.net/v3/\(mailGunURL)/messages", parameters:parameters)
                    .authenticate(user: "api", password: key)
                    .response { (request, response, data, error) in
                        if response?.statusCode == 200 {
                            self.showErrorAlertAction("Thank You", msg: "We take customer feedback very seriously. We appreciate you taking time to send this to us.", VC: self)
                            
                        } else {
                            showErrorAlert("Something Went Wrong", msg: "We're working on it. Please try again later.", VC: self)
                        }
                        print(response!)
                }
                
            } else {
                
                showErrorAlert("Incomplete Information", msg: "Please complete all required information.", VC: self)
                
            }
        } else {
            
            showErrorAlert("Network Error", msg: "Please check your internet connection.", VC: self)
            
        }
        
        
    }
    
    func showErrorAlertAction(title: String, msg: String, VC: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        
        let actionOK = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        })
        alert.addAction(actionOK)
        VC.presentViewController(alert, animated: true, completion: nil)
        
    }
    func showMenu() {        
        performSegueWithIdentifier("menuSegue", sender: nil)
    }
}
