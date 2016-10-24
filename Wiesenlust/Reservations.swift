//
//  Reservations.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 13/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire
import SideMenu

class Reservations: UIViewController{
    
    
    
    @IBOutlet weak var bottomLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var peopleTxt: UITextField!
    
    @IBOutlet weak var mobileTxt: UITextField!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var peopleView: UIView!
    
    @IBOutlet weak var dateTimeTxt: UITextField!
    
    @IBOutlet weak var dateTimeView: UIView!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let userCalendar = Calendar.current

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.plain, target:self, action:#selector(Reservations.backButtonPressed(_:)))
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.plain, target:self, action:#selector(Reservations.showMenu))

        navigationController?.isNavigationBarHidden = false
        
        titleLbl.font = UIFont(name: font1Thin, size: 48)
        titleLbl.textColor = COLOR2
        titleLbl.text = "Make a free reservation"
        
        nameView.backgroundColor = COLOR2
        nameTxt.placeholder = "Name"
        nameTxt.font = UIFont(name: font1Regular, size: 18)
        nameTxt.textColor = COLOR2
        peopleView.backgroundColor = COLOR2
        peopleTxt.placeholder = "Number of people"
        peopleTxt.font = UIFont(name: font1Regular, size: 18)
        peopleTxt.textColor = COLOR2
        dateTimeView.backgroundColor = COLOR2
        mobileTxt.placeholder = "Mobile number"
        mobileTxt.font = UIFont(name: font1Regular, size: 18)
        mobileTxt.textColor = COLOR2
        mobileView.backgroundColor = COLOR2
        dateTimeTxt.placeholder = "Reservation date"
        dateTimeTxt.font = UIFont(name: font1Regular, size: 18)
        dateTimeTxt.textColor = COLOR2
        bottomLbl.font = UIFont(name: font1Regular, size: 14)
        bottomLbl.textColor = COLOR2
        bottomLbl.text = "You'll receive a call/sms from us once your reservation is confirmed."
        activityIndicator.color = COLOR1
        activityIndicator.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Reservations.dismissKeyboard))
        view.addGestureRecognizer(tap)
        


        
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

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }

    @IBAction func editingBegunDateTime(_ sender: UITextField) {
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
  
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRect(x: (self.view.frame.size.width/2) - (320/2), y: 40, width: 0, height: 0))
        
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        datePickerView.minuteInterval = 15
        
        let dateFromNow = (userCalendar as NSCalendar).date(
            byAdding: [.day],
            value: 90,
            to: Date(),
            options: [])
        
        datePickerView.maximumDate = dateFromNow
        datePickerView.minimumDate = Date()
        
        inputView.addSubview(datePickerView)
        inputView.backgroundColor = UIColor.white
        datePickerView.backgroundColor = UIColor.white
        

        sender.inputView = inputView
        datePickerView.addTarget(self, action: #selector(Reservations.handleDatePicker(_:)), for: UIControlEvents.valueChanged)
        
        let timeFromNow = (userCalendar as NSCalendar).date(
            byAdding: [.hour],
            value: 1,
            to: Date(),
            options: [])
        
        if let unwrappedDate = timeFromNow {
            datePickerView.setDate(unwrappedDate, animated: false)
        }
        
        
        handleDatePicker(datePickerView)
        
    }
    
    func handleDatePicker(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT2
        dateTimeTxt.text = dateFormatter.string(from: sender.date)
        dateTimeTxt.font = UIFont(name: font1Regular, size: 18)
        dateTimeTxt.textColor = COLOR2
    }
    
    


    @IBAction func sendBtnPressed(_ sender: AnyObject) {
     
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        if checkConnectivity()  {
           
            if nameTxt.text! != "" && peopleTxt.text! != "" && dateTimeTxt.text! != "" && mobileTxt.text! != "" {
                
                let key = mailGunKey
                
                let parameters = [
                    "Authorization" : "api:\(key)",
                    "from": "info@\(mailGunURL)",
                    "to": "\(mailGunOwnerEmail)",
                    "subject": "Reservation Request: \(Date())",
                    "text": "Hi! My name is \(nameTxt.text!). I'd like to make a reservation for \(peopleTxt.text!) on \(dateTimeTxt.text!). Please confirm my reservation by calling or sending me an sms at \(mobileTxt.text!) Thanks!"
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
    
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func backButtonPressed(_ sender:UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
}
