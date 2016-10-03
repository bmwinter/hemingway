//
//  RecoverPassword.swift
//  MIXR
//
//  Created by Nilesh Patel on 07/02/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import Alamofire
import SwiftyJSON

import SpringIndicator

class RecoverPassword: UITableViewController, SpringIndicatorTrait {
    
    var springIndicator: SpringIndicator?
    
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var verificationCode: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmNewPassword: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var phoneNumber: NSString!
    
    var phoneNumberString: String {
        switch phoneNo.text {
        case .Some(let value):
            return value
        case .None:
            return ""
        }
    }
    
    var verificationCodeString: String {
        switch verificationCode.text {
        case .Some(let value):
            return value
        case .None:
            return ""
        }
    }
    
    var passwordString: String {
        switch newPassword.text {
        case .Some(let value):
            return value
        case .None:
            return ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneNo?.userInteractionEnabled = false
        self.phoneNo?.text = self.phoneNumber as String
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
    }

    @IBAction func doneButtonTapped (sender:AnyObject){
        self.phoneNo.resignFirstResponder()
        self.verificationCode.resignFirstResponder()
        self.newPassword.resignFirstResponder()
        self.confirmNewPassword.resignFirstResponder()
        
        let phoneString = self.phoneNo.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let verificationCodeString = self.verificationCode.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let newPasswordString = self.newPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let confirmNewPasswordString = self.confirmNewPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        
        
        if phoneString.isEmpty{
            self.displayCommonAlert(globalConstants.kPhoneNoError)
            return
        }
        
        if verificationCodeString.isEmpty{
            self.displayCommonAlert(globalConstants.kverificationCodeError)
            return
        }

        if newPasswordString.isEmpty{
            self.displayCommonAlert(globalConstants.kNewPassword)
            return
        }
        
        if confirmNewPasswordString.isEmpty{
            self.displayCommonAlert(globalConstants.kconfirmPasswordError)
            return
        }
        
        if !compareTwoPassword(newPasswordString, conformPassword: confirmNewPasswordString){
            self.displayCommonAlert(globalConstants.kpasswordconfirmPasswordError)
            return
        }

        self.recoverPasswordUpdate()
    }
    
    /*
    // Compare two password
    */
    
    func compareTwoPassword (password: String, conformPassword : NSString) -> Bool{
        return (password == conformPassword)
    }


    /*
    // recoverPassword used to send email to user to reset the password
    */
    
    func recoverPasswordUpdate() {
        
        APIManager.sharedInstance.recoverPasswordWithConfirmationCode(verificationCodeString,
                                                                      phoneNumber: phoneNumberString,
                                                                      password: passwordString,
                                                                      success: { [weak self] (response) in
                                                                        if !(response["confirmation"].object is NSNull) {
                                                                            self?.navigationController?.popToRootViewControllerAnimated(true)
                                                                        }
            }, failure: nil)
        
//        let parameters = [
//            "phone_number": self.phoneNo.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
//            "code":self.verificationCode.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
//            "password":self.newPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//        ]
        
//        let URL =  globalConstants.kAPIURL + globalConstants.kPasswordRecoverChange
//
//        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
//            .responseString { response in
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
//                    if let tokenData = responseDic?["confirmation"] {
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
        return 5
    }

}
