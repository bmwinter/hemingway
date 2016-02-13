//
//  NotificationViewController.swift
//  MIXR
//
//  Created by macMini on 02/12/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    let feedsArray      : NSMutableArray = NSMutableArray()
    let promotersArray  : NSMutableArray = NSMutableArray()
    let followingRequestArray  : NSMutableArray = NSMutableArray()
    
    @IBOutlet var tblViewNotification: UITableView!
    @IBOutlet weak var followRequestTableView: UITableView!
    
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
        self.refreshControl!.attributedTitle = NSAttributedString(string: "")
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
        feedsArray.addObject(["venueName":"Jennifer Lawrence like your photo","venueImage":"venueImage1.jpg","userHr":"1"])
        feedsArray.addObject(["venueName":"Mark Houser like your photo","venueImage":"venueImage2.jpg","userHr":"2"])
        feedsArray.addObject(["venueName":"Carl Stuart like your photo","venueImage":"venueImage3.jpg","userHr":"3"])
        feedsArray.addObject(["venueName":"James Huccane like your photo","venueImage":"venueImage4.jpg","userHr":"4"])
        feedsArray.addObject(["venueName":"Mawra Samuaels like your photo","venueImage":"venueImage5.jpg","userHr":"4"])
        feedsArray.addObject(["venueName":"James Carles like your photo","venueImage":"venueImage6.jpg","userHr":"6"])
        feedsArray.addObject(["venueName":"Heman Hasstle like your photo","venueImage":"venueImage7.jpg","userHr":"7"])
        feedsArray.addObject(["venueName":"George Stapheny like your photo","venueImage":"venueImage8.jpg","userHr":"12"])
        feedsArray.addObject(["venueName":"Simon Hughs like your photo","venueImage":"venueImage9.jpg","userHr":"16"])
        feedsArray.addObject(["venueName":"Leon Smith like your photo","venueImage":"venueImage10.jpg","userHr":"22"])
        
        promotersArray.addObject(["promoters":"Coupon 1","userHr":"1"])
        promotersArray.addObject(["promoters":"Coupon 2","userHr":"2"])
        promotersArray.addObject(["promoters":"Coupon 3","userHr":"4"])
        promotersArray.addObject(["promoters":"Coupon 4","userHr":"12"])
        promotersArray.addObject(["promoters":"Coupon 5","userHr":"13"])
        promotersArray.addObject(["promoters":"Coupon 6","userHr":"14"])
        promotersArray.addObject(["promoters":"Coupon 7","userHr":"16"])
        promotersArray.addObject(["promoters":"Coupon 8","userHr":"17"])
        promotersArray.addObject(["promoters":"Coupon 9","userHr":"19"])
        promotersArray.addObject(["promoters":"Coupon 10","userHr":"23"])
        
        
        followingRequestArray.addObject(["followingReques":"Jennifer Lawrence wants to follow you","userImage":"venueImage1.jpg","userHr":"1"])
        followingRequestArray.addObject(["followingReques":"Mark Houser wants to follow you","userImage":"venueImage2.jpg","userHr":"2"])
        followingRequestArray.addObject(["followingReques":"Carl Stuart wants to follow you","userImage":"venueImage3.jpg","userHr":"3"])
        followingRequestArray.addObject(["followingReques":"James Huccane wants to follow you","userImage":"venueImage4.jpg","userHr":"4"])
        followingRequestArray.addObject(["followingReques":"Mawra Samuaels wants to follow you","userImage":"venueImage5.jpg","userHr":"4"])
        followingRequestArray.addObject(["followingReques":"James Carles wants to follow you","userImage":"venueImage6.jpg","userHr":"6"])
        followingRequestArray.addObject(["followingReques":"Heman Hasstle wants to follow you","userImage":"venueImage7.jpg","userHr":"7"])
        followingRequestArray.addObject(["followingReques":"George Stapheny wants to follow you","userImage":"venueImage8.jpg","userHr":"12"])
        followingRequestArray.addObject(["followingReques":"Simon Hughs wants to follow you","userImage":"venueImage9.jpg","userHr":"16"])
        followingRequestArray.addObject(["followingReques":"Leon Smith wants to follow you","userImage":"venueImage10.jpg","userHr":"22"])
    }
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    //  MARK:- segmentedControl Delegate -
    @IBAction func indexChanged(sender: AnyObject)
    {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.followRequestTableView.hidden = true
            self.tblViewNotification.hidden = false
            (segmentedControl.subviews[1] as UIView).tintColor = UIColor(red: 83/255.0, green:135/255.0, blue: 50/255.0, alpha: 1.0)
            print("following tab selected")
            break;
        case 1:
            self.followRequestTableView.hidden = true
            self.tblViewNotification.hidden = false
            
            (segmentedControl.subviews[0] as UIView).tintColor = UIColor(red: 83/255.0, green:135/255.0, blue: 50/255.0, alpha: 1.0)
            print("Second Segment selected")
            break;
            
        case 2:
            self.followRequestTableView.hidden = false
            self.tblViewNotification.hidden = true
            print("follow Request selected")
            break;
        default:
            break; 
        }
        
        if (segmentedControl.selectedSegmentIndex == 2)
        {
            self.followRequestTableView.reloadData()
        }
        else
        {
            self.tblViewNotification.reloadData()
        }
    }
    
    //  MARK:- Tableview Delegates -
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        if (tableView != self.followRequestTableView)
        {
            if(segmentedControl.selectedSegmentIndex == 0)
            {
                return feedsArray.count
            }
            else if(segmentedControl.selectedSegmentIndex == 1 && tableView != self.followRequestTableView)
            {
                return promotersArray.count
            }
            else
            {
                return 0
            }
        }
        else
        {
            if(segmentedControl.selectedSegmentIndex == 2)
            {
                return followingRequestArray.count
                
            }
            else
            {
                return 0
            }
        }
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if (tableView != self.followRequestTableView)
        {
            if(segmentedControl.selectedSegmentIndex == 0)
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NotificationCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                let feedDict : NSDictionary = feedsArray[indexPath.row] as! NSDictionary
                cell.userPic.image = UIImage(named: feedDict["venueImage"] as! String)
                let notificationString = "\(feedDict["venueName"] as! String) \(feedDict["userHr"] as! String) hours ago."
                cell.notificationText.text = notificationString
                cell.notificationTimeStamp.text = feedDict["userHr"] as? String
                cell.notificationTimeStamp.hidden = true
                //cell.notificationTimeStamp.frame = CGRectMake(146,21, 42, 21)
                cell.userPic.hidden = false
                return cell
                
            }
            else if(segmentedControl.selectedSegmentIndex == 1 && tableView != self.followRequestTableView)
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NotificationCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                let feedDict : NSDictionary = promotersArray[indexPath.row] as! NSDictionary
                cell.notificationText.text = feedDict["promoters"] as? String
                cell.notificationTimeStamp.text = "\(feedDict["userHr"] as! String) hr"
                cell.notificationTimeStamp.hidden = false
                //cell.notificationTimeStamp.frame = CGRectMake(220, 15, 42, 21)
                cell.userPic.hidden = true
                return cell
                
            }
            else
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NotificationCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
        }
        else
        {
            if(segmentedControl.selectedSegmentIndex == 2)
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FollowingRequestCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                let feedDict : NSDictionary = followingRequestArray[indexPath.row] as! NSDictionary
                cell.followingRequestLbl.text = feedDict["followingReques"] as? String
                cell.userPic.image = UIImage(named: feedDict["userImage"] as! String)
                //cell.notificationTimeStamp.frame = CGRectMake(220, 15, 42, 21)
                cell.userPic.hidden = false
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FollowingRequestCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
        }
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
