//
//  Coupon.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 11/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import Foundation
import UIKit

public class Coupon{
    
    private var _title: String!
    private var _subTitle: String!
    private var _discount: String!
    private var _validity: String!
    private var _terms: String!
    private var _special: Bool!
    
    
    var title: String {
        if _title == nil {
            return ""
        }
        return _title
    }
    
    var subtitle: String {
        if _subTitle == nil {
            return ""
        }
        return _subTitle
    }
    
    var discount: String {
        if _discount == nil {
            return ""
        }
        return _discount
    }
    
    var validity: String {
        if _validity == nil {
            return ""
        }
        return _validity
    }
    
    var terms: String {
        if _terms == nil {
            return ""
        }
        return _terms
    }
    
    var special: Bool {
        return _special
    }
    
    init(titleTxt: String, discountTxt: String, validityTxt: String?, termsTxt: String?, special: Bool) {
        
        self._title = titleTxt
        self._discount = discountTxt
        
        if let txtValidity = validityTxt {
          self._validity = txtValidity
        }
        
        if let txtTerms = termsTxt {
          self._terms = txtTerms
        }
        
        self._special = special
        
        
        
        
    }
    
    
    
}