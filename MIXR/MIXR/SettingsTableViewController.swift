//
//  SettingsTableViewController.swift
//  MIXR
//
//  Created by Nilesh Patel on 31/10/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//
import UIKit

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
    @IBAction func settingsButtonTapped (sender:AnyObject){

        let button = sender as? UIButton
        switch (button?.tag) {
        case settingsTag.editProfile.rawValue? :
            print("Edit Profile")
        case settingsTag.changePassword.rawValue? :
            print("Change password")
        case settingsTag.changeName.rawValue? :
            print("Change Name")
        case settingsTag.privacyPolicy.rawValue? :
            print("Privary Policy")
        case settingsTag.termsAndCondition.rawValue? :
            print("Terms & Condition")
        case settingsTag.logout.rawValue? :
            print("Logout")
        default :
            print("Test 1")
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    

}
