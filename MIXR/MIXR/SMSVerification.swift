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

import SpringIndicator

class SMSVerification: UITableViewController {
    
    @IBOutlet weak var phoneInput: UITextField!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    var phoneNumber: String?
    var verificationCode: NSString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)

        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
//        self.navigationItem.rightBarButtonItem = self.btnDone;
//        self.phoneInput?.userInteractionEnabled = FALSE
        self.phoneInput?.text = ""
        
        self.title = "Verify"
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
        
        APIManager.sharedInstance.getVerificationCode(phoneNumber: phoneNumber ?? "",
                                                      success: { [weak self] (response) in
                                                        self?.verificationCode = response["token"].string
            }, failure: { (error) in
                
        })
        
//        let URL =  globalConstants.kAPIURL + globalConstants.kGetVerificationCode
//        
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
//                print("The post is: " + post.description)
//                
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
//                    if let tokenData = responseDic?["code"] {
//                        self.verificationCode = tokenData as! String
//                        print(self.verificationCode)
//                    }
//                }
//        }
    }

    //MARK: Check Verification Code Function
    
    func checkVerificationCode(){
        if let phoneNumber = phoneNumber, code = phoneInput.text {
            APIManager.sharedInstance.confirmVerificationCode(phoneNumber: phoneNumber,
                                                              code: code,
                                                              success: { [weak self] (response) in
                                                                if let token = response["code"].string {
                                                                    self?.verificationCode = token
                                                                    self?.performSignUp()
                                                                }
                }, failure: nil)
        }
//        let parameters = [
//            "phone_number": self.phoneNumber as! String,
//            "code": self.phoneInput.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())//"5626"
//            //phoneInput.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
//        ]
//        
//        let URL =  globalConstants.kAPIURL + globalConstants.kVerifyCodeAPIEndPoint
//        
//        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
//            .responseString { response in
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
//                let post = JSON(value)
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
//                    if let tokenData = responseDic?["code"] {
//                        self.performSignUp()
//                        self.verificationCode = tokenData as! String
//                        print(self.verificationCode)
//                    }
//                }
//        }
    }
    
    /*
    // performLoginAction used to Call the Login API & store logged in user's data in NSUserDefault
    */
    
    func performSignUp() {
        if let parameters = NSUserDefaults.standardUserDefaults().objectForKey("UserInfo") as? [String: AnyObject] {
            APIManager.sharedInstance.signUp(withParams: parameters, success: { [weak self] (response) in
                if let _ = response["email"].string {
                    self?.navigationController?.popToRootViewControllerAnimated(true)
                }
                }, failure: nil)
        }
        

        //        let parameters = [
        //            "first_name": "test",
        //            "last_name": "test",
        //            "password": "test",
        //            "email": "test@test.com",
        //            "birthdate": "1988-04-04",
        //            "phone_number": "+919428117839"
        //        ]
        
        
//        let URL =  globalConstants.kAPIURL + globalConstants.kSignUpAPIEndPoint
//        
//        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
//            .responseString { response in
//                guard let value = response.result.value else {
//                    print("Error: did not receive data")
//                    return
//                }
//                
//                guard response.result.error == nil else {
//                    print("error calling POST on SignUp")
//                    print(response.result.error)
//                    return
//                }
//                
//                
//                let post = JSON(value)
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
//                    if (responseDic?["email"]) != nil
//                    {
//                        self.navigationController?.popToRootViewControllerAnimated(true)
//                    }
//                }
//        }
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
