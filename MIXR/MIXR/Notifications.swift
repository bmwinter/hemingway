//
//  Notifications.swift
//  MIXR
//
//  Created by Nilesh Patel on 22/11/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit


class Notifications: UITableViewController {
    
    let notificationCellIdentifier = "NotificationCell"
    let promotionsCellIdentifier = "PromotionsCell"

    @IBOutlet weak var segment : UISegmentedControl!
    
    override func viewDidLoad() {
        
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
        self.title = "Notifications"
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func settingsButtonTapped (sender:AnyObject){
        
    }
    /*
    // Table View delegate methods
    */
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: (UITableView!), heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if(segment.selectedSegmentIndex == 0){
            return notificationCell(indexPath)
        }else{
            return promotionsCell(indexPath)
        }
    }
    
    func notificationCell(indexPath:NSIndexPath) -> NotificationCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(notificationCellIdentifier) as! NotificationCell
        cell.notificationText.text = "This is test notification";
        cell.notificationTimeStamp.text = "1 hr";
        cell.userPic.image = UIImage(named: "Chcked")
        
        cell.cellBGView.layer.masksToBounds = true
        cell.cellBGView.layer.cornerRadius = 5.0
        cell.cellBGView.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        return cell
    }
    
    func promotionsCell(indexPath:NSIndexPath) -> PromotionsCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(promotionsCellIdentifier) as! PromotionsCell
        cell.notificationText.text = "This is test promotions";
        cell.notificationTimeStamp.text = "1 hr";
        
        cell.cellBGView.layer.masksToBounds = true
        cell.cellBGView.layer.cornerRadius = 5.0
        cell.cellBGView.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:false)
        self.performSegueWithIdentifier("Promotions", sender: nil)
        
    }

    
}
