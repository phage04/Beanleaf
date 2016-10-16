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
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: targetWidth, height: targetHeight),false,0)
        imageStamp!.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image = scaledImage
        image = self.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        tintColor = UIColor.gray
    }

}
