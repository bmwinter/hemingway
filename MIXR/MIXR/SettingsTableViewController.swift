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

enum settingsTag:Int {
    case editProfile
    case changePassword
    case privateAccount
    case privacyPolicy
    case TermsCondition
    case following
    case follower
    case termsAndCondition
    case logout
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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.makeProfilePublicPrivate("GET")
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        //self.navigationController?.navigationBarHidden = false
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
                                
                                let errorMessage = errorData[0] as! String
                                self.displayCommonAlert(errorMessage)
                                return;
                            }
                        }else{
                            //                        "{\"public\":false}"
                            let responseDic:[String:AnyObject]? = globalConstants.convertStringToDictionary(string)
                            self.publicPrivateSwitch.on = responseDic?["public"] as! Bool
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
                                
                                let errorMessage = errorData[0] as! String
                                self.displayCommonAlert(errorMessage)
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

    
    @IBAction func settingsButtonTapped (sender:AnyObject)
    {
        let button = sender as? UIButton
        NSLog("button tag = \(button?.tag)")
        
        
        switch (button?.tag)
        {
            
        case settingsTag.editProfile.rawValue? :
            let postViewController : PostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PostViewController") as! PostViewController
            postViewController.isUserProfile = true
            self.navigationController!.pushViewController(postViewController, animated: true)
            print("Edit Profile")
            
        case settingsTag.changePassword.rawValue? :
            //self.performSegueWithIdentifier("ChangePassword", sender: nil)
            let aChangePassword : ChangePasswordViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ChangePasswordViewController") as! ChangePasswordViewController
            self.navigationController!.pushViewController(aChangePassword, animated: true)
            print("Change password")
        case settingsTag.privateAccount.rawValue? :
            
            print("Private Account")
        case settingsTag.privacyPolicy.rawValue? :
            //            let aVenueProfileViewController : VenueProfileViewController = self.storyboard!.instantiateViewControllerWithIdentifier("VenueProfileViewController") as! VenueProfileViewController
            //            self.navigationController!.pushViewController(aVenueProfileViewController, animated: true)
            //            //self.performSegueWithIdentifier("VenueProfile", sender: nil)
            print("Privary Policy")

        case settingsTag.TermsCondition.rawValue? :
            //            let aVenueProfileViewController : VenueProfileViewController = self.storyboard!.instantiateViewControllerWithIdentifier("VenueProfileViewController") as! VenueProfileViewController
            //            self.navigationController!.pushViewController(aVenueProfileViewController, animated: true)
            //            //self.performSegueWithIdentifier("VenueProfile", sender: nil)
            print("Terms & Condition")
            

        case settingsTag.following.rawValue? :
            let followingViewController : FollowingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FollowingViewController") as! FollowingViewController
            //postViewController.feedDict = feedDict
            self.navigationController!.pushViewController(followingViewController, animated: true)
            print("Following")
            
        case settingsTag.follower.rawValue? :
            let followersViewController : FollowersViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FollowersViewController") as! FollowersViewController
            //postViewController.feedDict = feedDict
            self.navigationController!.pushViewController(followersViewController, animated: true)
            print("Followers")
            
        case settingsTag.logout.rawValue? :
            NSUserDefaults.standardUserDefaults().setObject("", forKey: "LoginToken")
            self.dismissViewControllerAnimated(false, completion: { () -> Void in
                
            })

            print("Logout")
        default :
            print("Test 1")
        }
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    
}
