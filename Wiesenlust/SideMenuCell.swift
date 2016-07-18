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
        menuLbl.textColor = UIColor.whiteColor()
        menuLbl.font = UIFont(name: font1Medium, size: 17)


    }
    
    func configureCell(titleVal: String, image: UIImage) {
        
        menuLbl.text = titleVal       
        menuImg.image = image
        menuImg.image = menuImg.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        menuImg.tintColor = COLOR1
        
        
    }

  
}
