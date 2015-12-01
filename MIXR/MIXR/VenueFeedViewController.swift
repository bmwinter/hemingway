
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        //performSelector(Selector(setFrames()), withObject: nil, afterDelay: 1.0)

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
        cell.venuImageView.image = UIImage(named: "venueImage\(indexPath.row+1).jpg")
        cell.FeedName.text = "Mad River \(indexPath.row)"
        cell.lblUserName.text = "Grant Boyle \(indexPath.row)"
        return cell
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

