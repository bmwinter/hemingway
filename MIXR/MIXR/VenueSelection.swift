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
class VenueSelection : UIViewController,UIGestureRecognizerDelegate {
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var videoIcon: UIImageView!
    var isVideo: Bool!
    var capturedImageFile: UIImage!
    var moviePlayer : MPMoviePlayerController?

    
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
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent("/vid1.mp4")
        let url = NSURL.fileURLWithPath(dataPath)
        
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
                selector: "videoHasFinishedPlaying:",
                name: MPMoviePlayerPlaybackDidFinishNotification,
                object: nil)
            
            print("Successfully instantiated the movie player")
            
            /* Scale the movie player to fit the aspect ratio */
            player.scalingMode = .AspectFit
            
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

        let items = ["Most Popular", "Latest", "Trending", "Nearest", "Top Picks"]
//        self.selectedCellLabel.text = items.first
//        self.navigationController?.navigationBar.translucent = false
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items.first!, items: items)
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
            self.title = items[indexPath]
        }
        self.navigationItem.titleView = menuView
        
        self.addtapGesture()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func addtapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTapEvent:"))
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
            let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory: AnyObject = paths[0]
            let dataPath = documentsDirectory.stringByAppendingPathComponent("/vid1.mp4")
            do {
                let asset = AVURLAsset(URL: NSURL(fileURLWithPath: dataPath), options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                let cgImage = try imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
                let uiImage = UIImage(CGImage: cgImage)
                capturedImage.image = uiImage
                capturedImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2));

            } catch let error as NSError {
                print("Error generating thumbnail: \(error)")
            }
        }else{
            self.videoIcon.hidden = true
            capturedImage.image = self.capturedImageFile
        }
        self.shareVenuePhotoVideo()
    }
    
    //MARK: Temp function to check upload file on server.
    
    func shareVenuePhotoVideo(){
        /*
        let fileURL = NSBundle.mainBundle().URLForResource("mixriconApp_icon", withExtension: "png")
        
        let URL =  globalConstants.kAPIURL + globalConstants.kPostVenuePhotoVideo
        
        var tokenString = "token "
        tokenString +=  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as! String
        
        
        
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(tokenString, forKey: "Authorization")
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue("attachment; filename=media_filename.png;", forKey: "Content-Disposition")
        
        Alamofire.upload(.POST, URL, file: fileURL!)
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
*/
        
        let parameters = [
            "venue_id": "1"]
        
        let URL = globalConstants.kAPIURL + globalConstants.kPostVenuePhotoVideo
        
//        let image = UIImage(named: "mixriconApp_icon.png")
        
        var tokenString = "token "
        tokenString +=  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as! String
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(tokenString, forKey: "Authorization")
        Alamofire.Manager.sharedInstance.session.configuration
            .HTTPAdditionalHeaders?.updateValue("multipart/form-data",
                forKey: "Content-Type")

//        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue("attachment; filename=media_filename.png;", forKey: "Content-Disposition")
//        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent("/vid1.mp4")
//        let asset = AVURLAsset(URL: NSURL(fileURLWithPath: dataPath), options: nil)
        
        Alamofire.upload(.POST, URL, multipartFormData: {
            multipartFormData in
            
//            if let _image = image {
//                if let imageData = UIImageJPEGRepresentation(_image, 0.5) {
//                    multipartFormData.appendBodyPart(data: imageData, name: "file", fileName: "file.png", mimeType: "image/png")
//                }
//            }
            
            multipartFormData.appendBodyPart(fileURL: NSURL(fileURLWithPath: dataPath), name: "file",fileName: "test.mp4", mimeType: "video/mp4")
            
//            multipartFormData.appendBodyPart(fileURL: NSURL(fileURLWithPath: dataPath), name: "video")
            
            for (key, value) in parameters {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            
            }, encodingCompletion: {
                encodingResult in
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
        })

        
        
    }

    
    @IBAction func postButtonTapped(sender: AnyObject){
    }

}