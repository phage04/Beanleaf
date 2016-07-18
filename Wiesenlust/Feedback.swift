//
//  Feedback.swift
//  OnionApps
//
//  Created by Lyle Christianne Jover on 18/07/2016.
//  Copyright © 2016 OnionApps. All rights reserved.
//

import UIKit
import SideMenu

class Feedback: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.Plain, target:self, action:#selector(Feedback.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:#selector(Feedback.showMenu))
        navigationController?.navigationBarHidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
    }

    func backButtonPressed(sender:UIButton) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func showMenu() {        
        performSegueWithIdentifier("menuSegue", sender: nil)
    }
}
