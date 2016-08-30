//
//  CategoryCell.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 05/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CategoryCell: UITableViewCell {
    
    
    
    @IBOutlet weak var star: UIButton!
    @IBOutlet weak var starCount: UILabel!
    
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var foodLbl: UILabel!
    
    @IBOutlet weak var circleView: UIView!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var foodImg: UIImageView!
  

    let gradientLayer = CAGradientLayer()
    var post: FoodItem!

    
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
        
        star.setImage(UIImage(named: "starEmpty1x")!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        star.tintColor = COLOR_YELLOW
        let tap = UITapGestureRecognizer(target: self, action: #selector(CategoryCell.likeTapped(_:)))
        tap.numberOfTapsRequired = 1
        star.addGestureRecognizer(tap)
        star.userInteractionEnabled = true
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
    
    func configureCell(item: FoodItem) {
        
        foodLbl.text = item.name
        
        if let imageDish = item.img as NSData? {
            foodImg.image = UIImage(data: imageDish)
        } else {
            foodImg.hidden = true
        }
        
        price.text = "\(item.price)€"
        
        DataService.ds.REF_ITEM.child("\(NSUserDefaults.standardUserDefaults().valueForKey("userId")!)/\(item.postRef)").observeSingleEventOfType(.Value, withBlock:
            { snapshot in
                
                
                if snapshot.value is NSNull {
                    self.star.setImage(UIImage(named: "starEmpty1x")!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
                    self.star.tintColor = COLOR_YELLOW
                } else {
                    self.star.setImage(UIImage(named: "starFull1x")!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
                    self.star.tintColor = COLOR_YELLOW
                }
                
        })
        
        DataService.ds.REF_LIKES.child("\(item.postRef)/likes").observeSingleEventOfType(.Value, withBlock:
            { snapshot in
                if snapshot.value is NSNull {
                    self.starCount.text = "0"
                    item.postLikes = 0
                } else {
                   self.starCount.text = "\(snapshot.value!)"
                    item.postLikes = snapshot.value as! Int
                }
                self.post = item
            })
       
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        if checkConnectivity() {
        
       let user = NSUserDefaults.standardUserDefaults().valueForKey("userId")!
        
        
        if let _ = self.post {
            let ref = self.post.postRef
            DataService.ds.REF_ITEM.child("\(user)/\(ref)").observeSingleEventOfType(.Value, withBlock:
                { snapshot in
                    
                    
                    if snapshot.value is NSNull {
                        self.post.adjustLikes(true, key: ref)
                        self.star.setImage(UIImage(named: "starFull1x")!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
                        self.star.tintColor = COLOR_YELLOW
                        self.starCount.text = "\(Int(self.starCount.text!)! + 1)"
                        DataService.ds.REF_ITEM.child("\(user)/\(self.post.postRef)").setValue(true)
                    } else {
                        self.post.adjustLikes(false, key: ref)
                        self.star.setImage(UIImage(named: "starEmpty1x")!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
                        self.star.tintColor = COLOR_YELLOW
                        self.starCount.text = "\(Int(self.starCount.text!)! - 1)"
                        DataService.ds.REF_ITEM.child("\(user)/\(ref)").removeValue()
                    }
                    
            })

        }
        
        }
        
    }

}
