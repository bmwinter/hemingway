//
//  SMSVerification.swift
//  MIXR
//
//  Created by Nilesh Patel on 04/11/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit


class SMSVerification: UITableViewController {
    
    @IBOutlet weak var phoneInput: UITextField!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    override func viewDidLoad() {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)

        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
//        self.navigationItem.rightBarButtonItem = self.btnDone;
        self.title = "Verify"
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func btnVerifyClicked (sender:AnyObject){
        self.performSegueWithIdentifier("SettingsSegue", sender: nil)
    }
    @IBAction func btnResendClicked (sender:AnyObject){
        self.performSegueWithIdentifier("SettingsSegue", sender: nil)
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
