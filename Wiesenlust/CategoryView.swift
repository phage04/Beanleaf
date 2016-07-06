//
//  CategoryView.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 05/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit

class CategoryView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let dishes:[String] = ["Awesome Burger", "Cool Burger", "Tasty Burger", "Big Burger"]
    let images:[String] = ["Awesome", "Cool", "Tasty", "Big"]
    var categorySelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = COLOR1
        
        
        navigationItem.title = categorySelected
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:nil)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //SEGUES GOES HERE
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as? CategoryCell {
            cell.contentView.clipsToBounds = false
            cell.clipsToBounds = false
            cell.selectionStyle = .None
            cell.configureCell(dishes[indexPath.row],dishImg: images[indexPath.row])
            return cell
            
        } else {
            return UITableViewCell()
        }

    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

}
