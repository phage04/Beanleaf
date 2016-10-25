//
//  CategoryView.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 05/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.


import UIKit
import SideMenu
class CategoryView: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    var dishes = [FoodItem]()
    var filteredDishes = [FoodItem]()
    var categorySelected = ""
    var refreshControl: UIRefreshControl!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        if listView {
            self.logo.isHidden = false
            self.mainView.backgroundColor = UIColor.lightGray
            self.tableView.backgroundColor = UIColor.clear
        }else {
            self.logo.isHidden = true
            self.mainView.backgroundColor = UIColor.white
            self.tableView.backgroundColor = COLOR1
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = COLOR2
        refreshControl.addTarget(self, action: #selector(Coupons.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        navigationItem.title = categorySelected
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.plain, target:self, action:#selector(CategoryView.showMenu))
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.search
        searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        
        for each in foodItemsData {
            if "\(each.value(forKey: "category")!)" == categorySelected {
                
                dishes.append(FoodItem(id: "\(each.value(forKey: "id"))",cat: each.value(forKey: "category")! as! String, name: each.value(forKey: "name")! as! String, desc: each.value(forKey: "descriptionInfo")! as? String, price: each.value(forKey: "price")! as! Double, image: UIImage(data: each.value(forKey: "image") as! Data), imgURL: each.value(forKey: "imageURL")! as? String, key: each.value(forKey: "key")! as! String, likes: each.value(forKey: "likes") as? Int))
            }
        }

   
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.showsCancelButton = true
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            tableView.reloadData()
        } else {
            inSearchMode = true
            filterContentForSearchText(searchBar.text!)
            
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        inSearchMode = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        view.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        filteredDishes = dishes.filter { dish in
            
            return dish.name.lowercased().contains(searchText.lowercased())
            
        }
        tableView.reloadData()
    }
    
    
    
    func showMenu() {
        performSegue(withIdentifier: "menuSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredDishes.count
        }
        return dishes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if inSearchMode{
            performSegue(withIdentifier: "itemSegue", sender: filteredDishes[(indexPath as NSIndexPath).row])
        }else{
            performSegue(withIdentifier: "itemSegue", sender: dishes[(indexPath as NSIndexPath).row])
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if listView {
            return 120
        } else {
            return 249
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoryCell {
            cell.layer.anchorPointZ = CGFloat((indexPath as NSIndexPath).row)
            cell.contentView.clipsToBounds = false
            cell.backgroundColor = cell.contentView.backgroundColor
            cell.clipsToBounds = false
            cell.selectionStyle = .none
            
            if inSearchMode{
                 cell.configureCell(filteredDishes[(indexPath as NSIndexPath).row])
            }else{
                 cell.configureCell(dishes[(indexPath as NSIndexPath).row])
            }
           
            
            return cell
            
        } else {
            return UITableViewCell()
        }

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemSegue" {
            if let selectedItem = segue.destination as? ItemView{
                if let itemSelect = sender as? FoodItem {
                    selectedItem.dish = itemSelect
                }
            }
        }
    }
    
    func refresh(_ sender:AnyObject) {
        tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    


    

}
