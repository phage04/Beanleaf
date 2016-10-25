//
//  Menu.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 05/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftSpinner
import SideMenu
import Auk

class Menu: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var logo: UIImageView!

    var inSearchMode = false
    var refreshControl: UIRefreshControl!
    
    var filteredDishes = [FoodItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

             
        navigationItem.backBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.plain, target:self, action:#selector(Menu.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.plain, target:self, action:#selector(Menu.showMenu))
        
        navigationController?.isNavigationBarHidden = false
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.search
        searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        
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
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.font = UIFont(name: "\(font1Light)", size: 14)
        
        scrollView.delegate = self
        
        scrollView.auk.settings.contentMode = .scaleAspectFill
        scrollView.auk.settings.pageControl.pageIndicatorTintColor = COLOR2
        scrollView.auk.settings.pageControl.currentPageIndicatorTintColor = COLOR1
        scrollView.auk.settings.pageControl.backgroundColor = UIColor.gray.withAlphaComponent(0.30)
        scrollView.auk.settings.pageControl.marginToScrollViewBottom = 4.0
        setupPageControl(visible: true)
        
        scrollView.auk.startAutoScroll(delaySeconds: 2)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.collectionViewLayout = CustomImageFlowLayout.init()
        self.collectionView.backgroundColor = COLOR1
        self.tableView.isHidden = true
        mainView.backgroundColor = COLOR1
        
    }
    
    
    
    func setupPageControl(visible: Bool){
        

        if visible{
            
            if announcementsData.count > 0 {
                for data in announcementsData {
                    scrollView.auk.show(image: UIImage(data: data.value(forKey: "image") as! Data)!)
                    
                }
                scrollView.auk.settings.pageControl.visible = true
            }
            
           
        } else{
            scrollView.auk.removeAll()
            scrollView.auk.settings.pageControl.visible = false
        }
       
       
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func hideMenuScroll() {
        collectionView.isHidden = true
        setupPageControl(visible: false)
        scrollView.isHidden = true
        tableView.isHidden = false
        
    
    }
    
    func showMenuScroll() {
        collectionView.isHidden = false
        setupPageControl(visible: true)
        scrollView.isHidden = false
        tableView.isHidden = true
        
       
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
        hideMenuScroll()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        inSearchMode = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        showMenuScroll()
        view.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideMenuScroll()
        view.endEditing(true)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        filteredDishes = dishesMain.filter { dish in
            
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
        return dishesMain.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if inSearchMode{
            performSegue(withIdentifier: "itemSegue", sender: filteredDishes[(indexPath as NSIndexPath).row])
        }else{
            performSegue(withIdentifier: "itemSegue", sender: dishesMain[(indexPath as NSIndexPath).row])
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
                cell.configureCell(dishesMain[(indexPath as NSIndexPath).row])
            }
            
            
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func refresh(_ sender:AnyObject) {
        tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    override func viewWillLayoutSubviews() {
     collectionView.collectionViewLayout.invalidateLayout()    
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        self.collectionView.reloadData()
    }
    

    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let catItem = categoriesData[(indexPath as NSIndexPath).row]
        
        performSegue(withIdentifier: "categorySegue", sender: catItem.value(forKey: "name"))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCategoryCell", for: indexPath) as? MenuCategoryCell {

            let catItem = categoriesData[(indexPath as NSIndexPath).row]
            
            cell.configureCell("\(catItem.value(forKey: "name")!)", imgData: catItem.value(forKey: "image") as! Data)
    
            return cell
        } else {
            
            return UICollectionViewCell()
            
        }
    }
    
    func backButtonPressed(_ sender:UIButton) {
       _ = navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "itemSegue" {
            if let selectedItem = segue.destination as? ItemView{
                if let itemSelect = sender as? FoodItem {
                    selectedItem.dish = itemSelect
                }
            }
        }
        if segue.identifier == "categorySegue" {
            if let selectedCategory = segue.destination as? CategoryView{
                if let catSelect = sender as? String {
                    selectedCategory.categorySelected = catSelect
                }
            }
        }
    }

}
