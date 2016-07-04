//
//  ViewController.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 01/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit

class Home: UIViewController {

    @IBOutlet var backgroundView: UIView!    
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var menuItem1: UIButton!
    
    @IBOutlet weak var menuItem2: UIButton!
    
    @IBOutlet weak var menuItem3: UIButton!
    
    @IBOutlet weak var menuItem4: UIButton!
    
    @IBOutlet weak var menuItem5: UIButton!
    
    @IBOutlet weak var menuItem6: UIButton!

    @IBOutlet weak var menuLbl1: UILabel!
    
    @IBOutlet weak var menuLbl2: UILabel!
    
    @IBOutlet weak var menuLbl3: UILabel!
    
    @IBOutlet weak var menuLbl4: UILabel!
    
    @IBOutlet weak var menuLbl5: UILabel!
    
    @IBOutlet weak var menuLbl6: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.backgroundColor = COLOR1
        
        var image = menuIcon1!
        let targetWidth : CGFloat = 92
        let targetHeight : CGFloat = 92
        var scaledImage = image
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight),false,0)
        image.drawInRect(CGRectMake(0, 0, targetWidth, targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        menuItem1.setImage(scaledImage.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
   
        image = menuIcon2!
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight),false,0)
        image.drawInRect(CGRectMake(0, 0, targetWidth, targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        menuItem2.setImage(scaledImage.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        
        image = menuIcon3!
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight),false,0)
        image.drawInRect(CGRectMake(0, 0, targetWidth, targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        menuItem3.setImage(scaledImage.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        
        image = menuIcon4!
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight),false,0)
        image.drawInRect(CGRectMake(0, 0, targetWidth, targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        menuItem4.setImage(scaledImage.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        
        image = menuIcon5!
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight),false,0)
        image.drawInRect(CGRectMake(0, 0, targetWidth, targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        menuItem5.setImage(scaledImage.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        
        image = menuIcon6!
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight),false,0)
        image.drawInRect(CGRectMake(0, 0, targetWidth, targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        menuItem6.setImage(scaledImage.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        
        
        menuItem1.tintColor = COLOR2
        menuItem2.tintColor = COLOR2
        menuItem3.tintColor = COLOR2
        menuItem4.tintColor = COLOR2
        menuItem5.tintColor = COLOR2
        menuItem6.tintColor = COLOR2
        
        menuLbl1.font = UIFont(name: font1Medium, size: 14)
        menuLbl2.font = UIFont(name: font1Medium, size: 14)
        menuLbl3.font = UIFont(name: font1Medium, size: 14)
        menuLbl4.font = UIFont(name: font1Medium, size: 14)
        menuLbl5.font = UIFont(name: font1Medium, size: 14)
        menuLbl6.font = UIFont(name: font1Medium, size: 14)
        
        menuLbl1.textColor = COLOR2
        menuLbl2.textColor = COLOR2
        menuLbl3.textColor = COLOR2
        menuLbl4.textColor = COLOR2
        menuLbl5.textColor = COLOR2
        menuLbl6.textColor = COLOR2
        
        menuLbl1.text = menuLblText1
        menuLbl2.text = menuLblText2
        menuLbl3.text = menuLblText3
        menuLbl4.text = menuLblText4
        menuLbl5.text = menuLblText5
        menuLbl6.text = menuLblText6
        
        
        

        
    }

   
    @IBAction func menuItem1Pressed(sender: AnyObject) {
        
    }
    
    @IBAction func menuItem2Pressed(sender: AnyObject) {
    }

    @IBAction func menuItem3Pressed(sender: AnyObject) {
    }

    @IBAction func menuItem4Pressed(sender: AnyObject) {
    }
    
    @IBAction func menuItem5Pressed(sender: AnyObject) {
    }

    @IBAction func menuItem6Pressed(sender: AnyObject) {
    }
    
    
    
    
}

