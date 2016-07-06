//
//  ItemView.swift
//  Wiesenlust
//
//  Created by Lyle Christianne Jover on 06/07/2016.
//  Copyright © 2016 Wiesenlust. All rights reserved.
//

import UIKit

class ItemView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dishImg: UIImageView!
    
    @IBOutlet weak var price: UILabel!
  
    @IBOutlet weak var circleView: UIView!
    
    @IBOutlet weak var starBtn: UIButton!
    
    @IBOutlet weak var starCount: UILabel!
    
    var dishImgName = ""
    var dishPrice = "4€"
    var starCountVal = 453
    var dishName = ""
    var dishDesc = "Lorem ipsum keme keme keme 48 years balaj sudems at sangkatuts at jowabelles jowabelles ng at bakit na ang kasi shogal chapter at ang keme borta kasi at bakit doonek fayatollah kumenis at nang wiz at bakit valaj chuckie at bakit tetetet na valaj wiz at bakit matod nang shonga shongaers bakit na ang chaka valaj shonga at ang waz kemerloo shonget nang na buya bongga kasi ang balaj tetetet biway sa planggana antibiotic pinkalou klapeypey-klapeypey shonget nang buya tungril cheapangga bonggakea mahogany at Mike ang chopopo bakit na ang nang at nang , at bakit dites katol jowabelles nang chipipay dites shogal sa at pamenthol ma-kyonget emena gushung ganders at ang nang na ang shala balaj guash shontis ng oblation na ang majubis at bakit. Lorem ipsum keme keme keme 48 years balaj sudems at sangkatuts at jowabelles jowabelles ng at bakit na ang kasi shogal chapter at ang keme borta kasi at bakit doonek fayatollah kumenis at nang wiz at bakit valaj chuckie at bakit tetetet na valaj wiz at bakit matod nang shonga shongaers bakit na ang chaka valaj shonga at ang waz kemerloo shonget nang na buya bongga kasi ang balaj tetetet biway sa planggana antibiotic pinkalou klapeypey-klapeypey shonget nang buya tungril cheapangga bonggakea mahogany at Mike ang chopopo bakit na ang nang at nang , at bakit dites katol jowabelles nang chipipay dites shogal sa at pamenthol ma-kyonget emena gushung ganders at ang nang na ang shala balaj guash shontis ng oblation na ang majubis at bakit."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.whiteColor()
        
        
        navigationItem.title = dishName

        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image:UIImage(named: "menuBtn1x.png"), style:.Plain, target:self, action:nil)
        if dishImgName != "" {
           dishImg.image = UIImage(named: dishImgName)
        }
        
        starBtn.setImage(UIImage(named: "starFull1x")!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        starBtn.tintColor = COLOR_YELLOW
        starCount.font = UIFont(name: font1Light, size: 12)
        starCount.textColor = UIColor.whiteColor()
        starCount.text = "\(starCountVal)"
        price.textColor = UIColor.whiteColor()
        price.font = UIFont(name: font1Light, size: 24)
        price.text = "\(dishPrice)"
        
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.backgroundColor = COLOR2
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as? ItemCell {
            cell.contentView.clipsToBounds = false
            cell.clipsToBounds = false
            cell.selectionStyle = .None
            cell.configureCell(dishName, dishDesc: dishDesc)
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
    }
}
