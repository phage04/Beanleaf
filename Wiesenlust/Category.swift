//
//  Category.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 07/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import Foundation
import UIKit

public class Category {
    private var _name: String!
    private var _order: Int!
    private var _img: NSData!
    private var _imgURL: String!
    
    
    var name: String {
        if _name == nil {
            return ""
        }
        return _name
    }
    
    var order: Int {
        if _order == nil {
            return 99
        }
        return _order
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
    
    init(name: String, order: Int, image: UIImage, imgURL: String) {
       self._name = name
       self._order = order
       self._img = UIImagePNGRepresentation(image)
       self._imgURL = imgURL
        
    }

    
}