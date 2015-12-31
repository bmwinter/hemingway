//
//  ForgotPassword.swift
//  MIXR
//
//  Created by Nilesh Patel on 19/12/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//
import UIKit

class ForgotPassword: UITableViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        
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
            self.displayCommonAlert(globalConstants.kEmailError)
            return
        }
        if !globalConstants.isValidEmail(emailString){
            self.displayCommonAlert(globalConstants.kValidEmailError)
            return
        }

        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func settingsButtonTapped (sender:AnyObject){
        
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
