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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.textColor = COLOR2
        title.font = UIFont(name: font1Regular, size: 15)
        address.textColor = COLOR2
        address.font = UIFont(name: font1Light, size: 15)
        contact.textColor = COLOR2
        contact.font = UIFont(name: font1Light, size: 15)
        storeHours.textColor = COLOR2
        storeHours.font = UIFont(name: font1Light, size: 15)
    }
    
    func configureCell(titleVal: String, addressVal: String, contactVal: String, storeHoursVal: String) {
        
        title.text = titleVal
        address.text = addressVal
        contact.text = contactVal
        storeHours.text = storeHoursVal
    }
   

}
