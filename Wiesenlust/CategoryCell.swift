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

    let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.backgroundColor = COLOR2
        
        barView.backgroundColor = UIColor.clearColor()
        gradientLayer.frame = barView.bounds
        let color1 = COLOR1.CGColor as CGColorRef
        let color2 = UIColor.clearColor().CGColor as CGColorRef
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.30, 0.70]
        gradientLayer.startPoint = CGPointMake(0,0.5)
        gradientLayer.endPoint = CGPointMake(1,0.5)
        barView.layer.addSublayer(gradientLayer)
        
        star.setImage(UIImage(named: "starFull1x")!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        star.tintColor = COLOR_YELLOW
        starCount.font = UIFont(name: font1Light, size: 12)
        starCount.textColor = UIColor.whiteColor()
        price.textColor = UIColor.whiteColor()
        price.font = UIFont(name: font1Light, size: 24)
        foodLbl.textColor = COLOR2
        foodLbl.font = UIFont(name: font1Light, size: 20)
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(dishName: String, priceVal: Double, dishImg: NSData?) {
        
        foodLbl.text = dishName
        
        if image = dishImg as NSData {
            foodImg.image = UIImage(data: image)
        } else {
            foodImg.hidden = true
        }
        
        price.text = "\(priceVal)€"
        starCount.text = "326"       
        
    
        
    }

}
