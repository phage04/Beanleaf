//
//  Menu.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 05/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit
import CoreData
import Auk
import moa
import Contentful
import Alamofire
import SwiftSpinner
import SideMenu

class Menu: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    


    
    override func viewDidLoad() {
        super.viewDidLoad()

             
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.Plain, target:self, action:#selector(Menu.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:#selector(Menu.showMenu))
        
        navigationController?.navigationBarHidden = false
        
        scrollView.delegate = self
        scrollView.auk.settings.contentMode = .ScaleAspectFill
        scrollView.auk.settings.pageControl.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.30)
        scrollView.auk.settings.pageControl.marginToScrollViewBottom = 4.0
        scrollView.auk.settings.pageControl.pageIndicatorTintColor = COLOR2
        scrollView.auk.settings.pageControl.currentPageIndicatorTintColor = COLOR1
        
        scrollView.auk.show(url: "http://eblogfa.com/wp-content/uploads/2014/01/burger-chesseburger-fastfood.jpg")
        scrollView.auk.show(url: "http://robertsboxedmeats.ca/wp-content/uploads/2011/07/TGIF_Stacked-Burger-LR-1.jpg")
        scrollView.auk.show(url: "http://eatburgerburger.com/wp-content/uploads/2016/01/burger-slide-1.jpg")
        scrollView.auk.startAutoScroll(delaySeconds: 2)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.collectionViewLayout = CustomImageFlowLayout.init()
        self.collectionView.backgroundColor = COLOR1
        mainView.backgroundColor = COLOR1
        

        
        
        
        
    }
    func showMenu() {
        performSegueWithIdentifier("menuSegue", sender: nil)
    }
    override func viewWillLayoutSubviews() {
     collectionView.collectionViewLayout.invalidateLayout()    
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
        self.collectionView.reloadData()
    }
    

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesData.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let catItem = categoriesData[indexPath.row]
        
        performSegueWithIdentifier("categorySegue", sender: catItem.valueForKey("name"))
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MenuCategoryCell", forIndexPath: indexPath) as? MenuCategoryCell {

            let catItem = categoriesData[indexPath.row]
            
            cell.configureCell("\(catItem.valueForKey("name")!)", imgData: catItem.valueForKey("image") as! NSData)
    
            return cell
        } else {
            
            return UICollectionViewCell()
            
        }
    }
    
    func backButtonPressed(sender:UIButton) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "categorySegue" {
            if let selectedCategory = segue.destinationViewController as? CategoryView{
                if let catSelect = sender as? String {
                    selectedCategory.categorySelected = catSelect
                }
            }
        }
    }

}
