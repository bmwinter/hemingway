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

    @IBAction func signupButtonTapped(sender: AnyObject){
        self.performSegueWithIdentifier("SignUpSegue", sender: nil)
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject){
        
        let email = userEmailTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = userPasswordTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if email.isEmpty{
            let alertController = UIAlertController (title: "MIXR", message: "Please enter email", preferredStyle:.Alert)
            let okayAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            alertController.addAction(okayAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        if password.isEmpty{
            let alertController = UIAlertController (title: "MIXR", message: "Please enter password", preferredStyle:.Alert)
            let okayAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            alertController.addAction(okayAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        if !isValidEmail(email){
            displayEmailErrorAlert()
        }
        
    }
    
    func displayEmailErrorAlert(){
        let alertController = UIAlertController (title: "MIXR", message: "Please enter valid email", preferredStyle:.Alert)
        let okayAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        alertController.addAction(okayAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func displayCommonAlert(alertMesage : NSString){
        
        let alertController = UIAlertController (title: "MIXR", message: alertMesage as String?, preferredStyle:.Alert)
        let okayAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        alertController.addAction(okayAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    func isValidEmail(testStr:String) -> Bool {
        println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        var emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        var result = emailTest.evaluateWithObject(testStr)
        return result
    }
    
    
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