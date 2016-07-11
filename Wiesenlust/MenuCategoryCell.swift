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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryName.textColor = UIColor.whiteColor()
        categoryName.font = UIFont(name: font1Light, size: 20)
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)  

    }
    

    func configureCell(catName: String, imgData: NSData) {
        
        categoryName.text = catName
        categoryImg.image = UIImage(data:imgData)
        
    }
    


    
}
