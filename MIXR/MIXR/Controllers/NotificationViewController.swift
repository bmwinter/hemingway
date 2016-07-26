//
//  NotificationViewController.swift
//  MIXR
//
//  Created by macMini on 02/12/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class NotificationViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate
{
    let feedsArray      : NSMutableArray = NSMutableArray()
    let promotersArray  : NSMutableArray = NSMutableArray()
    var followingRequestArray  : NSMutableArray = NSMutableArray()
    
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
        self.refreshControl!.addTarget(self, action: #selector(NotificationViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tblViewNotification.addSubview(self.refreshControl!)
    }
    
    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        self.performSelector(#selector(NotificationViewController.endReferesh), withObject: nil, afterDelay: 1.0)
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
        
        promotersArray.addObject(["promoters":"Spanky's coupon valid until 1/2/2016","userHr":""])
        promotersArray.addObject(["promoters":"Jennifer's coupon valid until 2/2/2016","userHr":""])
        promotersArray.addObject(["promoters":"James Huccane's coupon valid until 4/2/2016","userHr":""])
        promotersArray.addObject(["promoters":"George Stapheny's coupon valid until 5/2/2016","userHr":""])
        promotersArray.addObject(["promoters":"Simon Hughs's coupon valid until 6/2/2016","userHr":""])
        promotersArray.addObject(["promoters":"Leon Smith's coupon valid until 7/2/2016","userHr":""])
        promotersArray.addObject(["promoters":"Heman Hasstle's coupon valid until 7/2/2016","userHr":""])
        promotersArray.addObject(["promoters":"Mawra Samuaels's coupon valid until 10/2/2016","userHr":""])
        promotersArray.addObject(["promoters":"Carl Stuart's coupon valid until 12/2/2016","userHr":""])
        promotersArray.addObject(["promoters":"Mark Houser's coupon valid until 13/2/2016","userHr":""])
        
        
        self.loadfollowingRequestData()
        /*
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
        */
    }
    
    func loadfollowingRequestData()
    {
        self.followingRequestArray.removeAllObjects()
        
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)
        
        var tokenString = "token "
        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
            
            let URL =  globalConstants.kAPIURL + globalConstants.kFollowRequestAPIEndPoint
            
            Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(tokenString, forKey: "authorization")
            let headers = [
                "Authorization": tokenString,
            ]
            
            Alamofire.request(.GET, URL , parameters: nil, encoding: .JSON, headers : headers)
                .responseString { response in

                    print("response \(response)")
                    appDelegate.stopAnimation()
                    
                    guard let value = response.result.value else
                    {
                        print("Error: did not receive data")
                        self.followRequestTableView.reloadData()
                        
                        return
                    }
                    
                    guard response.result.error == nil else
                    {
                        print("error calling POST on Login")
                        print(response.result.error)
                        self.followRequestTableView.reloadData()
                        
                        return
                    }
                    
                    let post = JSON(value)
                    if let string = post.rawString()
                    {
                        if (response.response?.statusCode == 400 || response.response?.statusCode == 401)
                        {
                            let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                            print("The Response Error is:   \(response.response?.statusCode)")
                            
                            if let val = responseDic?["code"]
                            {
                                if val[0].isEqualToString("13")
                                {
                                    //print("Equals")
                                    //self.displayCommonAlert(responseDic?["detail"]?[0] as! String)
                                    self.displayCommonAlert((responseDic?["detail"] as? NSArray)?[0] as! String)

                                    self.followRequestTableView.reloadData()
                                    
                                    return
                                }
                                // now val is not nil and the Optional has been unwrapped, so use it
                            }
                            
                            if let errorData = responseDic?["detail"]
                            {
                                
                                if let errorMessage = errorData as? String
                                {
                                    self.displayCommonAlert(errorMessage)
                                    
                                }
                                else if let errorMessage = errorData as? NSArray
                                {
                                    if let errorMessageStr = errorMessage[0] as? String
                                    {
                                        self.displayCommonAlert(errorMessageStr)
                                    }
                                }
                                self.followRequestTableView.reloadData()
                                return;
                            }
                           
                        }
                        else if (response.response?.statusCode == 200 || response.response?.statusCode == 201)
                        {
                            let responseArray:NSArray? = self.convertStringToArray(string)
                            if let searchArray = responseArray as? NSMutableArray
                            {
                                self.followingRequestArray = self.createDisplayArray(searchArray)
                                print("The Response self.followingRequestArray is:   \(self.followingRequestArray)")
                            }
                        }
                        else
                        {
                            
                        }
                        self.followRequestTableView.reloadData()
                    }
            }
        }
    }
    
    
    func createDisplayArray(inputArray :NSMutableArray)->NSMutableArray
    {
        let newData : NSMutableArray = []
        
        for cnt in 0  ..< inputArray.count
        {
            if let inputDict = inputArray[cnt] as? NSDictionary
            {
                let outPutDict :NSMutableDictionary = NSMutableDictionary(dictionary: inputDict)
                /*["followingReques":"Jennifer Lawrence wants to follow you","userImage":"venueImage1.jpg","userHr":"1"]
                {
                "image_url": "",
                "user_id": 66,
                "first_name": "sujal",
                "last_name": "bandhara"
                },
                
                */
              
                    if let first_nameStr = inputDict["first_name"] as? String
                    {
                        outPutDict.setValue("\(first_nameStr) \(inputDict["last_name"] as! String) wants to follow you", forKey: "followingReques")
                    }
                    
                    if let image_url_Str = inputDict["image_url"] as? String
                    {
                        outPutDict.setValue(image_url_Str, forKey: "userImage")
                    }
               
                
                outPutDict.setValue("1", forKey: "userHr")
                newData.addObject(outPutDict)
            }
        }
        return newData
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
        
        
        //if (segmentedControl.selectedSegmentIndex == 2)
        //{
        self.followRequestTableView.reloadData()
        //}
        //else
        //{
        self.tblViewNotification.reloadData()
        //}
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
                cell.notificationText.textAlignment = NSTextAlignmentFromCTTextAlignment(CTTextAlignment.Left)
                //cell.notificationText.backgroundColor = UIColor.yellowColor()
                return cell
            }
            else if(segmentedControl.selectedSegmentIndex == 1 && tableView != self.followRequestTableView)
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("NotificationPromotionCell", forIndexPath: indexPath) as! NotificationPromotionCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                let feedDict : NSDictionary = promotersArray[indexPath.row] as! NSDictionary
                cell.notificationText.text = feedDict["promoters"] as? String
                //cell.notificationTimeStamp.text = "\(feedDict["userHr"] as! String)"
                //cell.notificationTimeStamp.hidden = false
                //let superWidth : CGFloat = cell.frame.size.width// cell.notificationText.superview!.frame.size.width
                //cell.userPic.hidden = true
                
                cell.notificationText.textAlignment = NSTextAlignmentFromCTTextAlignment(CTTextAlignment.Left)
                //cell.notificationText.backgroundColor = UIColor.redColor()
                cell.notificationText.sizeToFit()
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NotificationCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                //cell.notificationText.backgroundColor = UIColor.blueColor()
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
                cell.acceptFollowRequestBtn.tag = indexPath.row
                cell.rejectFollowRequestBtn.tag = indexPath.row
                //cell.userPic.image = UIImage(named: feedDict["userImage"] as! String)
                if let imageNameStr = feedDict["image_url"] as? String
                {
                    if (imageNameStr.characters.count > 0)
                    {
                        //cell.imagePerson.image  = aImage
                        let URL = NSURL(string: imageNameStr)!
                        //let URL = NSURL(string: "https://avatars1.githubusercontent.com/u/1846768?v=3&s=460")!
                        
                        Request.addAcceptableImageContentTypes(["binary/octet-stream"])
                        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                            size: cell.userPic.frame.size,
                            radius: 0.0
                        )
                        cell.userPic.af_setImageWithURL(URL, placeholderImage: UIImage(named: "ALPlaceholder"), filter: filter, imageTransition: .None, completion: { (response) -> Void in
                            print("image: \(cell.userPic.image)")
                            print(response.result.value) //# UIImage
                            print(response.result.error) //# NSError
                        })
                        
                        //let placeholderImage = UIImage(named: "ALPlaceholder")!
                        //cell.imagePerson.af_setImageWithURL(URL, placeholderImage: placeholderImage)
                        
                    }
                    else
                    {
                        cell.userPic.image = UIImage(named:"ALPlaceholder")
                    }
                }
                else
                {
                    cell.userPic.image = UIImage(named:"ALPlaceholder")
                }

                //cell.notificationTimeStamp.frame = CGRectMake(220, 15, 42, 21)
                cell.userPic.hidden = false
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FollowingRequestCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.acceptFollowRequestBtn.tag = indexPath.row
                cell.rejectFollowRequestBtn.tag = indexPath.row
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
    
    @IBAction func onAcceptFollowRequestClicked(sender: AnyObject)
    {
        if let btn = sender as? UIButton
        {
            if (followingRequestArray.count > btn.tag)
            {
                let followRequestDict : NSDictionary = followingRequestArray[btn.tag] as! NSDictionary
                print("onAcceptFollowRequestClicked = \(btn.tag)")

                print("followRequestDict = \(followRequestDict)")
                if let user_idStr = followRequestDict["user_id"] as? Int
                {
                    print("user_idStr = \(user_idStr)")
                    print("follow_status = 3") //denied: 2 or accepted: 3
                    self.setResponseOfFollowRequest("\(user_idStr)", follow_status: "3")
                }
            }
        }
    }
    
    @IBAction func onRejectFollowRequestClicked(sender: AnyObject)
    {
        if let btn = sender as? UIButton
        {
            if (followingRequestArray.count > btn.tag)
            {
                let followRequestDict : NSDictionary = followingRequestArray[btn.tag] as! NSDictionary
                print("onRejectFollowRequestClicked = \(btn.tag)")
                
                print("followRequestDict = \(followRequestDict)")
                if let user_idStr = followRequestDict["user_id"] as? Int
                {
                    print("user_idStr = \(user_idStr)")
                    print("follow_status = 2") //denied: 2 or accepted: 3
                    self.setResponseOfFollowRequest("\(user_idStr)", follow_status: "2")
                }
            }
        }
    }
    
    func setResponseOfFollowRequest(owner_id:String,follow_status:String)
    {
        self.followingRequestArray.removeAllObjects()
        
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)
        
        var tokenString = "token "
        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
            
            let URL =  globalConstants.kAPIURL + globalConstants.kFollowRequestUpdateAPIEndPoint
            
            Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(tokenString, forKey: "authorization")
            let headers = [
                "Authorization": tokenString,
            ]
            
            let parameters = [
                "owner_id": owner_id,
                "follow_status":follow_status
            ]
            
            Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON, headers : headers)
                .responseString { response in
                    
                    print("response \(response)")
                    appDelegate.stopAnimation()
                    
                    guard let value = response.result.value else
                    {
                        print("Error: did not receive data")
                        self.loadData()
                        return
                    }
                    
                    guard response.result.error == nil else
                    {
                        print("error calling POST on Login")
                        print(response.result.error)
                        self.loadData()
                        return
                    }
                    
                    let post = JSON(value)
                    if let string = post.rawString()
                    {
                        if (response.response?.statusCode == 400 || response.response?.statusCode == 401)
                        {
                            let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                            print("The Response Error is:   \(response.response?.statusCode)")
                            
                            if let val = responseDic?["code"]
                            {
                                if val[0].isEqualToString("13")
                                {
                                    //print("Equals")
                                    //self.displayCommonAlert(responseDic?["detail"]?[0] as! String)
                                    self.displayCommonAlert((responseDic?["detail"] as? NSArray)?[0] as! String)

                                    self.loadData()
                                    
                                    return
                                }
                                // now val is not nil and the Optional has been unwrapped, so use it
                            }
                            
                            if let errorData = responseDic?["detail"]
                            {
                                
                                if let errorMessage = errorData as? String
                                {
                                    self.displayCommonAlert(errorMessage)
                                    
                                }
                                else if let errorMessage = errorData as? NSArray
                                {
                                    if let errorMessageStr = errorMessage[0] as? String
                                    {
                                        self.displayCommonAlert(errorMessageStr)
                                    }
                                }
                                self.loadData()
                                return;
                            }
                            
                        }
                        else if (response.response?.statusCode == 200 || response.response?.statusCode == 201)
                        {
                            print("The Response stringis:   \(string)")
                        }
                        else
                        {
                            
                        }
                        self.loadData()
                    }
            }
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
