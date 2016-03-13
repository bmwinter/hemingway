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

class VenueSelection : UIViewController,UIGestureRecognizerDelegate {
    @IBOutlet weak var capturedImage: UIImageView!
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
            let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory: AnyObject = paths[0]
            let dataPath = documentsDirectory.stringByAppendingPathComponent("/vid1.mp4")
            do {
                let asset = AVURLAsset(URL: NSURL(fileURLWithPath: dataPath), options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                let cgImage = try imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
                let uiImage = UIImage(CGImage: cgImage)
                capturedImage.image = uiImage
            } catch let error as NSError {
                print("Error generating thumbnail: \(error)")
            }
        }else{
            capturedImage.image = self.capturedImageFile
        }
    }
    
    
    @IBAction func postButtonTapped(sender: AnyObject){
    }

}