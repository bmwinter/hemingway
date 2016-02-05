//
//  NotificationViewController.swift
//  MIXR
//
//  Created by macMini on 02/12/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    let feedsArray : NSMutableArray = NSMutableArray()
    let promotersArray : NSMutableArray = NSMutableArray()
    @IBOutlet var tblViewNotification: UITableView!
    var refreshControl:UIRefreshControl!
    
    //  MARK:- ViewLifecycle -
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.navigationController?.interactivePopGestureRecognizer!.delegate =  self
        //self.navigationController?.interactivePopGestureRecognizer!.enabled = true        
        //self.tblViewNotification.hidden = true
        // Do any additional setup after loading the view.
        (segmentedControl.subviews[1] as UIView).tintColor = UIColor(red: 83/255.0, green:135/255.0, blue: 50/255.0, alpha: 1.0)
        self.pullToReferesh()
        self.loadData()
        
    }
    
    func pullToReferesh()
    {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Updating")
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tblViewNotification.addSubview(self.refreshControl!)
    }
    
    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        self.performSelector(Selector("endReferesh"), withObject: nil, afterDelay: 1.0)
    }
    
    func endReferesh()
    {
        //End refresh control
        self.refreshControl?.endRefreshing()
        //Remove refresh control to superview
        //self.refreshControl?.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  MARK:- Function to add feedsarray -
    func loadData()
    {
        feedsArray.addObject(["venueName":"Mad River1","venueImage":"venueImage1.jpg","userHr":"1 hr"])
        feedsArray.addObject(["venueName":"Mad River2","venueImage":"venueImage2.jpg","userHr":"12 hr"])
        feedsArray.addObject(["venueName":"Mad River3","venueImage":"venueImage3.jpg","userHr":"8 hr"])
        feedsArray.addObject(["venueName":"Mad River4","venueImage":"venueImage4.jpg","userHr":"20 hr"])
        feedsArray.addObject(["venueName":"Mad River5","venueImage":"venueImage5.jpg","userHr":"30 hr"])
        feedsArray.addObject(["venueName":"Mad River6","venueImage":"venueImage6.jpg","userHr":"6 hr"])
        feedsArray.addObject(["venueName":"Mad River7","venueImage":"venueImage7.jpg","userHr":"7 hr"])
        feedsArray.addObject(["venueName":"Mad River8","venueImage":"venueImage8.jpg","userHr":"12 hr"])
        feedsArray.addObject(["venueName":"Mad River9","venueImage":"venueImage9.jpg","userHr":"4 hr"])
        feedsArray.addObject(["venueName":"Mad River10","venueImage":"venueImage10.jpg","userHr":"8 hr"])
        
        promotersArray.addObject(["promoters":"Coupon 1","userHr":"1 hr"])
        promotersArray.addObject(["promoters":"Coupon 2","userHr":"12 hr"])
        promotersArray.addObject(["promoters":"Coupon 3","userHr":"8 hr"])
        promotersArray.addObject(["promoters":"Coupon 4","userHr":"20 hr"])
        promotersArray.addObject(["promoters":"Coupon 5","userHr":"30 hr"])
        promotersArray.addObject(["promoters":"Coupon 6","userHr":"6 hr"])
        promotersArray.addObject(["promoters":"Coupon 7","userHr":"7 hr"])
        promotersArray.addObject(["promoters":"Coupon 8","userHr":"12 hr"])
        promotersArray.addObject(["promoters":"Coupon 9","userHr":"4 hr"])
        promotersArray.addObject(["promoters":"Coupon 10","userHr":"8 hr"])
        
    }
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    //  MARK:- segmentedControl Delegate -
    @IBAction func indexChanged(sender: AnyObject)
    {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            
            self.tblViewNotification.hidden = false
            (segmentedControl.subviews[1] as UIView).tintColor = UIColor(red: 83/255.0, green:135/255.0, blue: 50/255.0, alpha: 1.0)
            print("following tab selected")
        case 1:
            self.tblViewNotification.hidden = false
            
            (segmentedControl.subviews[0] as UIView).tintColor = UIColor(red: 83/255.0, green:135/255.0, blue: 50/255.0, alpha: 1.0)
            print("Second Segment selected")
        default:
            break; 
        }
        
        self.tblViewNotification.reloadData()
        
    }
    
    //  MARK:- Tableview Delegates -
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        if(segmentedControl.selectedSegmentIndex == 0)
        {
            return feedsArray.count
        }
        else
        {
            return promotersArray.count
        }
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NotificationCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if(segmentedControl.selectedSegmentIndex == 0)
        {
            let feedDict : NSDictionary = feedsArray[indexPath.row] as! NSDictionary
            cell.userPic.image = UIImage(named: feedDict["venueImage"] as! String)
            cell.notificationText.text = feedDict["venueName"] as? String
            cell.notificationTimeStamp.text = feedDict["userHr"] as? String
            //cell.notificationTimeStamp.frame = CGRectMake(146,21, 42, 21)
            cell.userPic.hidden = false
        }
        else
        {
            let feedDict : NSDictionary = promotersArray[indexPath.row] as! NSDictionary
            cell.notificationText.text = feedDict["promoters"] as? String
            cell.notificationTimeStamp.text = feedDict["userHr"] as? String
            //cell.notificationTimeStamp.frame = CGRectMake(220, 15, 42, 21)
            cell.userPic.hidden = true
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("indexpath.row = \(indexPath.row)")
        if (segmentedControl.selectedSegmentIndex == 1)
        {
            let aPromotionDetailViewController : PromotionDetailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PromotionDetailViewController") as! PromotionDetailViewController
            self.navigationController!.pushViewController(aPromotionDetailViewController, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
