//
//  Menu.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 05/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit
import Auk
import moa

class Menu: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.Plain, target:self, action:#selector(Menu.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:#selector(Menu.backButtonPressed(_:)));
        
        scrollView.delegate = self
        Moa.logger = MoaConsoleLogger
        scrollView.auk.settings.contentMode = .ScaleAspectFill
        scrollView.auk.settings.pageControl.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.30)
        scrollView.auk.settings.pageControl.marginToScrollViewBottom = 4.0
        scrollView.auk.settings.pageControl.pageIndicatorTintColor = COLOR2
        scrollView.auk.settings.pageControl.currentPageIndicatorTintColor = COLOR1
        
        scrollView.auk.show(url: "http://eblogfa.com/wp-content/uploads/2014/01/burger-chesseburger-fastfood.jpg")
        scrollView.auk.show(url: "http://robertsboxedmeats.ca/wp-content/uploads/2011/07/TGIF_Stacked-Burger-LR-1.jpg")
        scrollView.auk.show(url: "http://eatburgerburger.com/wp-content/uploads/2016/01/burger-slide-1.jpg")
        scrollView.auk.startAutoScroll(delaySeconds: 2)
        

    
    }
    
    
    func backButtonPressed(sender:UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
