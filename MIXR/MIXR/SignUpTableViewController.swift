//
//  SignUpTableViewController.swift
//  MIXR
//
//  Created by Nilesh Patel on 08/10/15.
//  Copyright (c) 2015 MIXR LLC. All rights reserved.
//
import UIKit

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
        
        let firstnameString = firstname.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let lastnameString = lastname.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let emailString = email.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let passwordString = password.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let confirmPasswordString = conformPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        if firstnameString.isEmpty{
            self.displayCommonAlert("Please enter firstname")
        }
        if lastnameString.isEmpty{
            self.displayCommonAlert("Please enter lastname")
        }
        if emailString.isEmpty{
            self.displayCommonAlert("Please enter email")
        }
        if passwordString.isEmpty{
            self.displayCommonAlert("Please enter password")
        }
        if confirmPasswordString.isEmpty{
            self.displayCommonAlert("Please enter confirm password")
        }
        
        if !isValidEmail(emailString){
            self.displayCommonAlert("Please enter valid email")
        }

        if !compareTwoPassword(passwordString, conformPassword: confirmPasswordString){
            self.displayCommonAlert("Password and confirm password must be same")
        }

        let years = NSDate().yearsFrom(self.selectedDate!)
        
        if(years<=18){
            self.displayCommonAlert("To use this application, Your age should be greather that 18 years")
        }
        
        if !checkmark.selected{
            self.displayCommonAlert("Please accept terms & condition!")
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
    // Method to check wether email is valid or not.
    */

    
    func isValidEmail(testStr:String) -> Bool {
        print("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }


    /*
    // Common alert method need to be used to display alert, by passing alert string as parameter to it.
    */

    func displayCommonAlert(alertMesage : NSString){
        
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController (title: "MIXR", message: alertMesage as String?, preferredStyle:.Alert)
            let okayAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            alertController.addAction(okayAction)
            self.presentViewController(alertController, animated: true, completion: nil)

        } else {
            let alert = UIAlertView(title: "MIXR", message:alertMesage as String? , delegate: nil, cancelButtonTitle:"Ok")
            alert.show()
        }
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