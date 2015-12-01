
//
//  FirstViewController.swift
//  MIXR
//
//  Created by Brendan Winter on 10/2/15.
//  Copyright (c) 2015 MIXR LLC. All rights reserved.
//

import UIKit

class VenueFeedViewController:UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let feedsArray : NSMutableArray = NSMutableArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        //performSelector(Selector(setFrames()), withObject: nil, afterDelay: 1.0)
        self.loadData()
    }
    
    func loadData()
    {
        feedsArray.addObject(["venueName":"Mad River1","venueImage":"venueImage1.jpg","userName":"Grant Boyle "])
        feedsArray.addObject(["venueName":"Mad River2","venueImage":"venueImage2.jpg","userName":"Grant Boyle"])
        feedsArray.addObject(["venueName":"Mad River3","venueImage":"venueImage3.jpg","userName":"Grant Boyle"])
        feedsArray.addObject(["venueName":"Mad River4","venueImage":"venueImage4.jpg","userName":"Grant Boyle"])
        feedsArray.addObject(["venueName":"Mad River5","venueImage":"venueImage5.jpg","userName":"Grant Boyle"])
        feedsArray.addObject(["venueName":"Mad River6","venueImage":"venueImage6.jpg","userName":"Grant Boyle"])
        feedsArray.addObject(["venueName":"Mad River7","venueImage":"venueImage7.jpg","userName":"Grant Boyle"])
        feedsArray.addObject(["venueName":"Mad River8","venueImage":"venueImage8.jpg","userName":"Grant Boyle"])
        feedsArray.addObject(["venueName":"Mad River9","venueImage":"venueImage9.jpg","userName":"Grant Boyle"])
        feedsArray.addObject(["venueName":"Mad River10","venueImage":"venueImage10.jpg","userName":"Grant Boyle"])
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
        tableView.frame = CGRect(x: 0.0, y: 64, width: view.frame.size.width, height: view.frame.size.height - 64 - 48)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        return 10;
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

}

