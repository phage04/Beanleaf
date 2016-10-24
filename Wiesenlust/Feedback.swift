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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //THESE ARE ACTUALLY TEXTFIELDS
    
    let msgPlaceholder = "What would you like to tell us?"

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.plain, target:self, action:#selector(Feedback.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.plain, target:self, action:#selector(Feedback.showMenu))
        navigationController?.isNavigationBarHidden = false
        
        msgLbl.text = msgPlaceholder
        msgLbl.textColor = UIColor.lightGray
        msgLbl.font = UIFont(name: font1Regular, size: 18)
        msgLbl.layer.borderWidth = 1.0
        msgLbl.layer.borderColor = COLOR2.cgColor
        msgLbl.layer.cornerRadius = 10.0
        activityIndicator.color = COLOR1
        activityIndicator.isHidden = true
        
        self.msgLbl.delegate = self
        
        headerLbl.textColor = COLOR2
        headerLbl.font = UIFont(name: font1Medium, size: 18)
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = COLOR2
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = msgPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }

    func backButtonPressed(_ sender:UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func sendBtn(_ sender: AnyObject) {
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        if checkConnectivity()  {
            
            if nameLbl.text! != "" && emailLbl.text! != "" && msgLbl.text! != "" {
                
                let key = mailGunKey
                let Message = "Sender: \(nameLbl.text!) Email: \(emailLbl.text!) Message: \(msgLbl.text!)"
                
                let parameters = [
                    "Authorization" : "api:\(key)",
                    "from": "info@\(mailGunURL)",
                    "to": "\(mailGunOwnerEmail)",
                    "subject": "Customer Feedback: \(Date())",
                    "text": "\(Message)"
                ]
                
                _ = Alamofire.request("https://api.mailgun.net/v3/\(mailGunURL)/messages", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).authenticate(user: "api", password: key).response { response in
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    if response.error == nil{
                        self.showErrorAlertAction("Thank You", msg: "In a few moments, we will contact you to confirm your request.", VC: self)
                    } else {
                        showErrorAlert("Something Went Wrong", msg: "We're working on it. Please try again later.", VC: self)
                    }
                    
                }
            } else {
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
                showErrorAlert("Incomplete Information", msg: "Please complete all required information.", VC: self)
                
            }
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            showErrorAlert("Network Error", msg: "Please check your internet connection.", VC: self)
            
        }
        
        
    }
    
    func showErrorAlertAction(_ title: String, msg: String, VC: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            self.navigationController?.popToRootViewController(animated: true)
            
        })
        alert.addAction(actionOK)
        VC.present(alert, animated: true, completion: nil)
        
    }
    func showMenu() {        
        performSegue(withIdentifier: "menuSegue", sender: nil)
    }
}
