//
//  ChangePassword.swift
//  MIXR
//
//  Created by Nilesh Patel on 04/11/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit


class ChangePassword: UITableViewController {
    
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var changePassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    override func viewDidLoad() {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.navigationItem.rightBarButtonItem = self.doneButton

        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
        self.title = "Change Password"
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func doneButtonTapped (sender:AnyObject){
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func settingsButtonTapped (sender:AnyObject){
        
    }
    /*
    // Table View delegate methods
    */
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
}
