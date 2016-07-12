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
        image = self.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        tintColor = UIColor.grayColor()
    }

}
