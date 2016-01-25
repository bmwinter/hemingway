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


class BaseViewController: UIViewController  ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
        let pathString = tempImage.relativePath
        self.dismissViewControllerAnimated(true, completion: {})
        
        UISaveVideoAtPathToSavedPhotosAlbum(pathString!, self, nil, nil)
        
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
    
    func openPhotoGallery(){
        let cameraViewController = ALCameraViewController(croppingEnabled: true, allowsLibraryAccess: true) { (image) -> Void in
            //            self.imageView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        presentViewController(cameraViewController, animated: true, completion: nil)
        
    }
    
    // MARK:
    // MARK: Custom Camera button
    
    func displayActionSheetForCamera(){
        let cancelButtonTitle = "Cancel"
        let photoButton = "Take Photo"
        let videoButton = "Take Video"
        
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
    
    
    
}
