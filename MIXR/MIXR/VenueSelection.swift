//
//  VenueSelection.swift
//  MIXR
//
//  Created by Nilesh Patel on 13/02/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import Foundation
import UIKit
import BTNavigationDropdownMenu
import AVFoundation
import MediaPlayer
import Alamofire
import SwiftyJSON

extension UIImage {
    var fixedOrientation: UIImage {
        if self.imageOrientation == .Up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransformIdentity
        
        switch (self.imageOrientation) {
        case .Down:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.width)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            break
        case .DownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.width)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            break
        case .Left:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
            break
        case .LeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
            break
        case .Right:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
            break
        case .RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
            break
        case .Up:
            break
        case .UpMirrored:
            break
        }
        
        switch (self.imageOrientation) {
        case .UpMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            break;
        case .DownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            break;
        case .LeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            break
        case .RightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            break
        case .Up:
            break
        case .Right:
            break
        case .Down:
            break
        case .Left:
            break
        }
        
        let context = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height), CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage).rawValue)
        CGContextConcatCTM(context, transform)
        
        switch (self.imageOrientation) {
        case .Left:
            CGContextDrawImage(context, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage)
            break
        case .LeftMirrored:
            CGContextDrawImage(context, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage)
            break
        case .Right:
            CGContextDrawImage(context, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage)
            break
        case .RightMirrored:
            CGContextDrawImage(context, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage)
            break
        default:
            CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage)
            break
        }
        
        let cgImage = CGBitmapContextCreateImage(context)
        let uiImage = UIImage.init(CGImage: cgImage!)
        
        return uiImage
    }
}


class VenueSelection : UIViewController,UIGestureRecognizerDelegate {
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var videoIcon: UIImageView!
    var isVideo: Bool!
    var capturedImageFile: UIImage!
    var moviePlayer : MPMoviePlayerController?
    var venuesArray : NSMutableArray = NSMutableArray()
    var selectedVenueInfo : NSMutableDictionary = NSMutableDictionary()
    
    var menuView: BTNavigationDropdownMenu!
    
    
    
    func videoHasFinishedPlaying(notification: NSNotification){
        
        print("Video finished playing")
        
        /* Find out what the reason was for the player to stop */
        let reason =
        notification.userInfo![MPMoviePlayerPlaybackDidFinishReasonUserInfoKey]
            as! NSNumber?
        
        if let theReason = reason{
            
            let reasonValue = MPMovieFinishReason(rawValue: theReason.integerValue)
            
            switch reasonValue!{
            case .PlaybackEnded:
                /* The movie ended normally */
                print("Playback Ended")
            case .PlaybackError:
                /* An error happened and the movie ended */
                print("Error happened")
            case .UserExited:
                /* The user exited the player */
                print("User exited")
            }
            
            print("Finish Reason = \(theReason)")
            stopPlayingVideo()
        }
        
    }
    
    func stopPlayingVideo() {
        
        if let player = moviePlayer{
            NSNotificationCenter.defaultCenter().removeObserver(self)
            player.stop()
            player.view.removeFromSuperview()
        }
        
    }
    
