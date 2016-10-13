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
    }

    //MARK: Check Verification Code Function
    
    func checkVerificationCode(){
        if let phoneNumber = phoneNumber, code = phoneInput.text {
            APIManager.sharedInstance.confirmVerificationCode(phoneNumber: phoneNumber,
                                                              code: code,
                                                              success: { [weak self] (response) in
                                                                if let token = response["code"].string {
                                                                    self?.verificationCode = token
                                                                    self?.navigationController?.popToRootViewControllerAnimated(true)
                                                                }
                }, failure: nil)
        }
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
