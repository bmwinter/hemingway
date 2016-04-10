//
//  PostViewController.swift
//  MIXR
//
//  Created by imac04 on 11/30/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class PostViewController: BaseViewController {
    
    var userDict : NSDictionary = NSDictionary()
    @IBOutlet weak var FeedName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var venuImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var feedView: UIView!
    @IBOutlet weak var btnFollowing: UIButton!
    @IBOutlet weak var btnFeedName: UIButton!
    
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var SettingBtn: UIButton!
    var userId: String! = ""
    var isUserProfile : Bool = false
    var followIndex = 0
    
    @IBAction func OnSettingBtnAction(sender: AnyObject)
    {
        let aSettingsTableViewController : SettingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SettingViewController") as! SettingViewController
        //postViewController.userDict = userDict
        self.navigationController!.pushViewController(aSettingsTableViewController, animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.initUI()
        //self.navigationController?.interactivePopGestureRecognizer!.delegate =  self
        //self.navigationController?.interactivePopGestureRecognizer!.enabled = true        
        loadUserData()
        getFollowStatus()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
    }
    
    func loadUserData()
    {
        if (self.userId.characters.count == 0)
        {
            self.userId = "1"
        }
        
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)
        
        var tokenString = "token "
        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
            
            let URL =  globalConstants.kAPIURL + globalConstants.kProfileOther
            
            
            let headers = [
                "Authorization": tokenString,
            ]
            
            let parameters = [
                "user_id": self.userId//.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            ]
            Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON, headers : headers)
                .responseString { response in
                    
                    print("response \(response)")
                    appDelegate.stopAnimation()
                    guard let value = response.result.value else
                    {
                        print("Error: did not receive data")
                       self.loadData()
                        
                        return
                    }
                    
                    guard response.result.error == nil else
                    {
                        print("error calling POST on Login")
                        print(response.result.error)
                        self.loadData()
                        
                        return
                    }
                    
                    
                    let post = JSON(value)
                    if let string = post.rawString()
                    {
                        if (response.response?.statusCode == 400 || response.response?.statusCode == 401)
                        {
                            let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                            print("The Response Error is:   \(response.response?.statusCode)")
                            
                            if let val = responseDic?["code"]
                            {
                                if val[0].isEqualToString("13")
                                {
                                    //print("Equals")
                                    //self.displayCommonAlert(responseDic?["detail"]?[0] as! String)
                                    self.loadData()
                                    
                                    return
                                }
                                // now val is not nil and the Optional has been unwrapped, so use it
                            }
                            
                            if let errorData = responseDic?["detail"]
                            {
                                
                                if let errorMessage = errorData as? String
                                {
                                    //self.displayCommonAlert(errorMessage)
                                   
                                }
                                else if let errorMessage = errorData as? NSArray
                                {
                                    if let errorMessageStr = errorMessage[0] as? String
                                    {
                                        //self.displayCommonAlert(errorMessageStr)
                                    }
                                }
                                self.loadData()
                                return;
                            }
                        }
                        else if (response.response?.statusCode == 200 || response.response?.statusCode == 201)
                        {
                             let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                            self.userDict = responseDic!
                             print("The  responseDic is:   \(self.userDict)")
                             print("The  user_id is:   \(self.userDict["user_id"]!)")
                             print("The  name is:   \(self.userDict["name"]!)")
                             print("The  image_url is:   \(self.userDict["image_url"]!)")
                            /*
                            "user_id": 1,
                            "name": "Brendan Winter",
                            "image_url": "https://s3-us-west-2.amazonaws.com/mixrprofile/2016_03_04_03_58_1.jpg"
                            */
                            
                        }
                        else
                        {
                            
                        }
                        
                        self.loadData()
                    }
            }
        }
    }
    

    func setFollowBtnPost()
    {
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)
        
        var tokenString = "token "
        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
            
            let URL =  globalConstants.kAPIURL + globalConstants.kFollowRequestAPIEndPoint
            
            
            let headers = [
                "Authorization": tokenString,
            ]
            
            let parameters = [
                "follower_id": self.userId//.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            ]
            Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON, headers : headers)
                .responseString { response in
                    
                    print("response \(response)")
                    appDelegate.stopAnimation()
                    guard let value = response.result.value else
                    {
                        print("Error: did not receive data")
                        //self.loadData()
                        
                        return
                    }
                    
                    guard response.result.error == nil else
                    {
                        print("error calling POST on Login")
                        print(response.result.error)
                        //self.loadData()
                        
                        return
                    }
                    
                    
                    let post = JSON(value)
                    if let string = post.rawString()
                    {
                        if (response.response?.statusCode == 400 || response.response?.statusCode == 401)
                        {
                            let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                            print("The Response Error is:   \(response.response?.statusCode)")
                            
                            if let val = responseDic?["code"]
                            {
                                if val[0].isEqualToString("13")
                                {
                                    //print("Equals")
                                    //self.displayCommonAlert(responseDic?["detail"]?[0] as! String)
                                    self.displayCommonAlert((responseDic?["detail"] as? NSArray)?[0] as! String)
                                    //self.loadData()
                                    
                                    return
                                }
                                // now val is not nil and the Optional has been unwrapped, so use it
                            }
                            
                            if let errorData = responseDic?["detail"]
                            {
                                
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
                                self.loadData()
                                return;
                            }
                        }
                        else if (response.response?.statusCode == 200 || response.response?.statusCode == 201)
                        {
                            let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                            print("The  responseDic is:   \(responseDic)")
                            print("The  follow_status is:   \(responseDic!["follow_status"])")
                            self.followIndex = (responseDic!["follow_status"]?.integerValue)!
                            
                            print("The  self.followIndex is:   \(self.followIndex)")
                            
                            /*
                            "user_id": 1,
                            "name": "Brendan Winter",
                            "image_url": "https://s3-us-west-2.amazonaws.com/mixrprofile/2016_03_04_03_58_1.jpg"
                            */
                            
                        }
                        else
                        {
                            
                        }
                        
                        self.setupFollowBtnState()
                    }
            }
        }
    }
    
    func getFollowStatus()
    {
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)
        
        var tokenString = "token "
        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
            
            let URL =  globalConstants.kAPIURL + globalConstants.kFollowStatusForUserAPIEndPoint
            
            let headers = [
                "Authorization": tokenString,
                ]
            
            let parameters = [
                "user_id": self.userId//.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            ]
            
            Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON, headers : headers)
                .responseString { response in
                    
                    print("response \(response)")
                    appDelegate.stopAnimation()
                    guard let value = response.result.value else
                    {
                        print("Error: did not receive data")
                        //self.loadData()
                        
                        return
                    }
                    
                    guard response.result.error == nil else
                    {
                        print("error calling POST on Login")
                        print(response.result.error)
                        //self.loadData()
                        
                        return
                    }
                    
                    
                    let post = JSON(value)
                    if let string = post.rawString()
                    {
                        if (response.response?.statusCode == 400 || response.response?.statusCode == 401)
                        {
                            let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                            print("The Response Error is:   \(response.response?.statusCode)")
                            
                            if let val = responseDic?["code"]
                            {
                                if val[0].isEqualToString("13")
                                {
                                    //print("Equals")
                                    self.displayCommonAlert(responseDic?["detail"]?[0] as! String)
                                    //self.loadData()
                                    
                                    return
                                }
                                // now val is not nil and the Optional has been unwrapped, so use it
                            }
                            
                            if let errorData = responseDic?["detail"]
                            {
                                
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
                                self.loadData()
                                return;
                            }
                        }
                        else if (response.response?.statusCode == 200 || response.response?.statusCode == 201)
                        {
                            let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                            print("The  responseDic is:   \(responseDic)")
                            print("The  follow_status is:   \(responseDic!["follow_status"])")
                            self.followIndex = (responseDic!["follow_status"]?.integerValue)!
                            
                            print("The  self.followIndex is:   \(self.followIndex)")
                            
                            /*
                             "user_id": 1,
                             "name": "Brendan Winter",
                             "image_url": "https://s3-us-west-2.amazonaws.com/mixrprofile/2016_03_04_03_58_1.jpg"
                             */
                            
                        }
                        else
                        {
                            
                        }
                        
                        self.setupFollowBtnState()
                    }
            }
        }
    }
    
    func setupFollowBtnState()
    {
        self.btnFollowing.selected = false
        
        if (self.followIndex == 0)
        {
            //You are NOT following this user
            self.btnFollowing.selected = false
        }
        else if (self.followIndex == 1)
        {
            self.btnFollowing.selected = false
        }
        else if (self.followIndex == 2)
        {
            // User has denied your request
            self.btnFollowing.selected = false
        }
        else if (self.followIndex == 3)
        {
            //You are following this user
             self.btnFollowing.selected = true
        }
        
        if (self.btnFollowing.selected)
        {
            self.btnFollowing.enabled = false
            self.btnFollowing.backgroundColor = UIColor(red: 96/255,green: 134/255.0,blue: 72/255,alpha: 1.0)

        }
        else
        {
            self.btnFollowing.enabled = true
            self.btnFollowing.backgroundColor = UIColor(red: 194/255,green: 194/255.0,blue: 194/255,alpha: 1.0)
        }
    }
    
    func loadData()
    {
        if (userDict.allKeys.count > 0)
        {
            if let imageNameStr = self.userDict["image_url"] as? String
            {
                if (imageNameStr.characters.count > 0)
                {
                    //cell.imagePerson.image  = aImage
                    let URL = NSURL(string: imageNameStr)!
                    //let URL = NSURL(string: "https://avatars1.githubusercontent.com/u/1846768?v=3&s=460")!
                    Request.addAcceptableImageContentTypes(["binary/octet-stream"])
                    let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                        size: self.userImageView.frame.size,
                        radius: 0.0
                    )
                    self.userImageView.af_setImageWithURL(URL, placeholderImage: UIImage(named: "ALPlaceholder"), filter: filter, imageTransition: .None, completion: { (response) -> Void in
                        print("image: \(self.userImageView.image)")
                        print(response.result.value) //# UIImage
                        if (response.result.value == nil)
                        {
                            self.userImageView.image = UIImage(named:"ALPlaceholder")
                        }
                        print(response.result.error) //# NSError
                    })
                    
                    //let placeholderImage = UIImage(named: "ALPlaceholder")!
                    //cell.imagePerson.af_setImageWithURL(URL, placeholderImage: placeholderImage)
                    
                }
                else
                {
                    self.userImageView.image = UIImage(named:"ALPlaceholder")
                }
            }
            else
            {
                self.userImageView.image = UIImage(named:"ALPlaceholder")
            }
            self.btnFeedName.setTitle(userDict["name"] as? String, forState: UIControlState.Normal)
        }
    }
    
    func initUI()
    {
        if (isUserProfile)
        {
            self.SettingBtn.hidden = false
            self.cameraBtn.hidden = true
        }
        else
        {
            self.SettingBtn.hidden = true
            self.cameraBtn.hidden = false
        }
        
        if(self.isUserProfile){
            self.btnFollowing.setTitle("Edit Profile", forState: .Normal)
        }else{
            self.btnFollowing.setTitle("Follow", forState: .Normal)
        }
        
        for subview in feedView.subviews
        {
            if (subview.tag == 26)
            {
                subview.layer.cornerRadius = 0.0
            }
        }
        self.btnFeedName.titleLabel?.font = UIFont(name: "ForgottenFuturistRg-Bold", size: 24)
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnFollowing(sender: AnyObject)
    {
        if(self.isUserProfile){
            self.performSegueWithIdentifier("EditProfileInfo", sender: nil)
        }else{
            let btn : UIButton = (sender as? UIButton)!
            btn.selected = !btn.selected
            if(btn.selected)
            {
                self.btnFollowing.backgroundColor = UIColor(red: 96/255,green: 134/255.0,blue: 72/255,alpha: 1.0)
                self.setFollowBtnPost()
                
            }
            else
            {
                self.btnFollowing.backgroundColor = UIColor(red: 194/255,green: 194/255.0,blue: 194/255,alpha: 1.0)
            }
        }
        btn.selected = !btn.selected

    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
