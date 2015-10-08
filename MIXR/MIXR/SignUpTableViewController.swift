//
//  SignUpTableViewController.swift
//  MIXR
//
//  Created by Nilesh Patel on 08/10/15.
//  Copyright (c) 2015 MIXR LLC. All rights reserved.
//
import UIKit

class SignUpTableViewController: UITableViewController {
    
    
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conformPassword: UITextField!
    @IBOutlet weak var gender: UISegmentedControl!

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
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
        

    }

    func displayCommonAlert(alertMesage : NSString){
        
        let alertController = UIAlertController (title: "MIXR", message: alertMesage as String?, preferredStyle:.Alert)
        let okayAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        alertController.addAction(okayAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    

    
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