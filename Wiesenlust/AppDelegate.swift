//
//  AppDelegate.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 01/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import CoreLocation



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        //check if anything is set to backup on icloud
        let directories = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        if let documentDirectory = directories.first {
            do {
                let documents = try FileManager.default.contentsOfDirectory(atPath: documentDirectory)
                for files in documents {
                    let urlForm = URL(fileURLWithPath: documentDirectory + "/" + files)
                    do {
                        try print("\(files): \((urlForm as NSURL).resourceValues(forKeys: [URLResourceKey.isExcludedFromBackupKey]))")
                    } catch {
                        print("can't find key")
                    }
                }
            } catch {
                print("can't retrieve contents")
            }
        }
        
        // Override point for customization after application launch.
        
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.localNotification] as? UILocalNotification {
            
            if notification.alertTitle == "Time" {
                UIApplication.shared.openURL(URL(string: socialURLWeb)!)
            }
            if notification.alertTitle == "Location" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = self.window?.rootViewController as? UINavigationController
                let destinationController = storyboard.instantiateViewController(withIdentifier: "Coupons") as? Coupons
                navigationController?.pushViewController(destinationController!, animated: false)
            }
            
        }
        
        UINavigationBar.appearance().barTintColor = COLOR1
        UINavigationBar.appearance().tintColor = COLOR2
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : UIFont(name: font1Medium, size: 20)!, NSForegroundColorAttributeName : COLOR2]
        
        // Register for remote notifications
    
        // [START register_for_notifications]

        
        // [END register_for_notifications]
        
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        IQKeyboardManager.sharedManager().enable = true
        
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification),
                                                         name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
    

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        connectToFcm()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "io.OnionApps.Wiesenlust" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Wiesenlust", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        let urlSHM = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite-shm")
        let urlWAL = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite-wal")
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            //prevent icloud back up of coredata
            self.addSkipBackupAttributeToItemAtURL(url)
            self.addSkipBackupAttributeToItemAtURL(urlSHM)
            self.addSkipBackupAttributeToItemAtURL(urlWAL)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    

    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Print message ID.
        //print("Message ID: \(userInfo["gcm.message_id"]!)")
        // Print full message.
        print("%@", userInfo)
        

    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        // Do something serious in a real app.
        print("Received Local Notification: \(notification.alertBody)")
       
        if notification.alertTitle == "Write us a review" {
            UIApplication.shared.openURL(URL(string: socialURLWeb)!)
        }
        if notification.alertTitle == "Nearby Offer" {
            validForLocationOffer = true
            Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(AppDelegate.switchLocCoupon), userInfo: nil, repeats: false)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = self.window?.rootViewController as? UINavigationController
            let destinationController = storyboard.instantiateViewController(withIdentifier: "Coupons") as? Coupons
            navigationController?.pushViewController(destinationController!, animated: false)
        }
       
    }
    
    func switchLocCoupon() {
        print("Toggled Location Flag To False.")
        validForLocationOffer = false
    }
    

    func addSkipBackupAttributeToItemAtURL(_ URL:Foundation.URL) -> Bool
    {
        
        var success: Bool
        do {
            try (URL as NSURL).setResourceValue(true, forKey:URLResourceKey.isExcludedFromBackupKey)
            success = true
            print("Success excluding \(URL.lastPathComponent)")
        } catch let error as NSError {
            success = false
            print("Error excluding \(URL.lastPathComponent) from backup \(error)")
        }
        
        return success
    }
  
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token(){
            print("InstanceID token: \(refreshedToken)")
        }        
    
        connectToFcm()
    }
   
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    func handleRegionEvent(_ region: CLRegion!) {
        
        let locNotif: UILocalNotification = UILocalNotification()
        locNotif.alertBody = "You are near our \(region.identifier) branch! Come on over within the next hour, here's a special discount."
        locNotif.soundName = UILocalNotificationDefaultSoundName
        locNotif.userInfo = ["location": "near"]
        locNotif.alertTitle = "Nearby Offer"
        locNotif.fireDate = Date(timeIntervalSinceNow: 1)
       
        UIApplication.shared.scheduleLocalNotification(locNotif)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleRegionEvent(region)
            print("Entry detected \(region.identifier)")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleRegionEvent(region)
            print("Exit detected: \(region.identifier)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
    
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        
        if identifier == "editList" {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "modifyListNotification"), object: nil)
        }
                
        completionHandler()
    }
    


}

