//
//  NewsFeedTableViewController.swift
//  MIXR
//
//  Created by imac04 on 1/9/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

let isLocalData = false

class NewsFeedTableViewController:UITableViewController,APIConnectionDelegate {
    
    var feedcount : Int = 0
    var feedsArray : Array<JSON> = []
    //var feedsArray : NSArray <JSON> = NSMutableArray()
    //var refreshControl:UIRefreshControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.pullToReferesh()
        
        view.backgroundColor = UIColor.clearColor()
        //performSelector(Selector(setFrames()), withObject: nil, afterDelay: 1.0)
    }
    
    func pullToReferesh()
    {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Updating")
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
    }
    
    func refresh(sender:AnyObject)
    {
        feedcount = 0
        self.loadData()
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
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true
    }

    override func viewDidAppear(animated: Bool) {
        self.loadData()
        super.viewDidAppear(true)
    }

    func loadData()
    {
        if (isLocalData)
        {
            feedsArray = [["venueName":"Mad River1","venueImage":"venueImage1.jpg","userName":"Grant Boyle1"],
                ["venueName":"Mad River2","venueImage":"venueImage2.jpg","userName":"Grant Boyle2"],
                ["venueName":"Mad River3","venueImage":"venueImage3.jpg","userName":"Grant Boyle3"],
                ["venueName":"Mad River4","venueImage":"venueImage4.jpg","userName":"Grant Boyle4"],
                ["venueName":"Mad River5","venueImage":"venueImage5.jpg","userName":"Grant Boyle5"],
                ["venueName":"Mad River6","venueImage":"venueImage6.jpg","userName":"Grant Boyle6"],
                ["venueName":"Mad River7","venueImage":"venueImage7.jpg","userName":"Grant Boyle7"],
                ["venueName":"Mad River8","venueImage":"venueImage8.jpg","userName":"Grant Boyle8"],
                ["venueName":"Mad River9","venueImage":"venueImage9.jpg","userName":"Grant Boyle9"],
                ["venueName":"Mad River10","venueImage":"venueImage10.jpg","userName":"Grant Boyle10"]]
            reloadTable()
            
        }
        else
        {
            self.getAllNewsFeed();
//            let param: Dictionary = Dictionary<String, AnyObject>()
//            //call API for to get venues
//            let object = APIConnection().POST(APIName.Venues.rawValue, withAPIName: "VenueList", withMessage: "", withParam: param, withProgresshudShow: true, withHeader: false) as! APIConnection
//            object.delegate = self
            
        }
    }
    
    // MARK: Retrieve All News Feed data.
    func getAllNewsFeed(){
        
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)

        var tokenString = "token "
        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
        }
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(tokenString, forKey: "Authorization")
        
        let URL =  globalConstants.kAPIURL + globalConstants.kAllNewsFeed
        
        //        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue("application/json", forKey: "Accept")
        
        
        Alamofire.request(.GET, URL , parameters: nil, encoding: .JSON)
            .responseString { response in
                
                appDelegate.stopAnimation()
                guard let value = response.result.value else {
                    print("Error: did not receive data")
                    return
                }
                
                guard response.result.error == nil else {
                    print("error calling POST on Login")
                    print(response.result.error)
                    return
                }
                
                
                let post = JSON(value)
                if let string = post.rawString() {
                    let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                    
                    if response.response?.statusCode == 400{
                        print("The Response Error is:   \(response.response?.statusCode)")
                        
                        if let val = responseDic?["code"] {
                            if val[0].isEqualToString("13") {
                                //                                print("Equals")
                                self.displayCommonAlert(responseDic?["detail"]?[0] as! String)
                                return
                            }
                            // now val is not nil and the Optional has been unwrapped, so use it
                        }
                        
                        if let errorData = responseDic?["detail"] {
                            
                            let errorMessage = errorData[0] as! String
                            self.displayCommonAlert(errorMessage)
                            return;
                        }
                    }
                }
        }
    }
    
    //MARK: convertStringObject to Dictionary
    
    func convertStringToDictionary(text:String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    /*
    // Common alert method need to be used to display alert, by passing alert string as parameter to it.
    */
    
    func displayCommonAlert(alertMesage : NSString){
        
        let alertController = UIAlertController (title: globalConstants.kAppName, message: alertMesage as String?, preferredStyle:.Alert)
        let okayAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        alertController.addAction(okayAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    

    
    func reloadTable()
    {
        tableView.reloadData()
    }
    
    @IBAction func onUserBtnClicked(sender: AnyObject)
    {
        // let postViewController : ProfileTableViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ProfileTableViewController") as! ProfileTableViewController
        // //postViewController.feedDict = feedDict
        // self.navigationController!.pushViewController(postViewController, animated: true)
        // return
        
        let feedBtn : UIButton = sender as! UIButton
        let feedTag = feedBtn.superview!.tag
        NSLog("feedTag = \(feedTag)")
        //let feedDict : NSDictionary = feedsArray[feedTag].dictionaryObject!
        let postViewController : PostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PostViewController") as! PostViewController
        postViewController.isUserProfile = false
        self.navigationController!.pushViewController(postViewController, animated: true)
    }
    
    @IBAction func onFeedClicked(sender: AnyObject)
    {
        let aVenueProfileViewController : VenueProfileViewController = self.storyboard!.instantiateViewControllerWithIdentifier("VenueProfileViewController") as! VenueProfileViewController
        self.navigationController!.pushViewController(aVenueProfileViewController, animated: true)
        
        return
        
        let followingViewController : FollowingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FollowingViewController") as! FollowingViewController
        self.navigationController!.pushViewController(followingViewController, animated: true)
        
        return;
        let feedBtn : UIButton = sender as! UIButton
        let feedTag = feedBtn.superview!.tag
        NSLog("feedTag = \(feedTag)")
        let feedDict : NSDictionary = feedsArray[feedTag].dictionaryObject!
        
        
        let postViewController : PostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PostViewController") as! PostViewController
        postViewController.isUserProfile = false
        self.navigationController!.pushViewController(postViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        return feedsArray.count;
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as! UserFeedCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        //let feedDict : Dictionary <String, JSON> = feedsArray[indexPath.row]
        cell.contentView.tag = indexPath.row
        
        cell.venuImageView.image = UIImage(named: feedsArray[indexPath.row]["venueImage"].string!)
        cell.FeedName.text = feedsArray[indexPath.row]["venueName"].string
        cell.lblUserName.text = feedsArray[indexPath.row]["userName"].string
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "martiniglass_iconNew.png")
        let attachmentString = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: " ")
        myString.appendAttributedString(attachmentString)
        myString.appendAttributedString(NSMutableAttributedString(string: " 250"))
        cell.lblLike.attributedText = myString
        
        /*
        cell.venuImageView.image = UIImage(named: feedDict["venueImage"] as! String)
        cell.FeedName.text = feedDict["venueName"] as? String
        cell.lblUserName.text = feedDict["userName"] as? String
        */
        if((indexPath.row == (feedsArray.count-2)) && feedsArray.count > 8)
        {
            self.loadData()
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("indexpath.row = \(indexPath.row)")
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
    
    // Configure the cell...
    
    return cell
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }    
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - APIConnection Delegate -
    
    func connectionFailedForAction(action: Int, andWithResponse result: Dictionary <String, JSON>!, method : String)
    {
        switch action
        {
        case APIName.Venues.rawValue:
            if ( result != nil)
            {
                DLog("\(result)")
            }
            
        default:
            DLog("Nothing")
        }
    }
    
    func connectionDidFinishedErrorResponceForAction(action: Int, andWithResponse result: Dictionary <String, JSON>!, method : String)
    {
        switch action
        {
        case APIName.Venues.rawValue:
            if ( result != nil)
            {
                DLog("\(result)")
                
            }
            
        default:
            DLog("Nothing")
        }
        
    }
    
    func connectionDidFinishedForAction(action: Int, andWithResponse result:Dictionary <String, JSON>!, method : String)
    {
        switch action
        {
        case APIName.Venues.rawValue:
            
            if ( result != nil)
            {
                DLog("\(result)")
                
                if(feedcount == 0)
                {
                    feedsArray = result["data"]!.arrayValue
                    feedcount = feedsArray.count
                }
                else
                {
                    if(feedsArray.count > 0)
                    {
                        var newData : Array<JSON> = result["data"]!.arrayValue
                        
                        for (var cnt = 0; cnt < newData.count ; cnt++)
                        {
                            feedsArray.append(newData[cnt])
                        }
                        
                        feedcount = feedsArray.count
                    }
                }
                reloadTable()
            }
            DLog("Venue")
            
        default:
            DLog("Nothing")
        }
    }
    
    func connectionDidUpdateAPIProgress(action: Int,bytesWritten: Int64, totalBytesWritten: Int64 ,totalBytesExpectedToWrite: Int64)
    {
        
    }
    
}


