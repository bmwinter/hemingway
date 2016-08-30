//
//  SettingsTableViewController.swift
//  MIXR
//
//  Created by Nilesh Patel on 31/10/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

enum SettingsTag: Int {
    case ChangePassword = 0
    case PrivacyPolicy = 1
    case Terms = 2
    case Logout = 3
    
    var stringLabel: String {
        switch self {
        case .ChangePassword:
            return "Change Password"
        case .PrivacyPolicy:
            return "Privacy Policy"
        case .Terms:
            return "Terms & Conditions"
        case .Logout:
            return "Log Out"
        }
    }
}

class SettingsTableViewController: UITableViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var publicPrivateSwitch: UISwitch!
    /*
    // Table View delegate methods
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.navigationController?.interactivePopGestureRecognizer!.delegate =  self
        //self.navigationController?.interactivePopGestureRecognizer!.enabled = true        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
        self.title = "Settings"
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.makeProfilePublicPrivate("GET")
        self.navigationController?.navigationBarHidden = true
    }
    
    //MARK: PublicPrivate Switch Event
    
    @IBAction func publicPrivateSwitchChange (sender:AnyObject){
        self.makeProfilePublicPrivate("POST")
    }
    
    // MARK: Make profile public private
    func makeProfilePublicPrivate(methodName : NSString){
        
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)
        
        var tokenString = "token "
        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
        }
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(tokenString, forKey: "Authorization")
        
        let URL =  globalConstants.kAPIURL + globalConstants.kMakeProfilePublicPrivate
        
        if methodName == "GET" {
            Alamofire.request(.GET, URL , parameters: nil, encoding: .JSON)
                .responseString
                { response in
                    
                    appDelegate.stopAnimation()
                    guard let value = response.result.value else {
                        print("Error: did not receive data")
                        return
                    }
                    
                    guard response.result.error == nil else {
                        print("error calling POST on Login")
                        print(response.result.error)
                        return
                    }
                    let post = JSON(value)
                    if let string = post.rawString() {
                        
                        if response.response?.statusCode == 400{
                            let responseDic:[String:AnyObject]? = globalConstants.convertStringToDictionary(string)
                            print("The Response Error is:   \(response.response?.statusCode)")
                            if let errorData = responseDic?["detail"] {
                                if let errorMessage = errorData as? String
                                {
                                    self.displayCommonAlert(errorMessage)
                                    
                                }
                                else if let errorMessage = errorData as? NSArray
                                {
                                    if let errorMessageStr = errorMessage[0] as? String
                                    {
                                        self.displayCommonAlert(errorMessageStr)
                                    }
                                }
                                return;
                            }
                        }else{
                            //                        "{\"public\":false}"
                            let responseDic:[String:AnyObject]? = globalConstants.convertStringToDictionary(string)
                            if (self.publicPrivateSwitch != nil)
                            {
                                if let isPublic = responseDic!["public"] as? Bool
                                {
                                    self.publicPrivateSwitch.on = isPublic
                                }
                                else
                                {
                                    self.publicPrivateSwitch.on = false
                                }
                            }
                        }
                    }
            }
        }else{
            Alamofire.request(.POST, URL , parameters: nil, encoding: .JSON)
                .responseString
                { response in
                    
                    appDelegate.stopAnimation()
                    guard let value = response.result.value else {
                        print("Error: did not receive data")
                        return
                    }
                    
                    guard response.result.error == nil else {
                        print("error calling POST on Login")
                        print(response.result.error)
                        return
                    }
                    let post = JSON(value)
                    if let string = post.rawString() {
                        
                        if response.response?.statusCode == 400{
                            let responseDic:[String:AnyObject]? = globalConstants.convertStringToDictionary(string)
                            print("The Response Error is:   \(response.response?.statusCode)")
                            if let errorData = responseDic?["detail"] {
                                
                                if let errorMessage = errorData as? String
                                {
                                    self.displayCommonAlert(errorMessage)
                                    
                                }
                                else if let errorMessage = errorData as? NSArray
                                {
                                    if let errorMessageStr = errorMessage[0] as? String
                                    {
                                        self.displayCommonAlert(errorMessageStr)
                                    }
                                }
                                return;
                            }
                        }else{
                            //                        "{\"public\":false}"
                            let responseDic:[String:AnyObject]? = globalConstants.convertStringToDictionary(string)
                            self.publicPrivateSwitch.on = responseDic?["public"] as! Bool
                        }
                    }
                }
        }
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
    // getSettingsData used to retrieve user settings data
    */
    
    func getSettingsData(){
        let parameters = [
            "userID": "1"
        ]
        
        let URL =  globalConstants.kAPIURL + globalConstants.kSettingAPIEndPoint
        
        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
            .responseJSON { response in
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
                print("The post is: " + post.description)
        }
    }
}

// MARK: UITableViewDataSource Protocol
extension SettingsTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("settingsTableViewCell", forIndexPath: indexPath) as? SettingsTableViewCell{
            let value = indexPath.section * 2 + indexPath.row
            let setting = SettingsTag(rawValue: value)
            cell.setting = setting?.stringLabel
            return cell
        }
        /// shouldn't make it here
        return UITableViewCell(style: .Default, reuseIdentifier: "nullCell")
    }
}

// MARK: UITableViewDelegate Protocol
extension SettingsTableViewController {
    
    func textForSection(section: Int) -> String {
        if section == 0 {
            return "Me"
        } else {
            return "MIXR"
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let height = self.tableView(tableView, heightForHeaderInSection: section)
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: height)
        let view = UIView(frame: frame)
        
        let label = UILabel()
        label.font = UIFont.boldFontWithSize(20.0)
        label.text = textForSection(section)
        label.sizeToFit()
        
        label.frame = CGRect(x: 20, y: (height-label.frame.height)/2, width: label.frame.width, height: label.frame.height)
        
        let lineView = UIView(frame: CGRect(x: label.frame.maxX + 5, y: (height-1)/2, width: tableView.frame.width - label.frame.maxX - 20, height: 1))
        lineView.backgroundColor = UIColor.mixrLightGray()
        
        view.addSubview(label)
        view.addSubview(lineView)
        
        return view
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // super-hacky should refactor
        let value = indexPath.section * 2 + indexPath.row
        if let setting = SettingsTag(rawValue: value) {
            switch setting {
            case .ChangePassword:
                let aChangePassword : ChangePassword = self.storyboard!.instantiateViewControllerWithIdentifier("ChangePassword") as! ChangePassword
                self.navigationController?.navigationBarHidden = false
                self.navigationController!.pushViewController(aChangePassword, animated: true)
            case .PrivacyPolicy:
                print("Terms & Condition")
            case .Terms:
                print("Terms & Condition")
            case .Logout:
                NSUserDefaults.standardUserDefaults().setObject("", forKey: "LoginToken")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }
}
