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



class SignUpTableViewController: UITableViewController {
    
    
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conformPassword: UITextField!
    @IBOutlet weak var dob: UIButton!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var checkmark: UIButton!
    
    var selectedDate : NSDate?
    
    
    override func viewDidLoad() {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        self.dob?.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        
        self.selectedDate = NSDate()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
        self.title = "Sign Up"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    /*
    // Table View delegate methods
    */
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    /*
    //  Check mark button method
    */
    
    @IBAction func checkmarkButtonTapped(sender: AnyObject){
        checkmark.selected = !checkmark.selected
    }
    
    /*
    // Custom button methods..
    */
    
    @IBAction func signupButtonTapped(sender: AnyObject){
        
        
        // self.navigationController?.navigationBarHidden = false
        self.performSegueWithIdentifier("SMSVerification", sender: nil)
        return
        
        let firstnameString = firstname.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let lastnameString = lastname.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let emailString = email.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let passwordString = password.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let confirmPasswordString = conformPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
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
        self.performSegueWithIdentifier("SMSVerification", sender: nil)
    }
    
    /*
    // performLoginAction used to Call the Login API & store logged in user's data in NSUserDefault
    */
    
    func performSignUp(){
        let parameters = [
            "firstName": firstname.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            "lastName": lastname.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            "password": password.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            "email": email.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            "birthdate": dob.titleLabel!.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            "gender": "Male"
        ]
        
        let URL =  globalConstants.kAPIURL + globalConstants.kSignUpAPIEndPoint
        
        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
            .responseJSON { response in
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
                print("The post is: " + post.description)
        }
    }
    
    
    /* IBActions */
    @IBAction func datePickerTapped(sender: AnyObject) {
        DatePickerDialog().show("Date of birth", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Date) {
            (date) -> Void in
            self.selectedDate = date
            let dateFormatter = NSDateFormatter()
            
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
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