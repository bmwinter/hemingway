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

    /*
    // Common alert method need to be used to display alert, by passing alert string as parameter to it.
    */
    
    func displayCommonAlert(alertMesage : NSString){
        
        let alertController = UIAlertController (title: globalConstants.kAppName, message: alertMesage as String?, preferredStyle:.Alert)
        let okayAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        alertController.addAction(okayAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func settingsButtonTapped (sender:AnyObject){
        
    }
    
    /*
    // getSettingsData used to retrieve user settings data
    */
    
    func changePasswordAPICall()
    {
        let parameters = [
            "password_old": currentPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            "password_new": changePassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        ]
        var tokenString = "token "
        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
        }

        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(tokenString, forKey: "Authorization")

        
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
                if let string = post.rawString() {
                    let responseDic:[String:AnyObject]? = globalConstants.convertStringToDictionary(string)
                    
                    if response.response?.statusCode == 400{
                        print("The Response Error is:   \(response.response?.statusCode)")
                        if let errorData = responseDic?["detail"] {
                            let errorMessage = errorData[0] as! String
                            self.displayCommonAlert(errorMessage)
                            return;
                        }
                    }
                    
                    if (responseDic?["confirmation"]) != nil {
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                }

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
