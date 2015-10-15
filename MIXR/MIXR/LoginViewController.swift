//
//  LoginViewController.swift
//  MIXR
//
//  Created by Nilesh Patel on 07/10/15.
//  Copyright (c) 2015 MIXR LLC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /*
    // Custom button methods for SignUP
    */


    @IBAction func signupButtonTapped(sender: AnyObject){
        self.performSegueWithIdentifier("SignUpSegue", sender: nil)
    }
    
    /*
    // Custom button method for Login
    */

    
    @IBAction func loginButtonTapped(sender: AnyObject){
        
        let email = userEmailTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = userPasswordTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if email.isEmpty{
            if #available(iOS 8.0, *) {
                let alertController = UIAlertController (title: "MIXR", message: "Please enter email", preferredStyle:.Alert)
                let okayAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                    //Just dismiss the action sheet
                }
                alertController.addAction(okayAction)
                self.presentViewController(alertController, animated: true, completion: nil)

            } else {
                let alert = UIAlertView(title: "MIXR", message:"Please enter password" , delegate: nil, cancelButtonTitle:"Ok")
                alert.show()
            }
        }
        
        if password.isEmpty{
            if #available(iOS 8.0, *) {
                let alertController = UIAlertController (title: "MIXR", message: "Please enter password", preferredStyle:.Alert)
                let okayAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                    //Just dismiss the action sheet
                }
                alertController.addAction(okayAction)
                self.presentViewController(alertController, animated: true, completion: nil)

            } else {
                let alert = UIAlertView(title: "MIXR", message:"Please enter password" , delegate: nil, cancelButtonTitle:"Ok")
                alert.show()
            }
        }
        
        if !isValidEmail(email){
            self.displayCommonAlert("Please enter valid email")
        }
        
    }
    
    /*
    // Common alert method need to be used to display alert, by passing alert string as parameter to it.
    */

    func displayCommonAlert(alertMesage : NSString){
        
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController (title: "MIXR", message: alertMesage as String?, preferredStyle:.Alert)
            let okayAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            alertController.addAction(okayAction)
            self.presentViewController(alertController, animated: true, completion: nil)

        } else {
            let alert = UIAlertView(title: "MIXR", message:alertMesage as String? , delegate: nil, cancelButtonTitle:"Ok")
            alert.show()

            // Fallback on earlier versions
        }
    }
    
    
    
    /*
    // Method to check wether email is valid or not.
    */

    func isValidEmail(testStr:String) -> Bool {
        print("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }
    
    /*
    // Text field delegate methods..
    */

    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    func textFieldDidEndEditing(textField: UITextField){
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    


}