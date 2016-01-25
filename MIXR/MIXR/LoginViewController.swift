//
//  LoginViewController.swift
//  MIXR
//
//  Created by Nilesh Patel on 07/10/15.
//  Copyright (c) 2015 MIXR LLC. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import SwiftyJSON
import Foundation
import MobileCoreServices


class LoginViewController: BaseViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        self.title = "Login"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        super.viewDidAppear(animated)
    }
    
    /*
    // Custom button methods for SignUP
    */
    
    func loadTabar()
    {
        let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: NSBundle.mainBundle())
        let tabBarController: UITabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window!.rootViewController = tabBarController
    }
    
    @IBAction func signupButtonTapped(sender: AnyObject){
        self.navigationController?.navigationBarHidden = true
        self.performSegueWithIdentifier("SignUpSegue", sender: nil)
    }
    
    /*
    // Custom button method for forgot password
    */
    
    @IBAction func forgotPasswordButtonTapped(sender: AnyObject){
        //self.navigationController?.navigationBarHidden = false
        self.displayActionSheetForCamera()
        return;
        
        self.performSegueWithIdentifier("ForgotPasswordSegue", sender: nil)
    }
    
    /*
    // Custom button method for Login
    */
    
    
    @IBAction func loginButtonTapped(sender: AnyObject){
        
        userEmailTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        
        loadTabar()
        
        let email = userEmailTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = userPasswordTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if email.isEmpty{
            let alertController = UIAlertController (title: globalConstants.kAppName , message:globalConstants.kEmailError , preferredStyle:.Alert)
            let okayAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            alertController.addAction(okayAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        if password.isEmpty{
            let alertController = UIAlertController (title: globalConstants.kAppName, message: "Please enter password", preferredStyle:.Alert)
            let okayAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            alertController.addAction(okayAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        if !globalConstants.isValidEmail(email){
            self.displayCommonAlert(globalConstants.kValidEmailError)
        }
        
    }
    
    /*
    // performLoginAction used to Call the Login API & store logged in user's data in NSUserDefault
    */
    
    func performLoginAction(){
        let parameters = [
            "email": userEmailTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            "password": userPasswordTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())]
        
        let URL =  globalConstants.kAPIURL + globalConstants.kLoginAPIEndPoint
        
        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                guard let value = response.result.value else {
                    print("Error: did not receive data")
                    return
                }
                
                guard response.result.error == nil else {
                    print("error calling POST on Login")
                    print(response.result.error)
                    return
                }
                let post = JSON(value)
                NSUserDefaults.standardUserDefaults().setObject(post as! AnyObject, forKey: "loggedInUserInfo")
                
                print("The post is: " + post.description)
                if let email = post["email"].string {
                    print("The title is: " + email)
                } else {
                    print("Error parsing JSON")
                }
        }
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