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
    
    let menuItem: [String] = ["Home", "Menu", "Coupons", "Stamps", "Reservations", "Locations", "Feedback"]
    let menuImages: [String] = ["","menuIcon1", "menuIcon2", "menuIcon3", "menuIcon4", "menuIcon5", "menuIcon6"]
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItem.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as? SideMenuCell {
            
            cell.configureCell(menuItem[(indexPath as NSIndexPath).row], image: "\(menuImages[(indexPath as NSIndexPath).row])")
            cell.backgroundColor = COLOR2
            return cell
            
        } else {
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "\((indexPath as NSIndexPath).row)", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
