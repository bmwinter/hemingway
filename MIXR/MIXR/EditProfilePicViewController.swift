//
//  EditProfilePicViewController.swift
//  MIXR
//
//  Created by Nilesh Patel on 08/04/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import MobileCoreServices

class EditProfilePicViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var userDict : NSDictionary = NSDictionary()
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var Name : UITextField!
    @IBOutlet weak var Phone : UITextField!
    @IBOutlet weak var Email : UITextField!
    var userId: String! = ""
    
    override func viewDidLoad() {
        self.title = "Edit Profile"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        self.addtapGesture()
        loadUserData()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        super.viewDidAppear(animated)
        
    }

    func addtapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditProfilePicViewController.handleTapEvent(_:)))
        // we use our delegate
        tap.delegate = self
        // allow for user interaction
        self.profileImage.userInteractionEnabled = true
        // add tap as a gestureRecognizer to tapView
        self.profileImage.addGestureRecognizer(tap)
    }
    func handleTapEvent(sender: UITapGestureRecognizer? = nil) {
        self.openPhotoGallery()
        // just creating an alert to prove our tap worked!
    }
    
    // MARK:
    // MARK: Open PhotoController
    
    func openPhotoGallery()
    {
        let cameraViewController = ALCameraViewController(croppingEnabled: false, allowsLibraryAccess: true) { (image) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            if image != nil{
                let imageData = UIImageJPEGRepresentation(image!, 0.5)
                if globalConstants.storeImageVideoToDocumentDirectory(imageData!, name: globalConstants.kProfilePicName) {
                    self.profileImage.image = image
                }
            }
        }
        presentViewController(cameraViewController, animated: true, completion: nil)
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
                            let responseDic:[String:AnyObject]? = globalConstants.convertStringToDictionary(string)
                            print("The Response Error is:   \(response.response?.statusCode)")
                            
                            if let val = responseDic?["code"]
                            {
                                if val[0].isEqualToString("13")
                                {
                                    //print("Equals")
                                    //self.displayCommonAlert(responseDic?["detail"]?[0] as! String)
                                    self.displayCommonAlert((responseDic?["detail"] as? NSArray)?[0] as! String)
                                    self.loadData()
                                    
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
                            let responseDic:[String:AnyObject]? = globalConstants.convertStringToDictionary(string)
                            self.userDict = responseDic!
                            print("The  responseDic is:   \(self.userDict)")
                            print("The  user_id is:   \(self.userDict["user_id"]!)")
                            print("The  name is:   \(self.userDict["name"]!)")
                            print("The  image_url is:   \(self.userDict["image_url"]!)")
                            
                            self.Name.text = self.userDict["name"]! as? String
                            
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
    
    
    func updateProfilePic(){
        
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)
        
        
        let URL = globalConstants.kAPIURL + globalConstants.kProfileUpdate
        
        var tokenString = "token "
        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
        }
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(tokenString, forKey: "Authorization")
//        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue("attachment; filename=profilepic.png;", forKey: "Content-Disposition")

        var dataPath:NSString
        
        dataPath = globalConstants.getStoreImageVideoPath(globalConstants.kProfilePicName)
        
        Alamofire.upload(.POST, URL, multipartFormData: {
            multipartFormData in
            
            multipartFormData.appendBodyPart(fileURL: NSURL(fileURLWithPath: dataPath as String), name: "file",fileName: globalConstants.kTempImageFileNmae, mimeType: "image/png")

//            for (key, value) in parameters {
//                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
//            }
            
            }, encodingCompletion: {
                encodingResult in
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        appDelegate.stopAnimation()
                        debugPrint(response)

                        guard let value = response.result.value else
                        {
                            print("Error: did not receive data")
                            return
                        }
                        
                        guard response.result.error == nil else
                        {
                            print("error calling POST on Login")
                            print(response.result.error)
                            return
                        }
                        
                        let post = JSON(value)
                        if let string = post.rawString()
                        {
                            if (response.response?.statusCode == 400 || response.response?.statusCode == 401)
                            {
                                let responseDic:[String:AnyObject]? = globalConstants.convertStringToDictionary(string)
                                print("The Response Error is:   \(response.response?.statusCode)")
                                
                                if let val = responseDic?["code"]
                                {
                                    if val[0].isEqualToString("13")
                                    {
                                        //print("Equals")
                                        //self.displayCommonAlert(responseDic?["detail"]?[0] as! String)
                                        self.displayCommonAlert((responseDic?["detail"] as? NSArray)?[0] as! String)
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
                                    return;
                                }
                            }
                            else if (response.response?.statusCode == 200 || response.response?.statusCode == 201)
                            {
                                self.navigationController?.popViewControllerAnimated(true)
                            }
                            else
                            {
                                
                            }
                        }

//                        if (response.response?.statusCode == 200 || response.response?.statusCode == 201){
//                            self.navigationController?.popViewControllerAnimated(true)
//                        }else{
//                            
//                        }
                    }
                case .Failure(let encodingError):
                    appDelegate.stopAnimation()
                    print(encodingError)
                }
        })
    }
    
    //MARK: Temp function to check upload file on server.
    
    func uploadFileOnServer(){
        
        let fileURL = globalConstants.getStoreImageVideoPath(globalConstants.kProfilePicName)//NSBundle.mainBundle().URLForResource("mixriconApp_icon", withExtension: "png")
        let URL =  globalConstants.kAPIURL + globalConstants.kProfileUpdate
        
        var tokenString = "token "

        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
            
        }
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(tokenString, forKey: "Authorization")
    
    Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue("attachment; filename=profilepic.png;", forKey: "Content-Disposition")
        
        
        Alamofire.upload(.POST, URL, file: NSURL.fileURLWithPath(fileURL as String))
            .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                print(totalBytesWritten)
                
                // This closure is NOT called on the main queue for performance
                // reasons. To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                    print("Total bytes written on main queue: \(totalBytesWritten)")
                }
            }
            .responseJSON { response in
                debugPrint(response)
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
                        size: self.profileImage.frame.size,
                        radius: 0.0
                    )
                    self.profileImage.af_setImageWithURL(URL, placeholderImage: UIImage(named: "ALPlaceholder"), filter: filter, imageTransition: .None, completion: { (response) -> Void in
                        print("image: \(self.profileImage.image)")
                        print(response.result.value) //# UIImage
                        if (response.result.value == nil)
                        {
                            self.profileImage.image = UIImage(named:"ALPlaceholder")
                        }
                        print(response.result.error) //# NSError
                    })
                    
                    //let placeholderImage = UIImage(named: "ALPlaceholder")!
                    //cell.imagePerson.af_setImageWithURL(URL, placeholderImage: placeholderImage)
                    
                }
                else
                {
                    self.profileImage.image = UIImage(named:"ALPlaceholder")
                }
            }
            else
            {
                self.profileImage.image = UIImage(named:"ALPlaceholder")
            }
//            self.btnFeedName.setTitle(userDict["name"] as? String, forState: UIControlState.Normal)
        }
    }

    @IBAction func btnUpdateClicked(sender : AnyObject){
        self.updateProfilePic()
        //self.uploadFileOnServer()
    }

}
