//
//  Menu.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 05/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit
import Auk
import moa
import Contentful


class Menu: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categoriesTemp = Dictionary<String, String>()
    var categories = [String]()
    static var imageCache = NSCache()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        client.fetchEntries(["content_type": "category"]).1.next {
           self.categories.removeAll()
            
           for entry in $0.items{
                self.categoriesTemp.updateValue("\(entry.fields["categoryName"]!)", forKey: "\(entry.fields["order"]!)")
                
           }
            
           let sortedCat = self.categoriesTemp.sort{ $0.0 < $1.0 }
            for cat in sortedCat {
                self.categories.append(cat.1)
            }
           self.collectionView.reloadData()
        }

        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "backBtn1x.png"), style:.Plain, target:self, action:#selector(Menu.backButtonPressed(_:)));
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:nil)
        
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
    
    override func viewWillLayoutSubviews() {
     collectionView.collectionViewLayout.invalidateLayout()    
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("categorySegue", sender: "\(categories[indexPath.row])")
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MenuCategoryCell", forIndexPath: indexPath) as? MenuCategoryCell {
            
            cell.configureCell("\(categories[indexPath.row])", imgURL: "http://eblogfa.com/wp-content/uploads/2014/01/burger-chesseburger-fastfood.jpg")
    
            return cell
        } else {
            
            return UICollectionViewCell()
            
        }
    }
    
    
    func backButtonPressed(sender:UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
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
