//
//  BaseViewController.swift
//  MIXR
//
//  Created by imac04 on 1/25/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import SwiftyJSON
import Foundation
import MobileCoreServices
import Agrume
import MediaPlayer

class BaseViewController: UIViewController  ,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    @IBOutlet var btnNotificationNumber : UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        
        if ((self.navigationController?.respondsToSelector(Selector("interactivePopGestureRecognizer"))) != nil)
        {
            Log("interactivePopGestureRecognizer true \(self.navigationController!.viewControllers.count)")
            if (self.navigationController!.viewControllers.count > 1)
            {
                self.navigationController!.interactivePopGestureRecognizer!.delegate =  self
                self.navigationController!.interactivePopGestureRecognizer!.enabled = true
            }
            else
            {
                self.navigationController!.interactivePopGestureRecognizer!.delegate =  nil
                self.navigationController!.interactivePopGestureRecognizer!.enabled = false
            }
        }
        else
        {
            Log("interactivePopGestureRecognizer false")
            self.navigationController!.interactivePopGestureRecognizer!.delegate =  nil
            self.navigationController!.interactivePopGestureRecognizer!.enabled = false
        }
        
        self.updateNotificationBadge()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        // self.loadNotificationsFromServer()
        self.updateNotificationText(10)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        if (self.btnNotificationNumber != nil)
        {
            self.btnNotificationNumber.layer.cornerRadius = self.btnNotificationNumber.frame.size.width / 2
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.isKindOfClass(UIScreenEdgePanGestureRecognizer)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackClicked(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onCameraClicked(sender: AnyObject)
    {
        self.displayActionSheetForCamera()
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    // MARK:
    // MARK: Picker Controller Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let tempImage = info[UIImagePickerControllerMediaURL] as! NSURL!
        self.dismissViewControllerAnimated(true, completion: {
            let videoData = NSData(contentsOfURL: tempImage)
            if globalConstants.storeImageVideoToDocumentDirectory(videoData!, name: globalConstants.kTempVideoFileName) {
                _ = self.videoSnapshot(globalConstants.getStoreImageVideoPath(globalConstants.kTempVideoFileName))
                
                self.pushPreviewController()
            }
        })
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

    //MARK: - Push Preview View Controller
    func pushPreviewController(){
        self.navigationController?.navigationBarHidden = false
        let storyboard: UIStoryboard = UIStoryboard(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("VenueSelection") as! VenueSelection
        vc.isVideo = true
        self.showViewController(vc, sender: self)
        
    }
    
    // MARK:
    // MARK: Open Video
    
    func openCameraForVideo(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            print("captureVideoPressed and camera available.")
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera;
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            imagePicker.videoMaximumDuration = 10.0
            imagePicker.showsCameraControls = true
            
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        }
            
        else {
            print("Camera not available.")
        }
    }
    
    // MARK:
    // MARK: Open PhotoController
    
    func openPhotoGallery()
    {
        let cameraViewController = ALCameraViewController(croppingEnabled: true, allowsLibraryAccess: true) { (image) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            if image != nil{
                let imageData = UIImageJPEGRepresentation(image!, 0.5)
                if globalConstants.storeImageVideoToDocumentDirectory(imageData!, name: globalConstants.kTempImageFileNmae) {
                    let storyboard: UIStoryboard = UIStoryboard(name: "User", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("VenueSelection") as! VenueSelection
                    vc.isVideo = false
                    vc.capturedImageFile = image
                    self.showViewController(vc, sender: self)
                }
            }
        }
        presentViewController(cameraViewController, animated: true, completion: nil)
    }
    
    // MARK:
    // MARK: Custom Camera button
    
    func displayActionSheetForCamera(){
        let cancelButtonTitle = "Cancel"
        let photoButton = "Take Photo"
        let videoButton = "Record Video"
        
        let alertController = DOAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        // Create the actions.
        let cancelAction = DOAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
            NSLog("The \"Okay/Cancel\" alert action sheet's cancel action occured.")
        }
        
        let photoButtonAction = DOAlertAction(title: photoButton, style: .Default) { action in
            self.dismissViewControllerAnimated(false, completion: nil)
            self.openPhotoGallery()
            NSLog("The \"Okay/Cancel\" alert action sheet's destructive action occured.")
        }
        
        let videoButtonAction = DOAlertAction(title: videoButton, style: .Default) { action in
            self.dismissViewControllerAnimated(false, completion: nil)
            self.openCameraForVideo()
            NSLog("The \"Okay/Cancel\" alert action sheet's destructive action occured.")
        }
        
        // Add the actions.
        alertController.addAction(cancelAction)
        alertController.addAction(photoButtonAction)
        alertController.addAction(videoButtonAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK:
    // MARK: Image preview
    @IBAction func onImagePreviewClicked(sender: AnyObject)
    {
        if let button = sender as? UIButton {
            
            if let image = button.imageForState(.Normal)
            {
                self.previewImages(image)
            }
            //            let agrume = Agrume(image: image)
            //            agrume.showFrom(self)
        }
    }
    
    func previewImages(image : UIImage = UIImage(named: "placeholder.png")!)
    {
        let images = [
            image
        ]
        self.previewImagesFromArray(images)
    }
    
    func previewImagesFromArray(images : NSArray, startIndex : Int = 0)
    {
        let agrume = Agrume(images: images as! [UIImage], startIndex: startIndex, backgroundBlurStyle: .ExtraLight)
        //        agrume.didScroll = {
        //            [unowned self] index in
        //            Log("index \(index)")
        //            //            self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0),
        //            //                atScrollPosition: [],
        //            //                animated: false)
        //        }
        agrume.showFrom(self)
    }
    
    func updateNotificationBadge()
    {
        if(self.btnNotificationNumber != nil)
        {
            self.btnNotificationNumber.layer.cornerRadius = self.btnNotificationNumber.frame.size.width/2
            self.btnNotificationNumber.setTitle("10", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func NotificatiDeatil(sender: AnyObject) {
        
        let NotificationView : NotificationViewController = self.storyboard!.instantiateViewControllerWithIdentifier("NotificationViewController") as! NotificationViewController
        self.navigationController!.pushViewController(NotificationView, animated: true)
    }
    
    
    func updateNotificationText(notificationCount:Int)
    {
        if (self.btnNotificationNumber != nil)
        {
            if (notificationCount > 0)
            {
                if (notificationCount == 0)
                {
                    self.btnNotificationNumber.hidden = true
                    self.btnNotificationNumber.setTitle("", forState: UIControlState.Normal)
                }
                else
                {
                    self.btnNotificationNumber.hidden = false
                    self.btnNotificationNumber.setTitle("\(notificationCount)", forState: UIControlState.Normal)
                }
            }
            else
            {
                self.btnNotificationNumber.hidden = true
                self.btnNotificationNumber.setTitle("", forState: UIControlState.Normal)
            }
        }
    }
    
    func convertStringToDictionary(text:String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func convertStringToArray(text:String) -> NSArray? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
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
