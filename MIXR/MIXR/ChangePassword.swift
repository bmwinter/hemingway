//
//  ChangePassword.swift
//  MIXR
//
//  Created by Nilesh Patel on 04/11/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ChangePassword: UITableViewController {
    
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var changePassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    override func viewDidLoad() {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        //        self.navigationItem.rightBarButtonItem = self.doneButton
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
        self.title = "Change Password"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        //self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func doneButtonTapped (sender:AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func settingsButtonTapped (sender:AnyObject){
        
    }
    
    /*
    // getSettingsData used to retrieve user settings data
    */
    
    func changePasswordAPICall(){
        let parameters = [
            "currentPassword": currentPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            "changedPassword": changePassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        ]
        
        let URL =  globalConstants.kAPIURL + globalConstants.kChangePasswordAPIEndPoint
        
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
    
    /*
    // Table View delegate methods
    */
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
}
