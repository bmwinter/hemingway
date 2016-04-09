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
    var phoneNumber: NSString?
    var verificationCode: NSString?
    override func viewDidLoad() {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)

        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
//        self.navigationItem.rightBarButtonItem = self.btnDone;
//        self.phoneInput?.userInteractionEnabled = FALSE
        self.phoneInput?.text = ""
        
        self.title = "Verify"
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.getVerificationCode();
    }
    
    @IBAction func btnVerifyClicked (sender:AnyObject){
        self.phoneInput?.resignFirstResponder()
        
        let phoneInputString = self.phoneInput.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if phoneInputString.isEmpty{
            self.displayCommonAlert(globalConstants.kverificationCodeError)
            return;
        }
        self.checkVerificationCode();
    }
    
    
    @IBAction func btnResendClicked (sender:AnyObject){
        self.getVerificationCode()
//        self.performSegueWithIdentifier("SettingsSegue", sender: nil)
    }

    @IBAction func settingsButtonTapped (sender:AnyObject){
        
    }
    
    
    /*
    // getVerificationCode used to check user entered verification code with server
    */
    
    func getVerificationCode(){
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)

        let parameters = [
            "phone_number": self.phoneNumber as! AnyObject
        ]
        //self.phoneInput.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
        
        let URL =  globalConstants.kAPIURL + globalConstants.kGetVerificationCode
        
        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
            .responseString { response in
                
                appDelegate.stopAnimation()
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
                    let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                    
                    if response.response?.statusCode == 400{
                        print("The Response Error is:   \(response.response?.statusCode)")
                        if let errorData = responseDic?["detail"] {
                            //let errorMessage = errorData[0] as! String
                            let errorMessage = (errorData as? NSArray)?[0] as! String
                            self.displayCommonAlert(errorMessage)
                            return;
                        }
                    }
                    
                    if let tokenData = responseDic?["code"] {
                        self.verificationCode = tokenData as! String
                        print(self.verificationCode)
                    }
                }
        }
    }

    //MARK: Check Verification Code Function
    
    func checkVerificationCode(){
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)

        let parameters = [
            "phone_number": self.phoneNumber as! String,
            "code": self.phoneInput.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())//"5626"
            //phoneInput.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
        ]
        
        let URL =  globalConstants.kAPIURL + globalConstants.kVerifyCodeAPIEndPoint
        
        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
            .responseString { response in
                
                appDelegate.stopAnimation()
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
                if let string = post.rawString() {
                    let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                    
                    if response.response?.statusCode == 400{
                        print("The Response Error is:   \(response.response?.statusCode)")
                        if let errorData = responseDic?["detail"] {
                            //let errorMessage = errorData[0] as! String
                            let errorMessage = (errorData as? NSArray)?[0] as! String
                            self.displayCommonAlert(errorMessage)
                            return;
                        }
                    }
                    
                    if let tokenData = responseDic?["code"] {
                        self.performSignUp()
                        self.verificationCode = tokenData as! String
                        print(self.verificationCode)
                    }
                }
        }
    }
    
    /*
    // performLoginAction used to Call the Login API & store logged in user's data in NSUserDefault
    */
    
    func performSignUp(){
        
        let parameters = NSUserDefaults.standardUserDefaults().objectForKey("UserInfo") as?[String:AnyObject]

        //        let parameters = [
        //            "first_name": "test",
        //            "last_name": "test",
        //            "password": "test",
        //            "email": "test@test.com",
        //            "birthdate": "1988-04-04",
        //            "phone_number": "+919428117839"
        //        ]
        
        
        let URL =  globalConstants.kAPIURL + globalConstants.kSignUpAPIEndPoint
        
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)
        
        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
            .responseString { response in
                
                appDelegate.stopAnimation()
                guard let value = response.result.value else {
                    print("Error: did not receive data")
                    return
                }
                
                guard response.result.error == nil else {
                    print("error calling POST on SignUp")
                    print(response.result.error)
                    return
                }
                
                
                let post = JSON(value)
                if let string = post.rawString() {
                    let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                    
                    if response.response?.statusCode == 400{
                        print("The Response Error is:   \(response.response?.statusCode)")
                        if let errorData = responseDic?["detail"] {
                            //let errorMessage = errorData[0] as! String
                            let errorMessage = (errorData as? NSArray)?[0] as! String
                            self.displayCommonAlert(errorMessage)
                            return;
                        }
                    }
                    
                    if (responseDic?["email"]) != nil
                    {
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                }
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
    // Table View delegate methods
    */
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
}
