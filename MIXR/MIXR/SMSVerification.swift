//
//  SMSVerification.swift
//  MIXR
//
//  Created by Nilesh Patel on 04/11/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


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
        self.checkVerificationCode();
//        self.performSegueWithIdentifier("SettingsSegue", sender: nil)
    }
    @IBAction func btnResendClicked (sender:AnyObject){
//        self.performSegueWithIdentifier("SettingsSegue", sender: nil)
    }

    @IBAction func settingsButtonTapped (sender:AnyObject){
        
    }
    
    
    /*
    // checkVerificationCode used to check user entered verification code with server
    */
    
    func getVerificationCode(){
        let parameters = [
            "phone_number": "+919428117839"
                //phoneInput.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
        ]
        
        let URL =  globalConstants.kAPIURL + globalConstants.kGetVerificationCode
        
        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
            .responseString { response in
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

    func checkVerificationCode(){
        let parameters = [
            "phone_number": "+919428117839",
            "code": "5626"
            //phoneInput.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
        ]
        
        let URL =  globalConstants.kAPIURL + globalConstants.kVerifyCodeAPIEndPoint
        
        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
            .responseString { response in
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
        return 3
    }
    
    
}
