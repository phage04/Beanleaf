//
//  ItemView.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 06/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit
import SideMenu
class ItemView: UIViewController, UITableViewDelegate, UITableViewDataSource,  UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dishImg: UIImageView!
    
    @IBOutlet weak var price: UILabel!
  
    @IBOutlet weak var circleView: UIView!
    
    @IBOutlet weak var starBtn: UIButton!
    
    @IBOutlet weak var starCount: UILabel!
    
   
    var dish: FoodItem!

    
    private let kTableHeaderHeight: CGFloat = 300.0
    var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.tableView.backgroundColor = UIColor.whiteColor()
        
        headerView = self.tableView.tableHeaderView
        self.tableView.tableHeaderView = nil
        self.tableView.addSubview(headerView)
        
        self.tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        self.tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        navigationItem.title = dish.name

        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:#selector(ItemView.showMenu))

        
        if let image = dish.img as NSData? {
            dishImg.image = UIImage(data: image)
        } else {
            dishImg.hidden = true
        }
        DataService.ds.REF_ITEM.child("\(NSUserDefaults.standardUserDefaults().valueForKey("userId")!)/\(dish.postRef)").observeSingleEventOfType(.Value, withBlock:
            { snapshot in
                
                
                if snapshot.value is NSNull {
                    self.starBtn.setImage(UIImage(named: "starEmpty1x")!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
                    self.starBtn.tintColor = COLOR_YELLOW
                } else {
                    self.starBtn.setImage(UIImage(named: "starFull1x")!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
                    self.starBtn.tintColor = COLOR_YELLOW
                }
                
        })
        
        DataService.ds.REF_LIKES.child("\(dish.postRef)/likes").observeSingleEventOfType(.Value, withBlock:
            { snapshot in
                if snapshot.value is NSNull {
                    self.starCount.text = "0"
                    
                } else {
                    self.starCount.text = "\(snapshot.value!)"
                    
                }
               
        })
        
        
        starCount.font = UIFont(name: font1Light, size: 12)
        starCount.textColor = UIColor.whiteColor()
        
        price.textColor = UIColor.whiteColor()
        price.font = UIFont(name: font1Light, size: 24)
        price.text = "\(dish.price)€"
        
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.backgroundColor = COLOR2
        updateHeaderView()
    }
    func showMenu() {
        performSegueWithIdentifier("menuSegue", sender: nil)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderView()
    }    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: self.tableView.bounds.width, height: kTableHeaderHeight)
  
        if self.tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = self.tableView.contentOffset.y
            headerRect.size.height = -self.tableView.contentOffset.y
        }
        
        headerView.frame = headerRect
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as? ItemCell {
            cell.contentView.clipsToBounds = false
            cell.clipsToBounds = false
            cell.selectionStyle = .None
            cell.configureCell(dish.name, dishDesc: dish.descriptionInfo)
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    @IBAction func starBtnPressed(sender: AnyObject) {
        if checkConnectivity() {
            
            let user = NSUserDefaults.standardUserDefaults().valueForKey("userId")!
            
            
            if let ref = self.dish.postRef as? String {
                DataService.ds.REF_ITEM.child("\(user)/\(ref)").observeSingleEventOfType(.Value, withBlock:
                    { snapshot in
                        
                        
                        if snapshot.value is NSNull {
                            self.dish.adjustLikes(true, key: ref)
                            self.starBtn.setImage(UIImage(named: "starFull1x")!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
                            self.starBtn.tintColor = COLOR_YELLOW
                            self.starCount.text = "\(Int(self.starCount.text!)! + 1)"
                            DataService.ds.REF_ITEM.child("\(user)/\(self.dish.postRef)").setValue(true)
                        } else {
                            self.dish.adjustLikes(false, key: ref)
                            self.starBtn.setImage(UIImage(named: "starEmpty1x")!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
                            self.starBtn.tintColor = COLOR_YELLOW
                            self.starCount.text = "\(Int(self.starCount.text!)! - 1)"
                            DataService.ds.REF_ITEM.child("\(user)/\(ref)").removeValue()
                        }
                        
                })
                
            }
            
        }
    }
}
