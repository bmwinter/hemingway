//
//  UserFeedViewController.swift
//  MIXR
//
//  Created by Brendan Winter on 10/2/15.
//  Copyright (c) 2015 MIXR LLC. All rights reserved.
//

import UIKit
import Foundation
extension NSURL{
    /* An extension on the NSURL class that allows us to retrieve the current
    documents folder path */
    class func documentsFolder() -> NSURL{
        let fileManager = NSFileManager()
        return try! fileManager.URLForDirectory(.DocumentDirectory,
            inDomain: .UserDomainMask,
            appropriateForURL: nil,
            create: false)
    }
}

class UserFeedViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let feedsArray : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.loadData()
        
        view.backgroundColor = UIColor.blackColor()
        //performSelector(Selector(setFrames()), withObject: nil, afterDelay: 1.0)
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
        return feedsArray.count;
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let feedDict : NSDictionary = feedsArray[indexPath.row] as! NSDictionary
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as! UserFeedCell
        cell.FeedName.text = feedDict["venueName"] as? String
        cell.lblUserName.text = feedDict["userName"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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

