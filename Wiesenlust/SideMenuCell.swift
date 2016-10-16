//
//  SideMenuCell.swift
//  OnionApps
//
//  Created by Lyle Christianne Jover on 18/07/2016.
//  Copyright © 2016 OnionApps. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var menuLbl: UILabel!
    @IBOutlet weak var menuImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        menuLbl.textColor = UIColor.white
        menuLbl.font = UIFont(name: font1Medium, size: 17)


    }
    
    func configureCell(_ titleVal: String, image: String) {
        
        menuLbl.text = titleVal
        if image != "" {
            menuImg.image = UIImage(named: image)
            menuImg.image = menuImg.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            menuImg.tintColor = COLOR1
        }
       
        
        
    }

  
}
