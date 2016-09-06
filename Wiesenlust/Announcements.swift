//
//  Category.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 07/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import Foundation
import UIKit

public class Announcements {
    private var _title: String!
    private var _img: NSData!
    private var _imgURL: String!
    private var _id: String!
    
    var id: String {
        if _id == nil {
            return ""
        }else {
            return _id
        }
    }

    var title: String {
        if _title == nil {
            return ""
        }
        return _title
    }
    
    var img: NSData {
        get {
            return _img
        }
        set {
            self._img = UIImagePNGRepresentation(UIImage(data: img)!)
        }
    }
    
    var imgURL: String {
        if _imgURL == nil {
            return ""
        }
        return _imgURL
    }
    
    init(id: String, title: String, image: UIImage, imgURL: String) {
        
        self._id = id
        self._title = title
        self._img = UIImagePNGRepresentation(image)
        self._imgURL = imgURL
        
    }
    
    
}