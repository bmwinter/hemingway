
//
//  FirstViewController.swift
//  MIXR
//
//  Created by Brendan Winter on 10/2/15.
//  Copyright (c) 2015 MIXR LLC. All rights reserved.
//

import UIKit
import SwiftyJSON

class VenueFeedViewController:UIViewController {
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        //performSelector(Selector(setFrames()), withObject: nil, afterDelay: 1.0)
    }
    
    @IBAction func onUserProfileClicked(sender: AnyObject)
    {
        //let feedDict : NSDictionary = feedsArray[feedTag].dictionaryObject!
        let postViewController : PostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("post") as! PostViewController
        //postViewController.feedDict = feedDict
        self.navigationController!.pushViewController(postViewController, animated: true)
        
        // let feedDict : NSDictionary = ["venueName":"App User","venueImage":"venueImage1.jpg","userName":"AppUser Name"]
        // let postViewController : UserProfileViewController = self.storyboard!.instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
        // postViewController.feedDict = feedDict
        // self.navigationController!.pushViewController(postViewController, animated: true)
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return false
    }
}

