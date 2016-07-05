//
//  MenuCategoryCell.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 05/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit
import Alamofire


class MenuCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImg: UIImageView!
    
    @IBOutlet weak var categoryName: UILabel!
    
    var profileImageURL: String!
    var img: UIImage?
    var request: Request?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryName.textColor = UIColor.whiteColor()
        categoryName.font = UIFont(name: font1Light, size: 20)
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)  

    }
    

    func configureCell(catName: String, imgURL: String?) {
        
        categoryName.text = catName
        categoryImg.image = UIImage(named: "\(catName).jpg")
        
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
