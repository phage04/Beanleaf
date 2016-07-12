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
    @IBOutlet weak var star10: UIStackView!
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
        
        for view in self.view.subviews as [UIView] {
            if let lbl = view as? UILabel {
                lbl.hidden = true
            }
        }

        topLbl.hidden = false
        bottomLbl.hidden = false
        gift1.hidden = false
        gift3.hidden = false
        gift6.hidden = false
        gift8.hidden = false
        gift10.hidden = false
        gift12.hidden = false
        
        gift1.text = defaultFree
        gift3.text = defaultFree
        gift6.text = defaultFree
        gift8.text = defaultFree
        gift10.text = defaultFree
        gift12.text = defaultFree
        
    }

    func backButtonPressed(sender:UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func addBtnPressed(sender: AnyObject) {
    }
}
