//
//  Reservations.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 13/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit

class Reservations: UIViewController{
    
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var peopleTxt: UITextField!
    
    @IBOutlet weak var peopleView: UIView!
    
    @IBOutlet weak var dateTimeTxt: UITextField!
    
    @IBOutlet weak var dateTimeView: UIView!
    
    @IBOutlet weak var mobileTxt: UITextField!
    
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.Plain, target:self, action:#selector(Reservations.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:nil)
        
        
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
        dateTimeTxt.placeholder = "Reservation date"
        dateTimeTxt.font = UIFont(name: font1Regular, size: 18)
        dateTimeTxt.textColor = COLOR2
        mobileView.backgroundColor = COLOR2
        mobileTxt.placeholder = "Mobile number"
        mobileTxt.font = UIFont(name: font1Regular, size: 18)
        mobileTxt.textColor = COLOR2
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Reservations.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Reservations.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Reservations.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
    }
    
//    func keyboardWillShow(sender: NSNotification) {
//        self.view.frame.origin.y -= 150
//    }
//    
//    func keyboardWillHide(sender: NSNotification) {
//        self.view.frame.origin.y += 150
//    }

    
    @IBAction func editingBegunMobile(sender: AnyObject) {
        //self.view.frame.origin.y -= 150
    }
    @IBAction func editingEndedMobile(sender: AnyObject) {
         //self.view.frame.origin.y += 150
    }
    @IBAction func editingBegunDateTime(sender: AnyObject) {
    }

    @IBAction func sendBtnPressed(sender: AnyObject) {
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func backButtonPressed(sender:UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
