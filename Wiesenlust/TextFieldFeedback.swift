//
//  TextFieldFeedback.swift
//  Onion Apps
//
//  Created by Lyle Christianne Jover on 18/07/2016.
//  Copyright © 2016 OnionApps. All rights reserved.
//

import UIKit

class TextFieldFeedback: UITextField {

    override func awakeFromNib() {
       
       font = UIFont(name: font1Regular, size: 18)
       textColor = COLOR2
       layer.borderColor = COLOR2.cgColor
       layer.borderWidth = 1.0
       layer.cornerRadius = 10.0
        
    }

}
