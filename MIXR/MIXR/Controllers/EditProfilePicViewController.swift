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

class EditProfilePicViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var userDict : NSDictionary = NSDictionary()
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var nameField : UITextField!
    @IBOutlet weak var phoneField : UITextField!
    @IBOutlet weak var emailField : UITextField!
    var userId: String! = ""
    
    override func viewDidLoad() {
        self.title = "Edit Profile"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        self.addtapGesture()
        loadUserData()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        
        APIManager.sharedInstance.getUserProfile(forUserId: userId,
                                                 success: { [weak self] (response) in
                                                    self?.userDict = NSDictionary(dictionary: response.dictionaryObject ?? [:])
                                                    self?.nameField.text = response["name"].string
                                                    self?.loadData()
            }, failure: { (error) in
        
        })
    }
    
    
    func updateProfilePic(){
        
        let URL = globalConstants.kAPIURL + globalConstants.kProfileUpdate
        
        var tokenString = "token "
        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
        }
        
//        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(tokenString, forKey: "Authorization")
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
                    upload.responseJSON { [weak self] response in
                        guard let `self` = self else { return }
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
                                let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
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
                    print(encodingError)
                }
        })
    }
    
    //MARK: Temp function to check upload file on server.
    // TODO: work out file upload
    func uploadFileOnServer(){
        
        let fileURL = globalConstants.getStoreImageVideoPath(globalConstants.kProfilePicName)//NSBundle.mainBundle().URLForResource("mixriconApp_icon", withExtension: "png")
        let URL =  globalConstants.kAPIURL + globalConstants.kProfileUpdate
        
        var tokenString = "token "

        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
            
        }
        
//        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(tokenString, forKey: "Authorization")
    
//    Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue("attachment; filename=profilepic.png;", forKey: "Content-Disposition")
        
        
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
