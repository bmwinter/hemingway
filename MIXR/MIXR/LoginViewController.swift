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
        //        self.displayActionSheetForCamera()
        //        return;
        self.navigationController?.navigationBarHidden = false
        self.performSegueWithIdentifier("ForgotPasswordSegue", sender: nil)
    }
    
    /*
    // Custom button method for Login
    */
    
    
    @IBAction func loginButtonTapped(sender: AnyObject){
        
        userEmailTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        
//        loadTabar()
//        return;
        
        
        let email = userEmailTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = userPasswordTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if email.isEmpty{
            let alertController = UIAlertController (title: globalConstants.kAppName , message:globalConstants.kEmailError , preferredStyle:.Alert)
            let okayAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            alertController.addAction(okayAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return;
        }
        
        if password.isEmpty{
            let alertController = UIAlertController (title: globalConstants.kAppName, message: "Please enter password", preferredStyle:.Alert)
            let okayAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            alertController.addAction(okayAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return;
            
        }
        
        //        if !globalConstants.isValidEmail(email){
        //            self.displayCommonAlert(globalConstants.kValidEmailError)
        //            return;
        //        }
        
        self.performLoginAction()
    }
    
    //MARK: Temp function to check upload file on server.
    
    func uploadFileOnServer(){
        let fileURL = NSBundle.mainBundle().URLForResource("mixriconApp_icon", withExtension: "png")
        let URL =  globalConstants.kAPIURL + globalConstants.kProfileUpdate
        
        //        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue("application/json", forKey: "Accept")
        
        //        Token 2952a5dcad5181d80b79c1bc335ab91c97c03f14
        
        var tokenString = "token "
        tokenString +=  "2952a5dcad5181d80b79c1bc335ab91c97c03f14"//NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as! String
        
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(tokenString, forKey: "Authorization")
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue("attachment; filename=media_filename.png;", forKey: "Content-Disposition")
        
        
        Alamofire.upload(.POST, URL, file: fileURL!)
            .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                print(totalBytesWritten)
                
                // This closure is NOT called on the main queue for performance
                // reasons. To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                    print("Total bytes written on main queue: \(totalBytesWritten)")
                }
            }
            .responseJSON { response in
                debugPrint(response)
        }
        
        
    }
    
    /*
    // performLoginAction used to Call the Login API & store logged in user's data in NSUserDefault
    */
    
    func performLoginAction(){
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)
        
        let parameters = [
            "username": userEmailTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            "password": userPasswordTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())]
        
        let URL =  globalConstants.kAPIURL + globalConstants.kLoginAPIEndPoint
        
        //        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue("application/json", forKey: "Accept")
        
        
        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
            .responseString { response in
                
                appDelegate.stopAnimation()
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
                if let string = post.rawString() {
                    let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                    
                    if response.response?.statusCode == 400{
                        print("The Response Error is:   \(response.response?.statusCode)")
                        
                        if let val = responseDic?["code"] {
                            if val[0].isEqualToString("13") {
                                //                                print("Equals")
                                self.displayCommonAlert(responseDic?["detail"]?[0] as! String)
                                return
                            }
                            // now val is not nil and the Optional has been unwrapped, so use it
                        }
                        
                        if let errorData = responseDic?["detail"] {
                            
                            let errorMessage = errorData[0] as! String
                            self.displayCommonAlert(errorMessage)
                            return;
                        }
                    }
                    
                    if let tokenData = responseDic?["token"] {
                        let tokenString = tokenData as! String
                        NSUserDefaults.standardUserDefaults().setObject(tokenString, forKey: "LoginToken")
                        print(tokenString)
                        self.loadTabar()
                    }
                }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "SMSVerification") {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
//            NSUserDefaults.standardUserDefaults().setObject(parameters, forKey: "UserInfo")
            let detailVC = segue.destinationViewController as! SMSVerification;
            
            let userData = NSUserDefaults.standardUserDefaults().objectForKey("UserInfo") as?NSDictionary

            detailVC.phoneNumber = userData?["phone_number"] as? String
        }
    }
    
    
    //MARK: convertStringObject to Dictionary
    
    func convertStringToDictionary(text:String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
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