//
//  CategoryCell.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 05/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    
    
    @IBOutlet weak var star: UIButton!
    @IBOutlet weak var starCount: UILabel!
    
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var foodLbl: UILabel!
    
    @IBOutlet weak var circleView: UIView!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var foodImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
