//
//  ButtonRewards.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 12/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit
import pop

class ButtonRewards: UIButton {

    
    override func awakeFromNib() {
        layer.cornerRadius = 7.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
        layer.backgroundColor = UIColor.clearColor().CGColor
        self.titleLabel?.textColor = UIColor.clearColor()
        self.titleLabel?.font = UIFont(name: font1Regular, size: 18.0) 
        setupAnimation()
    }
    
    
    func setupAnimation() {
        
        self.addTarget(self, action: #selector(ButtonRewards.scaleToSmall), forControlEvents: .TouchDown)
        self.addTarget(self, action: #selector(ButtonRewards.scaleToSmall), forControlEvents: .TouchDragEnter)
        self.addTarget(self, action: #selector(ButtonRewards.scaleAnimation), forControlEvents: .TouchUpInside)
        self.addTarget(self, action: #selector(ButtonRewards.scaleToDefault), forControlEvents: .TouchDragExit)
    }
    
    func scaleToSmall() {
        let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(0.95, 0.95))
        self.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleSmallAnimation")
    }
    
    
    func scaleAnimation() {
        let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.velocity = NSValue(CGSize: CGSizeMake(3.0, 3.0))
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
        scaleAnim.springBounciness = 18
        self.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleSpringAnimation")
        
    }
    
    func scaleToDefault() {
        let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim.toValue = NSValue(CGSize: CGSizeMake(1, 1))
        self.layer.pop_addAnimation(scaleAnim, forKey: "layerScaleDefaultAnimation")
    }


}
