//
//  ItemCell.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 06/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    
    @IBOutlet weak var itemTitle: UILabel!
    
    @IBOutlet weak var itemDesc: UILabel!
 

    override func awakeFromNib() {
        super.awakeFromNib()
        itemTitle.textColor = COLOR3
        itemTitle.font = UIFont(name: font1Regular, size: 20)
        
        itemDesc.textColor = UIColor.darkGray
        itemDesc.font = UIFont(name: font1Light, size: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ dishName: String, dishDesc: String) {
        itemTitle.text = dishName
        itemDesc.text = dishDesc
    }

}
