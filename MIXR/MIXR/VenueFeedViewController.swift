
//
//  FirstViewController.swift
//  MIXR
//
//  Created by Brendan Winter on 10/2/15.
//  Copyright (c) 2015 MIXR LLC. All rights reserved.
//

import UIKit
let isLocalData = false

class VenueFeedViewController:UIViewController, UITableViewDelegate,UITableViewDataSource,APIConnectionDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var feedsArray : NSMutableArray = NSMutableArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        //performSelector(Selector(setFrames()), withObject: nil, afterDelay: 1.0)
        self.loadData()
    }
    
    func loadData()
    {
        if (isLocalData)
        {
            feedsArray.addObject(["venueName":"Mad River1","venueImage":"venueImage1.jpg","userName":"Grant Boyle1"])
            feedsArray.addObject(["venueName":"Mad River2","venueImage":"venueImage2.jpg","userName":"Grant Boyle2"])
            feedsArray.addObject(["venueName":"Mad River3","venueImage":"venueImage3.jpg","userName":"Grant Boyle3"])
            feedsArray.addObject(["venueName":"Mad River4","venueImage":"venueImage4.jpg","userName":"Grant Boyle4"])
            feedsArray.addObject(["venueName":"Mad River5","venueImage":"venueImage5.jpg","userName":"Grant Boyle5"])
            feedsArray.addObject(["venueName":"Mad River6","venueImage":"venueImage6.jpg","userName":"Grant Boyle6"])
            feedsArray.addObject(["venueName":"Mad River7","venueImage":"venueImage7.jpg","userName":"Grant Boyle7"])
            feedsArray.addObject(["venueName":"Mad River8","venueImage":"venueImage8.jpg","userName":"Grant Boyle8"])
            feedsArray.addObject(["venueName":"Mad River9","venueImage":"venueImage9.jpg","userName":"Grant Boyle9"])
            feedsArray.addObject(["venueName":"Mad River10","venueImage":"venueImage10.jpg","userName":"Grant Boyle10"])
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
    
    @IBAction func onFeedClicked(sender: AnyObject)
    {
        let feedBtn : UIButton = sender as! UIButton
        let feedTag = feedBtn.superview!.tag
        NSLog("feedTag = \(feedTag)")
        let feedDict : NSDictionary = feedsArray[feedTag] as! NSDictionary

        
        let postViewController : PostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("post") as! PostViewController
        postViewController.feedDict = feedDict
        self.navigationController!.pushViewController(postViewController, animated: true)
    }
    
    override func viewDidLayoutSubviews()
    {
        tableView.frame = CGRect(x: 0.0, y: 44, width: view.frame.size.width, height: view.frame.size.height - 44 - 48)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        return feedsArray.count;
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as! UserFeedCell
        
        let feedDict : NSDictionary = feedsArray[indexPath.row] as! NSDictionary
        cell.contentView.tag = indexPath.row
        cell.venuImageView.image = UIImage(named: feedDict["venueImage"] as! String)
        cell.FeedName.text = feedDict["venueName"] as? String
        cell.lblUserName.text = feedDict["userName"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("indexpath.row = \(indexPath.row)")
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - APIConnection Delegate -
    
    func connectionFailedForAction(action: Int, andWithResponse result: NSDictionary!, method : String)
    {
        switch action
        {
        case APIName.Venues.rawValue:
            if ( result != nil)
            {
                if ( result.isKindOfClass(NSDictionary))
                {
                    DLog("\(result)")
                }
            }
            
        default:
            DLog("Nothing")
        }
    }
    
    func connectionDidFinishedErrorResponceForAction(action: Int, andWithResponse result: NSDictionary!, method : String)
    {
        switch action
        {
        case APIName.Venues.rawValue:
            if ( result != nil)
            {
                if ( result.isKindOfClass(NSDictionary))
                {
                    DLog("\(result)")
                }
            }
            
        default:
            DLog("Nothing")
        }
        
    }
    
    func connectionDidFinishedForAction(action: Int, andWithResponse result: NSDictionary!, method : String)
    {
        switch action
        {
        case APIName.Venues.rawValue:
            
            if ( result != nil)
            {
                if ( result.isKindOfClass(NSDictionary))
                {
                    feedsArray = result["data"] as! NSMutableArray
                    reloadTable()
                }
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

