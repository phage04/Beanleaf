//
//  FoodItem.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 08/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

public class FoodItem {
    private var _category: String!
    private var _name: String!
    private var _descriptionInfo: String!
    private var _price: Double!
    private var _img: NSData!
    private var _imgURL: String!
    private var _postLikes: Int!
    private var _postRef: String!

    var postRef: String {
        
        if _postRef == nil {
            return ""
        }
        return _postRef
        
    }
    var postLikes: Int {
        get {
            if _postLikes == nil {
                return 0
            }
           return _postLikes
        }
        set {
            _postLikes = postLikes
        }
        
    }
    var category: String {
        if _category == nil {
            return ""
        }
        return _category
    }
    
    var name: String {
        if _name == nil {
            return ""
        }
        return _name
    }
    
    var descriptionInfo: String {
        if _descriptionInfo == nil {
            return ""
        }
        return _descriptionInfo
    }
    
    var price: Double {
        if _price == nil {
            return 0.00
        }
        return _price
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
    
    init(cat: String, name: String, desc: String?, price: Double, image: UIImage?, imgURL: String?, key: String) {
        self._category = cat
        
        self._name = name
        
        if let descVal = desc {
          self._descriptionInfo = descVal
        }
        
        self._price = price
        
        if let imageData = image {
            self._img = UIImagePNGRepresentation(imageData)
        }
        if let imgURLVal = imgURL {
            self._imgURL = imgURLVal
        }
        
        self._postRef = key
        
    }
    
    func adjustLikes(addLike: Bool, key: String) {
       
        DataService.ds.REF_LIKES.child("\(key)/likes").runTransactionBlock({
            (currentData:FIRMutableData!) in
            var value = currentData.value as? Int
            if (value == nil) {
                value = 0
            }
            if addLike {
                currentData.value = value! + 1
                
            } else {
                currentData.value = value! - 1
               
            }
            
            
            return FIRTransactionResult.successWithValue(currentData)
        })
    }
    
    
    
}