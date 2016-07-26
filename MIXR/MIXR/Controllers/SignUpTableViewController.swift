//
//  SignUpTableViewController.swift
//  MIXR
//
//  Created by Nilesh Patel on 08/10/15.
//  Copyright (c) 2015 MIXR LLC. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
import IQKeyboardManagerSwift

extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> Int {
        if yearsFrom(date)   > 0 { return yearsFrom(date)   }
        if monthsFrom(date)  > 0 { return monthsFrom(date)  }
        if weeksFrom(date)   > 0 { return weeksFrom(date)   }
        if daysFrom(date)    > 0 { return daysFrom(date)    }
        if hoursFrom(date)   > 0 { return hoursFrom(date)   }
        if minutesFrom(date) > 0 { return minutesFrom(date) }
        if secondsFrom(date) > 0 { return secondsFrom(date) }
        return 0
    }
}



class SignUpTableViewController: UIViewController {
    
    
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conformPassword: UITextField!
    @IBOutlet weak var dob: UIButton!
    @IBOutlet weak var countryCode: UITextField!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var checkmark: UIButton!
    @IBOutlet weak var spaceBetween: NSLayoutConstraint!
    @IBOutlet weak var firstNameWidth: NSLayoutConstraint!
    @IBOutlet weak var lastNameWidth: NSLayoutConstraint!
    
    var selectedDate : NSDate?
    
    
    override func viewDidLoad() {
        
        IQKeyboardManager.sharedManager().enable = true

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)

        self.dob?.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)

        self.selectedDate = NSDate()
//        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
        self.title = "Sign Up"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
//        self.spaceBetween.constant = 9
        // 26
        let width = (self.navigationController?.view.frame.size.width)! - 26.0
        self.firstNameWidth.constant = width/2.0
        self.lastNameWidth.constant = width/2.0
        self.navigationController?.navigationBarHidden = true
//        self.performSignUp()
    }

    /*
    //  Check mark button method
    */
    
    @IBAction func checkmarkButtonTapped(sender: AnyObject){
        checkmark.selected = !checkmark.selected
    }
    
    //MARK: Go to login screen. 
    @IBAction func goBack(sender: AnyObject){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    // Custom button methods..
    */

    @IBAction func signupButtonTapped(sender: AnyObject){
        
        
//        self.navigationController?.navigationBarHidden = false
//        self.performSegueWithIdentifier("SMSVerification", sender: nil)
//        return
        
        let firstnameString = firstname.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let lastnameString = lastname.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let emailString = email.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let passwordString = password.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let confirmPasswordString = conformPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        let phoneNoString = phoneNo.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let countryCodeString = countryCode.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        if firstnameString.isEmpty{
            self.displayCommonAlert(globalConstants.kfirstnameError)
            return
        }
        if lastnameString.isEmpty{
            self.displayCommonAlert(globalConstants.klastnameError)
            return
        }
        if emailString.isEmpty{
            self.displayCommonAlert(globalConstants.kEmailError)
            return
        }
        if passwordString.isEmpty{
            self.displayCommonAlert(globalConstants.kpasswordError)
            return
        }
        if confirmPasswordString.isEmpty{
            self.displayCommonAlert(globalConstants.kconfirmPasswordError)
            return
        }

        
        if countryCodeString.isEmpty{
            self.displayCommonAlert(globalConstants.kCountryCodeError)
            return
        }

        if phoneNoString.isEmpty{
            self.displayCommonAlert(globalConstants.kPhoneNoError)
            return
        }

        if !globalConstants.isValidEmail(emailString){
            self.displayCommonAlert(globalConstants.kValidEmailError)
            return
        }

        if !compareTwoPassword(passwordString, conformPassword: confirmPasswordString){
            self.displayCommonAlert(globalConstants.kpasswordconfirmPasswordError)
            return
        }

        let years = NSDate().yearsFrom(self.selectedDate!)
        
        if(years<=18){
            self.displayCommonAlert(globalConstants.kageRestrictionError)
            return
        }
        
        if !checkmark.selected{
            self.displayCommonAlert(globalConstants.ktermsandConditionError)
            return
        }
        
        //self.navigationController?.navigationBarHidden = false
        self.performSignUp()
    }
    
    /*
    // performLoginAction used to Call the Login API & store logged in user's data in NSUserDefault
    */
    
    func performSignUp(){
        
        let phoneNumberString = phoneNo.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let countryCodeString = countryCode.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        let parameters = [
            "first_name": firstname.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            "last_name": lastname.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            "password": password.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            "email": email.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            "birthdate": dob.titleLabel!.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            "phone_number": countryCodeString + phoneNumberString
        ]
        
        NSUserDefaults.standardUserDefaults().setObject(parameters, forKey: "UserInfo")
        NSUserDefaults.standardUserDefaults().synchronize()

        self.navigationController?.navigationBarHidden = false
        self.performSegueWithIdentifier("SMSVerification", sender: nil)

        return;
        
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
                    
                    if let tokenData = responseDic?["email"] {
                        self.navigationController?.navigationBarHidden = false
                        self.performSegueWithIdentifier("SMSVerification", sender: nil)
                    }
                }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "SMSVerification") {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let detailVC = segue.destinationViewController as! SMSVerification;
            let phoneNumberString = phoneNo.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            let countryCodeString = countryCode.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            
            detailVC.phoneNumber = countryCodeString + phoneNumberString
            
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

    
    /* IBActions */
    @IBAction func datePickerTapped(sender: AnyObject) {
        DatePickerDialog().show("Date of birth", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Date) {
            (date) -> Void in
            self.selectedDate = date
            let dateFormatter = NSDateFormatter()
            
//            "birthdate": "1988-04-04",
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let strDate = dateFormatter.stringFromDate(date)
            self.dob?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            self.dob?.setTitle("\(strDate)", forState: UIControlState.Normal)
        }
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
    // Alert view delegate methods..
    */
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        switch buttonIndex{
        case 1: print("Test 1")
        case 0: print("Test 1")
        default: print("Test 1")
        }
    }
    
    /*
    // Segment Control Delegate Method
    */

    @IBAction func segmentControlStateChanged(sender: SegmentControl) {
        print("Selected segment = \(sender.selectedIndex)")
        
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