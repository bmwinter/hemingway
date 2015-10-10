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
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear, fromDate: date, toDate: self, options: nil).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMonth, fromDate: date, toDate: self, options: nil).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekOfYear, fromDate: date, toDate: self, options: nil).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay, fromDate: date, toDate: self, options: nil).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour, fromDate: date, toDate: self, options: nil).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMinute, fromDate: date, toDate: self, options: nil).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitSecond, fromDate: date, toDate: self, options: nil).second
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
    // Custom button methods..
    */

    @IBAction func signupButtonTapped(sender: AnyObject){
        
        let firstnameString = firstname.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let lastnameString = lastname.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let emailString = email.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let passwordString = password.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let confirmPasswordString = conformPassword.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

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
        
    }
    
    /* IBActions */
    @IBAction func datePickerTapped(sender: AnyObject) {
        DatePickerDialog().show("Date of birth", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Date) {
            (date) -> Void in
            self.selectedDate = date
            var dateFormatter = NSDateFormatter()
            
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
        println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        var emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        var result = emailTest.evaluateWithObject(testStr)
        return result
    }


    /*
    // Common alert method need to be used to display alert, by passing alert string as parameter to it.
    */

    func displayCommonAlert(alertMesage : NSString){
        
        let alertController = UIAlertController (title: "MIXR", message: alertMesage as String?, preferredStyle:.Alert)
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