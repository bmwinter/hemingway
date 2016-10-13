//
//  ForgotPassword.swift
//  MIXR
//
//  Created by Nilesh Patel on 19/12/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

import SpringIndicator

class ForgotPassword: UITableViewController, SpringIndicatorTrait {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var springIndicator: SpringIndicator?
    
    var email: String? {
        return emailTextField.text
    }
    
    override func viewDidLoad() {
        self.emailTextField?.placeholder = "Phone"
        
        let userData = NSUserDefaults.standardUserDefaults().objectForKey("UserInfo") as?NSDictionary

        self.emailTextField?.text = userData?["phone_number"] as? String
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
//        self.navigationItem.rightBarButtonItem = self.doneButton
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
        self.title = "Forgot Password"
    }
    
    @IBAction func doneButtonTapped (sender:AnyObject){
        emailTextField.resignFirstResponder()
        let emailString = emailTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        if emailString.isEmpty{
            self.displayCommonAlert(globalConstants.kPhoneNoError)
            return
        }
//        if !globalConstants.isValidEmail(emailString){
//            self.displayCommonAlert(globalConstants.kValidEmailError)
//            return
//        }

        self.recoverPassword()
//        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func settingsButtonTapped (sender:AnyObject){
        
    }
    
    /*
    // recoverPassword used to send email to user to reset the password
    */
    
    func recoverPassword(){
//        let parameters = [
//            "phone_number": emailTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//        ]
        
//        let URL =  globalConstants.kAPIURL + globalConstants.kPasswordRecover
        if let email = email {
            APIManager.sharedInstance.recoverPassword(email, success: { (response) in
                if let _ = response["phone_number"].string {
                    self.performSegueWithIdentifier("RecoverPassword", sender: nil)
                }
            }, failure: { (error) in
                
            })
        }
        

//        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
//            .responseString { [weak self] response in
//                guard let `self` = self else { return }
//                self.stopAnimatingSpringIndicator()
//                
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
//                
//
//                let post = JSON(value)
//                if let string = post.rawString() {
//                    let responseDic:[String: AnyObject]? = self.convertStringToDictionary(string)
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
//                    if let tokenData = responseDic?["phone_number"] {
//                        let tokenString = tokenData as! String
//                        self.performSegueWithIdentifier("RecoverPassword", sender: nil)
//                        print(tokenString)
//                    }
//                }
//                print("The post is: " + post.description)
//        }
    }
    
    //MARK: Navigation Stuff
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "RecoverPassword") {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let detailVC = segue.destinationViewController as! RecoverPassword
            detailVC.phoneNumber = emailTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
    }
    

    /*
    // Table View delegate methods
    */
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func textFieldDidBeginEditing(textField: UITextField!) {    //delegate method
        let currentText = textField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if currentText.count == 0 {
            textField.text = "+1"
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField!) -> Bool {  //delegate method
        
        let currentText = textField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if currentText.isEqualToString("+1") {
            textField.text = ""
        }

        return false
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }

//    - (void)textFieldDidBeginEditing:(UITextField *)textField
//    - (void)textFieldDi
//    EndEditing:(UITextField *)textField
//    - (BOOL)textFieldShouldReturn:(UITextField *)textField
    
    
}
