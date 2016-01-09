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
    override func viewDidLoad() {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
        self.title = "Settings"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func settingsButtonTapped (sender:AnyObject)
    {
        let button = sender as? UIButton
        switch (button?.tag) {
        case settingsTag.editProfile.rawValue? :
            self.performSegueWithIdentifier("ProfileScreenSegue", sender: nil)
            print("Edit Profile")
        case settingsTag.changePassword.rawValue? :
            self.performSegueWithIdentifier("ChangePassword", sender: nil)
            print("Change password")
        case settingsTag.changeName.rawValue? :
            self.performSegueWithIdentifier("Notification", sender: nil)
            print("Change Name")
        case settingsTag.privacyPolicy.rawValue? :
            self.performSegueWithIdentifier("VenueProfile", sender: nil)
            print("Privary Policy")
        case settingsTag.termsAndCondition.rawValue? :
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
