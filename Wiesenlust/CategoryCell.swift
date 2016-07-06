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
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.backgroundColor = COLOR2
        barView.backgroundColor = COLOR1
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
    
    func configureCell(dishName: String, dishImg: String) {
        
        foodLbl.text = dishName
        foodImg.image = UIImage(named: dishImg)
        price.text = "4€"
        starCount.text = "326"
        
        
        
        
        //        if let profileImageURLVal = imgURL {
        //            profileImageURL = profileImageURLVal
        //            img = Menu.imageCache.objectForKey(profileImageURL) as? UIImage
        //
        //            if img != nil {
        //                self.categoryImg.image = img
        //            }  else {
        //
        //                request = Alamofire.request(.GET, profileImageURL!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
        //
        //                    if err == nil {
        //                        let img = UIImage(data: data!)!
        //                        self.categoryImg.image = img
        //
        //                        Menu.imageCache.setObject(img, forKey: self.profileImageURL!)
        //                    }
        //                    
        //                })
        //            }
        //            
        //        }
        
    }

}
