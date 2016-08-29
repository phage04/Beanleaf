//
//  CouponCell.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 11/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit

class CouponCell: UITableViewCell {
    
    
    @IBOutlet weak var starImg: UIImageView!
    
    @IBOutlet weak var couponImg: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var terms: UILabel!
    
    @IBOutlet weak var subTitle: UILabel!
    
    @IBOutlet weak var special: UILabel!
    
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var validity: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        title.textColor = COLOR2
        title.font = UIFont(name: font1Regular, size: 36)
        
        discount.textColor = COLOR2
        discount.font = UIFont(name: font1Medium, size: 24)
        
        terms.textColor = COLOR2
        terms.font = UIFont(name: font1Light, size: 10)
        
        validity.textColor = COLOR2
        validity.font = UIFont(name: font1Light, size: 14)
        
        
        subTitle.textColor = COLOR2
        subTitle.font = UIFont(name: font1Light, size: 12)
        
        special.textColor = COLOR2
        special.font = UIFont(name: font1Light, size: 12)
        
        let image = UIImage(named: "coupon")!
        var targetWidth : CGFloat
        var targetHeight : CGFloat
        var scaledImage = image
        
        targetWidth = couponImg.frame.width
        targetHeight = couponImg.frame.height
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight),false,0)
        image.drawInRect(CGRectMake(0, 0, targetWidth, targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        couponImg.image = scaledImage
    }
    
    func configureCell(titleTxt: String, discountTxt: Int!, validityTxt: String?, termsTxt: String?, discType: String, desc: String?, locFlag: Bool) {
        
        title.text = titleTxt
        
        switch(discType) {
            case "Percentage":
            discount.text = "\(discountTxt)%"
            break
            
            case "Amount":
            discount.text = "\(discountTxt)€"
            break
            
            default:
            break
            
        }
        
        validity.text = validityTxt
        
        
        subTitle.text = desc
       
        
        terms.text = termsTxt
        
        if locFlag {
            special.hidden = false
            special.text = "JUST FOR YOU"
            starImg.image = UIImage(named: "starFull1x")
            starImg.image = starImg.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            starImg.tintColor = COLOR_YELLOW
            
        } else {
            special.hidden = true
            starImg.hidden = true
        }
        

        
    }


}
