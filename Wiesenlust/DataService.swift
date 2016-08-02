//
//  DataService.swift
//  Onion Apps
//
//  Created by Lyle Christianne Jover on 02/08/2016.
//  Copyright © 2016 OnionApps. All rights reserved.
//

import Foundation
//
//  DataService.swift
//  NeverHaveIEver
//
//  Created by Lyle Christianne Jover on 19/05/2016.
//  Copyright © 2016 Lyle Christianne Jover. All rights reserved.
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
    
    
    func logInAnonymously(completion: (result: Bool) -> Void) {
        
        
        FIRAuth.auth()?.signInAnonymouslyWithCompletion({ (user, error) in
            completion(result: true)
            NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: "userId")
            print("Firebase log in successful ID: \(user?.uid)")
            
        })
        
        
    }
    
    func signOut() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch {
            print("Sign out error")
        }
    }
    
    
    
}