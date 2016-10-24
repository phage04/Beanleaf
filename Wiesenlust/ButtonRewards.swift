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
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.backgroundColor = UIColor.clear.cgColor
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont(name: font1Regular, size: 18.0) 
        setupAnimation()
    }
    
    
    func setupAnimation() {
        
        self.addTarget(self, action: #selector(ButtonRewards.scaleToSmall), for: .touchDown)
        self.addTarget(self, action: #selector(ButtonRewards.scaleToSmall), for: .touchDragEnter)
        self.addTarget(self, action: #selector(ButtonRewards.scaleAnimation), for: .touchUpInside)
        self.addTarget(self, action: #selector(ButtonRewards.scaleToDefault), for: .touchDragExit)
    }
    
    func scaleToSmall() {
        let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim?.toValue = NSValue(cgSize: CGSize(width: 0.95, height: 0.95))
        self.layer.pop_add(scaleAnim, forKey: "layerScaleSmallAnimation")
    }
    
    
    func scaleAnimation() {
        let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim?.velocity = NSValue(cgSize: CGSize(width: 3.0, height: 3.0))
        scaleAnim?.toValue = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))
        scaleAnim?.springBounciness = 18
        self.layer.pop_add(scaleAnim, forKey: "layerScaleSpringAnimation")
        
    }
    
    func scaleToDefault() {
        let scaleAnim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnim?.toValue = NSValue(cgSize: CGSize(width: 1, height: 1))
        self.layer.pop_add(scaleAnim, forKey: "layerScaleDefaultAnimation")
    }


}
