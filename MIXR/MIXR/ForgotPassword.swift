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

class ForgotPassword: UITableViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        self.email?.placeholder = "Phone"
        
        let userData = NSUserDefaults.standardUserDefaults().objectForKey("UserInfo") as?NSDictionary

        self.email?.text = userData?["phone_number"] as? String
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
//        self.navigationItem.rightBarButtonItem = self.doneButton
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
        self.title = "Forgot Password"
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func doneButtonTapped (sender:AnyObject){
        email.resignFirstResponder()
        let emailString = email.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

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
        let parameters = [
            "phone_number": email.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        ]
        
        let URL =  globalConstants.kAPIURL + globalConstants.kPasswordRecover
        
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
                            let errorMessage = errorData[0] as! String
                            self.displayCommonAlert(errorMessage)
                            return;
                        }
                    }
                    
                    if let tokenData = responseDic?["phone_number"] {
                        let tokenString = tokenData as! String
                        self.performSegueWithIdentifier("RecoverPassword", sender: nil)
                        print(tokenString)
                    }
                }
                print("The post is: " + post.description)
        }
    }
    
    //MARK: Navigation Stuff
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "RecoverPassword") {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let detailVC = segue.destinationViewController as! RecoverPassword
            detailVC.phoneNumber = email.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
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
        return 2
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

    
    
}
