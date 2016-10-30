//
//  LocationsCell.swift
//  OnionApps
//
//  Created by Lyle Christianne Jover on 15/07/2016.
//  Copyright © 2016 OnionApps. All rights reserved.
//

import UIKit

class LocationsCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var storeHours: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    
    
    override func awakeFromNib() {
     
        super.awakeFromNib()
        title.textColor = COLOR3
        title.font = UIFont(name: font1Medium, size: 15)
        address.textColor = UIColor.darkGray
        address.font = UIFont(name: font1Light, size: 15)
        contact.textColor = UIColor.darkGray
        contact.font = UIFont(name: font1Light, size: 15)
        storeHours.textColor = UIColor.darkGray
        storeHours.font = UIFont(name: font1Light, size: 15)
    
        
    }
    
    func configureCell(_ titleVal: String, addressVal: String, contactVal: String, storeHoursVal: String, row: Int) {
        
        title.text = titleVal
        address.text = addressVal
        contact.text = contactVal
        storeHours.text = storeHoursVal
        
        let image = phoneIcon!
        let targetWidth : CGFloat = 40
        let targetHeight : CGFloat = 40
        var scaledImage = image
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: targetWidth, height: targetHeight),false,0)
        image.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        callBtn.setImage(scaledImage.withRenderingMode(.alwaysTemplate), for: UIControlState())
        callBtn.tintColor = COLOR3
        
        self.callBtn.removeTarget(LocationsVC(), action: #selector(LocationsVC.callClicked(_:)), for: UIControlEvents.touchUpInside)
        
        self.callBtn.tag = row
        self.callBtn.addTarget(LocationsVC(), action: #selector(LocationsVC.callClicked(_:)), for: UIControlEvents.touchUpInside)
    }
   

}
