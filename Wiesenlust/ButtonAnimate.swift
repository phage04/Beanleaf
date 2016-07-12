//
//  ButtonAnimate.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 12/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit
import pop

class ButtonAnimate: UIButton {
    override func awakeFromNib() {

        setupAnimation()
    }
    
    
    func setupAnimation() {
        
        self.addTarget(self, action: #selector(ButtonAnimate.scaleToSmall), forControlEvents: .TouchDown)
        self.addTarget(self, action: #selector(ButtonAnimate.scaleToSmall), forControlEvents: .TouchDragEnter)
        self.addTarget(self, action: #selector(ButtonAnimate.scaleAnimation), forControlEvents: .TouchUpInside)
        self.addTarget(self, action: #selector(ButtonAnimate.scaleToDefault), forControlEvents: .TouchDragExit)
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
