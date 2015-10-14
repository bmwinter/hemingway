//
//  ProfileTableViewController.swift
//  MIXR
//
//  Created by Nilesh Patel on 12/10/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit
class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var status: UIButton!
    @IBOutlet weak var followers: UIButton!
    @IBOutlet weak var following: UIButton!
    @IBOutlet weak var biography: UITextView!
    @IBOutlet weak var favBars: UITextView!

    
    /*
    // Table View delegate methods
    */
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}