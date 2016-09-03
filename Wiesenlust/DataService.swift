//
//  DataService.swift
//  Onion Apps
//
//  Created by Lyle Christianne Jover on 02/08/2016.
//  Copyright © 2016 OnionApps. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth


let baseData = FIRDatabase.database().reference()

public class DataService {
    
    
    public static let ds = DataService()
    
    var REF_ITEM = baseData.child("item")
    var REF_LIKES = baseData.child("likes")
    var REF_COUPONUSES = baseData.child("couponUses")
    var REF_REWARDCLAIMS = baseData.child("rewardClaims")
    var REF_COUPONREPORT = baseData.child("couponReport")
    var REF_STAMPREPORT = baseData.child("stampReport")
    
    
    func logInAnonymously(completion: (result: Bool) -> Void) {
        
        
        FIRAuth.auth()!.signInAnonymouslyWithCompletion({ (user, error) in
            completion(result: true)
            NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: "userId")
            print("Firebase log in successful ID: \(user?.uid)")
            
        })
        
        
    }
    
 
    
    
    
}