    func startPlayingVideo(){
        
        /* First let's construct the URL of the file in our application bundle
        that needs to get played by the movie player */
        
        let dataPath = globalConstants.getStoreImageVideoPath(globalConstants.kTempVideoFileName)
        //documentsDirectory.stringByAppendingPathComponent("/vid1.mp4")
        let url = NSURL.fileURLWithPath(dataPath as String)
        
        /* If we have already created a movie player before,
        let's try to stop it */
        if let _ = moviePlayer{
            stopPlayingVideo()
        }
        
        /* Now create a new movie player using the URL */
        moviePlayer = MPMoviePlayerController(contentURL: url)
        
        if let player = moviePlayer{
            
            /* Listen for the notification that the movie player sends us
            whenever it finishes playing */
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: #selector(VenueSelection.videoHasFinishedPlaying(_:)),
                name: MPMoviePlayerPlaybackDidFinishNotification,
                object: nil)
            
            print("Successfully instantiated the movie player")
            
            /* Scale the movie player to fit the aspect ratio */
            player.scalingMode = .AspectFill
            
            view.addSubview(player.view)
            
            player.setFullscreen(true, animated: false)
            
            /* Let's start playing the video in full screen mode */
            player.play()
            
        } else {
            print("Failed to instantiate the movie player")
        }
        
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)

        
        self.addtapGesture()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK : Load the Venue data from top navigation bar
    
    func displayVenuesData(){
        
        
        
        let items = NSMutableArray()
        
        for value in self.venuesArray {
            print(value)
            items.addObject((value["name"] as? String)!)
            self.selectedVenueInfo = self.venuesArray[0] as! NSMutableDictionary
        }
        
        
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: (items[0] as? String)!, items: items as [AnyObject])
        menuView.arrowImage = UIImage(named: "ArrowDown")
        menuView.checkMarkImage = UIImage(named: "checkMark")
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor(red: (126.0/255.0), green: (163.0/255.0), blue: (102.0/255.0), alpha: 1)//UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.cellTextLabelColor = UIColor.blackColor()
        menuView.cellTextLabelFont = UIFont(name: "ForgottenFuturistRg-Regular", size: 24)//UIFont(name: "Avenir-Heavy", size: 17)
        menuView.cellTextLabelAlignment = .Left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            self.title = items[indexPath] as? String
            self.selectedVenueInfo = self.venuesArray[indexPath] as! NSMutableDictionary
        }
        self.navigationItem.titleView = menuView
    }
    
    // MARK : Add Tap Gesture to ImageView
    func addtapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(VenueSelection.handleTapEvent(_:)))
        // we use our delegate
        tap.delegate = self
        // allow for user interaction
        self.capturedImage.userInteractionEnabled = true
        // add tap as a gestureRecognizer to tapView
        self.capturedImage.addGestureRecognizer(tap)
    }
    
    func handleTapEvent(sender: UITapGestureRecognizer? = nil) {
        // just creating an alert to prove our tap worked!
        if self.isVideo == true {
            self.startPlayingVideo()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        super.viewWillAppear(true)
        if self.isVideo == true {
            self.videoIcon.hidden = false

            let dataPath = globalConstants.getStoreImageVideoPath(globalConstants.kTempVideoFileName)
            do {
                capturedImage.contentMode = .ScaleToFill
                capturedImage.image = self.videoSnapshot(dataPath)
            } catch let error as NSError {
                print("Error generating thumbnail: \(error)")
            }
        }else{
            self.videoIcon.hidden = true
            capturedImage.contentMode = .ScaleToFill
            capturedImage.image = self.capturedImageFile
        }
        self.retrieveListOfVenues()
    }
    
    //MARK: - Get Image From Video URL
    func videoSnapshot(filePathLocal: NSString) -> UIImage? {
        
        let vidURL = NSURL(fileURLWithPath:filePathLocal as String)
        let asset = AVURLAsset(URL: vidURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImageAtTime(timestamp, actualTime: nil)
            return UIImage(CGImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    
    //MARK : Retrive list of venues.. 
    
    func retrieveListOfVenues(){
        self.venuesArray.removeAllObjects()
        
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)
        
        var tokenString = "token "
        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
            
            let URL =  globalConstants.kAPIURL + globalConstants.kGetVenuesList
            
            let headers = [
                "Authorization": tokenString,
                ]
            
            Alamofire.request(.GET, URL , parameters: nil, encoding: .JSON, headers : headers)
                .responseString { response in
                    
                    print("response \(response)")
                    appDelegate.stopAnimation()
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
                            let responseArray:NSArray? = globalConstants.convertStringToArray(string)
                            if let searchArray = responseArray as? NSMutableArray
                            {
                                self.venuesArray = searchArray
                                self.displayVenuesData()
                            }
                        }
                        else
                        {
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


    //MARK: Temp function to check upload file on server.
    
    func shareVenuePhotoVideo(){
        
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)

        let ID = self.selectedVenueInfo["venue_id"] as! Int
        let VenueID = String(ID)
        
        let parameters = [
            "venue_id":VenueID]
        
        let URL = globalConstants.kAPIURL + globalConstants.kPostVenuePhotoVideo
        
        var tokenString = "token "
        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
        }
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(tokenString, forKey: "Authorization")
        
//        Alamofire.Manager.sharedInstance.session.configuration
//            .HTTPAdditionalHeaders?.updateValue("multipart/form-data",
//                forKey: "Content-Type")

        //    Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue("attachment; filename=media_filename.png;", forKey: "Content-Disposition")

        var dataPath:NSString
        
        if (self.isVideo == true){
            dataPath = globalConstants.getStoreImageVideoPath(globalConstants.kTempVideoFileName)
        }else{
            dataPath = globalConstants.getStoreImageVideoPath(globalConstants.kTempImageFileNmae)
        }
        

        Alamofire.upload(.POST, URL, multipartFormData: {
            multipartFormData in
            
//            if let _image = image {
//                if let imageData = UIImageJPEGRepresentation(_image, 0.5) {
//                    multipartFormData.appendBodyPart(data: imageData, name: "file", fileName: "file.png", mimeType: "image/png")
//                }
//            }
            
            if (self.isVideo == true){
                multipartFormData.appendBodyPart(fileURL: NSURL(fileURLWithPath: dataPath as String), name: "file.mp4",fileName: globalConstants.kTempVideoFileName, mimeType: "video/mp4")
            }else{
                multipartFormData.appendBodyPart(fileURL: NSURL(fileURLWithPath: dataPath as String), name: "file.png",fileName: globalConstants.kTempImageFileNmae, mimeType: "image/png")

//                multipartFormData.appendBodyPart(fileURL: NSURL(fileURLWithPath: dataPath as String), name: "file",fileName: globalConstants.kTempImageFileNmae, mimeType:"binary/octet-stream")//"image/png"
            }
//            multipartFormData.appendBodyPart(fileURL: NSURL(fileURLWithPath: dataPath), name: "video")
            
            for (key, value) in parameters {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            
            }, encodingCompletion: {
                encodingResult in
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        appDelegate.stopAnimation()
                        self.navigationController?.popViewControllerAnimated(true)
                        debugPrint(response)
                    }
                case .Failure(let encodingError):
                    appDelegate.stopAnimation()
                    print(encodingError)
                }
        })

        
        
    }

    
    @IBAction func postButtonTapped(sender: AnyObject){
        self.shareVenuePhotoVideo()
    }

}