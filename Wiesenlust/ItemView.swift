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

    
    fileprivate let kTableHeaderHeight: CGFloat = 300.0
    var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.tableView.backgroundColor = UIColor.white
        
        headerView = self.tableView.tableHeaderView
        self.tableView.tableHeaderView = nil
        self.tableView.addSubview(headerView)
        
        self.tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        self.tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        navigationItem.title = dish.name

        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.plain, target:self, action:#selector(ItemView.showMenu))

        
        if let image = dish.img as Data? {
            dishImg.image = UIImage(data: image)
        } else {
            dishImg.isHidden = true
        }
        DataService.ds.REF_ITEM.child("\(UserDefaults.standard.value(forKey: "userId")!)/\(dish.postRef)").observeSingleEvent(of: .value, with:
            { snapshot in
                
                
                if snapshot.value is NSNull {
                    self.starBtn.setImage(UIImage(named: "starEmpty1x")!.withRenderingMode(.alwaysTemplate), for: UIControlState())
                    self.starBtn.tintColor = COLOR_YELLOW
                } else {
                    self.starBtn.setImage(UIImage(named: "starFull1x")!.withRenderingMode(.alwaysTemplate), for: UIControlState())
                    self.starBtn.tintColor = COLOR_YELLOW
                }
                
        })
        
        DataService.ds.REF_LIKES.child("\(dish.postRef)/likes").observeSingleEvent(of: .value, with:
            { snapshot in
                if snapshot.value is NSNull {
                    self.starCount.text = "0"
                    
                } else {
                    self.starCount.text = "\(snapshot.value!)"
                    
                }
               
        })
        
        
        starCount.font = UIFont(name: font1Light, size: 12)
        starCount.textColor = UIColor.white
        
        price.textColor = UIColor.white
        price.font = UIFont(name: font1Light, size: 20)
        price.text = "\(currencyShort)\(dish.price)"
        
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.backgroundColor = COLOR2
        updateHeaderView()
    }
    func showMenu() {
        performSegue(withIdentifier: "menuSegue", sender: nil)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderView()
    }    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemCell {
            cell.contentView.clipsToBounds = false
            cell.clipsToBounds = false
            cell.selectionStyle = .none
            cell.configureCell(dish.name, dishDesc: dish.descriptionInfo)
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @IBAction func starBtnPressed(_ sender: AnyObject) {
        if checkConnectivity() {
            
            let user = UserDefaults.standard.value(forKey: "userId")!
            
            
            if let _ = self.dish {
                let ref = self.dish.postRef
                DataService.ds.REF_ITEM.child("\(user)/\(ref)").observeSingleEvent(of: .value, with:
                    { snapshot in
                        
                        
                        if snapshot.value is NSNull {
                            self.dish.adjustLikes(true, key: ref)
                            self.starBtn.setImage(UIImage(named: "starFull1x")!.withRenderingMode(.alwaysTemplate), for: UIControlState())
                            self.starBtn.tintColor = COLOR_YELLOW
                            self.starCount.text = "\(Int(self.starCount.text!)! + 1)"
                            DataService.ds.REF_ITEM.child("\(user)/\(self.dish.postRef)").setValue(true)
                        } else {
                            self.dish.adjustLikes(false, key: ref)
                            self.starBtn.setImage(UIImage(named: "starEmpty1x")!.withRenderingMode(.alwaysTemplate), for: UIControlState())
                            self.starBtn.tintColor = COLOR_YELLOW
                            self.starCount.text = "\(Int(self.starCount.text!)! - 1)"
                            DataService.ds.REF_ITEM.child("\(user)/\(ref)").removeValue()
                        }
                        
                })
                
            }
            
        }
    }
}
