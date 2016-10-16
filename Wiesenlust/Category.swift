//
//  Category.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 07/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import Foundation
import UIKit

open class Category {
    fileprivate var _name: String!
    fileprivate var _order: Int!
    fileprivate var _img: Data!
    fileprivate var _imgURL: String!
    fileprivate var _id: String!
    
    var id: String {
        if _id == nil {
            return ""
        }else {
            return _id
        }
    }
    
    
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
    
    var img: Data {
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
    
    init(id: String, name: String, order: Int, image: UIImage, imgURL: String) {
       
       self._id = id
       self._name = name
       self._order = order
       self._img = UIImagePNGRepresentation(image)
       self._imgURL = imgURL
        
    }

    
}
