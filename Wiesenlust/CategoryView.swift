//
//  CategoryView.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 05/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.


import UIKit
import SideMenu
class CategoryView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var dishes = [FoodItem]()
    var categorySelected = ""
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clearColor()
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = COLOR2
        refreshControl.addTarget(self, action: #selector(Coupons.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        navigationItem.title = categorySelected
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:#selector(CategoryView.showMenu))

        
        for each in foodItemsData {
            
            if "\(each.valueForKey("category")!)" == categorySelected {
                
                dishes.append(FoodItem(id: "\(each.valueForKey("id"))",cat: each.valueForKey("category")! as! String, name: each.valueForKey("name")! as! String, desc: each.valueForKey("descriptionInfo")! as? String, price: each.valueForKey("price")! as! Double, image: UIImage(data: each.valueForKey("image") as! NSData), imgURL: each.valueForKey("imageURL")! as? String, key: each.valueForKey("key")! as! String, likes: each.valueForKey("likes") as? Int))
            }
        }

   
    }
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    func showMenu() {
        performSegueWithIdentifier("menuSegue", sender: nil)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("itemSegue", sender: dishes[indexPath.row])
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as? CategoryCell {
            cell.layer.anchorPointZ = CGFloat(indexPath.row)
            cell.contentView.clipsToBounds = false
            cell.backgroundColor = cell.contentView.backgroundColor
            cell.clipsToBounds = false
            cell.selectionStyle = .None
            cell.configureCell(dishes[indexPath.row])
            
            return cell
            
        } else {
            return UITableViewCell()
        }

    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "itemSegue" {
            if let selectedItem = segue.destinationViewController as? ItemView{
                if let itemSelect = sender as? FoodItem {
                    selectedItem.dish = itemSelect
                }
            }
        }
    }
    
    func refresh(sender:AnyObject) {
        tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    


    

}
