//
//  ImageStarStamp.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 12/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit

class ImageStarStamp: UIImageView {

    override func awakeFromNib() {
        
        let imageStamp = stampIcon
        let targetWidth : CGFloat = 75
        let targetHeight : CGFloat = 75
        var scaledImage = imageStamp
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight),false,0)
        imageStamp!.drawInRect(CGRectMake(0, 0, targetWidth, targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image = scaledImage
        image = self.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        tintColor = UIColor.grayColor()
    }

}
