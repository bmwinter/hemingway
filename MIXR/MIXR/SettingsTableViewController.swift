//
//  SettingsTableViewController.swift
//  MIXR
//
//  Created by Nilesh Patel on 31/10/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

enum settingsTag:Int {
    case editProfile
    case changePassword
    case changeName
    case privacyPolicy
    case termsAndCondition
    case logout
}

class SettingsTableViewController: UITableViewController {
    /*
    // Table View delegate methods
    */
    override func viewDidLoad()
    {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
        self.title = "Settings"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    @IBAction func settingsButtonTapped (sender:AnyObject)
    {
        let button = sender as? UIButton
        switch (button?.tag)
        {
        case settingsTag.editProfile.rawValue? :
            let postViewController : PostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PostViewController") as! PostViewController
            postViewController.isUserProfile = true
            self.navigationController!.pushViewController(postViewController, animated: true)
            print("Edit Profile")
            
        case settingsTag.changePassword.rawValue? :
            //self.performSegueWithIdentifier("ChangePassword", sender: nil)
            let aChangePassword : ChangePassword = self.storyboard!.instantiateViewControllerWithIdentifier("ChangePassword") as! ChangePassword
            self.navigationController!.pushViewController(aChangePassword, animated: true)
            print("Change password")
            
        case settingsTag.changeName.rawValue? :
            let aNotificationViewController : NotificationViewController = self.storyboard!.instantiateViewControllerWithIdentifier("NotificationViewController") as! NotificationViewController
            self.navigationController!.pushViewController(aNotificationViewController, animated: true)
            //self.performSegueWithIdentifier("Notification", sender: nil)
            print("Change Name")
            
        case settingsTag.privacyPolicy.rawValue? :
            let aVenueProfileTableViewController : VenueProfileTableViewController = self.storyboard!.instantiateViewControllerWithIdentifier("VenueProfileTableViewController") as! VenueProfileTableViewController
            self.navigationController!.pushViewController(aVenueProfileTableViewController, animated: true)
            //self.performSegueWithIdentifier("VenueProfile", sender: nil)
            print("Privary Policy")
            
        case settingsTag.termsAndCondition.rawValue? :
            let followingViewController : FollowingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FollowingViewController") as! FollowingViewController
            //postViewController.feedDict = feedDict
            self.navigationController!.pushViewController(followingViewController, animated: true)
            print("Terms & Condition")
            
        case settingsTag.logout.rawValue? :
            print("Logout")
        default :
            print("Test 1")
        }
        
    }
    
    /*
    // getSettingsData used to retrieve user settings data
    */
    
    func getSettingsData(){
        let parameters = [
            "userID": "1"
        ]
        
        let URL =  globalConstants.kAPIURL + globalConstants.kSettingAPIEndPoint
        
        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                guard let value = response.result.value else {
                    print("Error: did not receive data")
                    return
                }
                
                guard response.result.error == nil else {
                    print("error calling POST")
                    print(response.result.error)
                    return
                }
                let post = JSON(value)
                print("The post is: " + post.description)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    
}
