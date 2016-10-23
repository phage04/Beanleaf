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

class Menu: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UISearchBarDelegate {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!

    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

             
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.plain, target:self, action:#selector(Menu.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.plain, target:self, action:#selector(Menu.showMenu))
        
        navigationController?.isNavigationBarHidden = false
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.font = UIFont(name: "\(font1Light)", size: 14)
        
        
        scrollView.delegate = self
        scrollView.auk.settings.contentMode = .scaleAspectFill
        scrollView.auk.settings.pageControl.backgroundColor = UIColor.gray.withAlphaComponent(0.30)
        scrollView.auk.settings.pageControl.marginToScrollViewBottom = 4.0
        scrollView.auk.settings.pageControl.pageIndicatorTintColor = COLOR2
        scrollView.auk.settings.pageControl.currentPageIndicatorTintColor = COLOR1
        
        
        if announcementsData.count > 0 {
            for data in announcementsData {
                scrollView.auk.show(image: UIImage(data: data.value(forKey: "image") as! Data)!)
               
            }
            
        }
        scrollView.auk.startAutoScroll(delaySeconds: 2)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.collectionViewLayout = CustomImageFlowLayout.init()
        self.collectionView.backgroundColor = COLOR1
        mainView.backgroundColor = COLOR1
        

        
        
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.showsCancelButton = true
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            //tableView.reloadData()
            print("Not searching")
        } else {
            inSearchMode = true
            //filterContentForSearchText(searchBar.text!)
            print("\(searchBar.text)")
            
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        inSearchMode = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        view.endEditing(true)
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func showMenu() {
        performSegue(withIdentifier: "menuSegue", sender: nil)
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
        if segue.identifier == "categorySegue" {
            if let selectedCategory = segue.destination as? CategoryView{
                if let catSelect = sender as? String {
                    selectedCategory.categorySelected = catSelect
                }
            }
        }
    }

}
