//
//  NewsFeedTableViewController.swift
//  MIXR
//
//  Created by imac04 on 1/9/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit
import SwiftyJSON

let isLocalData = false

class NewsFeedTableViewController:UITableViewController,APIConnectionDelegate {
    
    var feedsArray : Array<JSON> = []
    //var feedsArray : NSArray <JSON> = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        view.backgroundColor = UIColor.clearColor()
        //performSelector(Selector(setFrames()), withObject: nil, afterDelay: 1.0)
        self.loadData()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
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
            let param: Dictionary = Dictionary<String, AnyObject>()
            //call API for to get venues
            let object = APIConnection().POST(APIName.Venues.rawValue, withAPIName: "VenueList", withMessage: "", withParam: param, withProgresshudShow: true, withHeader: false) as! APIConnection
            object.delegate = self
        }
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
        
        //let feedDict : Dictionary <String, JSON> = feedsArray[indexPath.row]
        cell.contentView.tag = indexPath.row
        
        cell.venuImageView.image = UIImage(named: feedsArray[indexPath.row]["venueImage"].string!)
        cell.FeedName.text = feedsArray[indexPath.row]["venueName"].string
        cell.lblUserName.text = feedsArray[indexPath.row]["userName"].string
        
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "martiniglass_icon.png")
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
                feedsArray = result["data"]!.arrayValue
                reloadTable()
                
                //                if ( result.isKindOfClass(NSDictionary))
                //                {
                //                    feedsArray = result["data"] as! NSMutableArray
                //                }
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


