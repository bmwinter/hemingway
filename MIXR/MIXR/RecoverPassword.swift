//
//  RecoverPassword.swift
//  MIXR
//
//  Created by Nilesh Patel on 07/02/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import Alamofire
import SwiftyJSON

class RecoverPassword: UITableViewController {
    
    
    
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var verificationCode: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmNewPassword: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var phoneNumber:NSString!
    
    
    override func viewDidLoad() {

        self.phoneNo?.userInteractionEnabled = false
        self.phoneNo?.text = self.phoneNumber as String
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
//        self.title = "Recover Password"
        
        // Do any additional setup after loading the view, typically from a nib.
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
    // recoverPassword used to send email to user to reset the password
    */
    
    func recoverPasswordUpdate(){
        let parameters = [
            "phone_number": self.phoneNo.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            "code":self.verificationCode.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            "password":self.newPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        ]
        
        let URL =  globalConstants.kAPIURL + globalConstants.kPasswordRecoverChange
        
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
                    
                    if let tokenData = responseDic?["confirmation"] {
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
    // Table View delegate methods
    */
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

}