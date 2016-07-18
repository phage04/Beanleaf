//
//  SideMenu.swift
//  OnionApps
//
//  Created by Lyle Christianne Jover on 18/07/2016.
//  Copyright © 2016 OnionApps. All rights reserved.
//

import UIKit
import SideMenu

class SideMenu: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let menuItem: [String] = ["Menu", "Coupons", "Rewards", "Reservations", "Locations", "Feedback"]
    let menuImages: [String] = ["menuIcon1", "menuIcon2", "menuIcon3", "menuIcon4", "menuIcon5", "menuIcon6"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        SideMenuManager.menuAnimationTransformScaleFactor = 1
//        SideMenuManager.menuAnimationFadeStrength = 0
//        SideMenuManager.menuShadowOpacity = 0.25
//        SideMenuManager.menuFadeStatusBar = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = COLOR2
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItem.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("SideMenuCell") as? SideMenuCell {
            
            cell.configureCell(menuItem[indexPath.row], image: UIImage(named: "\(menuImages[indexPath.row])")!)
            cell.backgroundColor = COLOR2
            return cell
            
        } else {
            return UITableViewCell()
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }

}
