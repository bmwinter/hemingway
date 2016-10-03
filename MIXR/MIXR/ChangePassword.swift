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
    
    var oldPassword: String? {
        return currentPassword.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    var newPassword: String? {
        return changePassword.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    private let connection = APIConnection()
    
    override func viewDidLoad() {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        //        self.navigationItem.rightBarButtonItem = self.doneButton
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
        self.title = "Change Password"
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        //self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func doneButtonTapped (sender:AnyObject)
    {
        self.currentPassword.resignFirstResponder()
        self.changePassword.resignFirstResponder()
        self.confirmPassword.resignFirstResponder()

        let currentPasswordString = self.currentPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let changePasswordString = self.changePassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let confirmPasswordString = self.confirmPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        if currentPasswordString.isEmpty{
            self.displayCommonAlert(globalConstants.kCurrentPassword)
            return
        }
        
        if changePasswordString.isEmpty{
            self.displayCommonAlert(globalConstants.kNewPassword)
            return
        }
        
        if confirmPasswordString.isEmpty{
            self.displayCommonAlert(globalConstants.kconfirmPasswordError)
            return
        }

        if !compareTwoPassword(changePasswordString, conformPassword: confirmPasswordString){
            self.displayCommonAlert(globalConstants.kpasswordconfirmPasswordError)
            return
        }

        self.changePasswordAPICall()
        
    }
    
    /*
    // Compare two password
    */
    
    func compareTwoPassword (password: String, conformPassword : NSString) -> Bool{
        return (password == conformPassword)
    }

    @IBAction func settingsButtonTapped (sender:AnyObject){
        
    }
    
    /*
    // getSettingsData used to retrieve user settings data
    */
    
    func changePasswordAPICall() {
        if let old = oldPassword, new = newPassword {
            APIManager.sharedInstance.changePassword(old: old,
                                                     new: new,
                                                     success: { [weak self] (response) in
                                                        if let _ = response["confirmation"].string {
                                                            self?.navigationController?.popToRootViewControllerAnimated(true)
                                                        }
                }, failure: { (error) in
                                                        
            })
        }
        
        
//        let parameters = [
//            "password_old": currentPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
//            "password_new": changePassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//        ]
//
//        
//        let URL =  globalConstants.kAPIURL + globalConstants.kChangePasswordAPIEndPoint
//        
//        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
//            .responseJSON { response in
//                guard let value = response.result.value else {
//                    print("Error: did not receive data")
//                    return
//                }
//                
//                guard response.result.error == nil else {
//                    print("error calling POST")
//                    print(response.result.error)
//                    return
//                }
//                let post = JSON(value)
//                print("The post is: " + post.description)
//                if let string = post.rawString() {
//                    let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
//                    
//                    if response.response?.statusCode == 400{
//                        print("The Response Error is:   \(response.response?.statusCode)")
//                        if let errorData = responseDic?["detail"] {
//                            //let errorMessage = errorData[0] as! String
//                            let errorMessage = (errorData as? NSArray)?[0] as! String
//                            self.displayCommonAlert(errorMessage)
//                            return;
//                        }
//                    }
//                    
//                    if (responseDic?["confirmation"]) != nil {
//                        self.navigationController?.popToRootViewControllerAnimated(true)
//                    }
//                }
//
//        }
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
