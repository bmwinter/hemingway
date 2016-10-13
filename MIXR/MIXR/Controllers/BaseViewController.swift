//
//  BaseViewController.swift
//  MIXR
//
//  Created by imac04 on 1/25/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import Foundation
import MobileCoreServices
import Agrume
import MediaPlayer

class MXNavigationController: UINavigationController { }

class BaseViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet var btnNotificationNumber : UIButton?
}

// MARK: - View Lifecycle
extension BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if navigationController is MXNavigationController {
            setupNavigationBar()
        } else {
            navigationController?.navigationBarHidden = true
        }
        
        if ((self.navigationController?.respondsToSelector(Selector("interactivePopGestureRecognizer"))) != nil) {
            Log("interactivePopGestureRecognizer true \(self.navigationController!.viewControllers.count)")
            if (self.navigationController!.viewControllers.count > 1) {
                self.navigationController!.interactivePopGestureRecognizer!.delegate =  self
                self.navigationController!.interactivePopGestureRecognizer!.enabled = true
            } else {
                self.navigationController!.interactivePopGestureRecognizer!.delegate =  nil
                self.navigationController!.interactivePopGestureRecognizer!.enabled = false
            }
        } else {
            Log("interactivePopGestureRecognizer false")
            self.navigationController?.interactivePopGestureRecognizer?.delegate =  nil
            self.navigationController?.interactivePopGestureRecognizer?.enabled = false
        }
        
        self.updateNotificationBadge()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateNotificationText(10)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let notificationNumberButton = btnNotificationNumber {
            notificationNumberButton.layer.cornerRadius = notificationNumberButton.frame.size.width / 2
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.isKindOfClass(UIScreenEdgePanGestureRecognizer)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate
extension BaseViewController: UIImagePickerControllerDelegate {
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
}

// MARK: - NavigationBar & Related Utility Methods
extension BaseViewController {
    
    @IBAction func onBackClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onCameraClicked(sender: AnyObject) {
        self.displayActionSheetForCamera()
    }
    
    @IBAction func onNotificationButtonClicked(sender: AnyObject) {
        if let promotionVC = self.storyboard?.instantiateViewControllerWithIdentifier("PromotionsViewController") as? PromotionsViewController {
            self.navigationController?.pushViewController(promotionVC, animated: true)
        }
    }
    
    func updateNotificationBadge()
    {
        if let notificationNumberButton = btnNotificationNumber {
            notificationNumberButton.layer.cornerRadius = notificationNumberButton.frame.size.width/2
            notificationNumberButton.setTitle("10", forState: UIControlState.Normal)
        }
    }
    
    
    func updateNotificationText(notificationCount:Int)
    {
        if (self.btnNotificationNumber != nil) {
            if (notificationCount > 0) {
                if (notificationCount == 0) {
                    self.btnNotificationNumber?.hidden = true
                    self.btnNotificationNumber?.setTitle("", forState: UIControlState.Normal)
                } else {
                    self.btnNotificationNumber?.hidden = false
                    self.btnNotificationNumber?.setTitle("\(notificationCount)", forState: UIControlState.Normal)
                }
            }
            else
            {
                self.btnNotificationNumber?.hidden = true
                self.btnNotificationNumber?.setTitle("", forState: UIControlState.Normal)
            }
        }
    }
}

// MARK: - Photo methods
extension BaseViewController {
    
    func pushPreviewController() {
        let storyboard: UIStoryboard = UIStoryboard(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("VenueSelection") as! VenueSelection
        vc.isVideo = true
        self.showViewController(vc, sender: self)
    }
    
    @IBAction func onImagePreviewClicked(sender: AnyObject) {
        if let button = sender as? UIButton,
            let image = button.imageForState(.Normal) {
            self.previewImages(image)
        }
    }
    
    func previewImages(image : UIImage = UIImage(named: "placeholder.png")!) {
        let images = [
            image
        ]
        self.previewImagesFromArray(images)
    }
    
    func previewImagesFromArray(images : NSArray, startIndex : Int = 0) {
        let agrume = Agrume(images: images as! [UIImage], startIndex: startIndex, backgroundBlurStyle: .ExtraLight)
        agrume.showFrom(self)
    }
}

// MARK: - Leftover methods from previous developer
extension UIViewController {
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
    
    func convertStringToArray(text:String) -> NSArray?
    {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}

extension BaseViewController {
}

extension BaseViewController: MXNavigationBarTrait {
    func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.barTintColor = UIColor.mixrGray()
        
        let useDefaultImage = shouldUseDefaultImage()
        navigationBar.hidden = shouldHideNavigationBar()
        
        if useDefaultImage {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.contentMode = .ScaleAspectFit
            let image = UIImage(named: "MixrLogo")
            imageView.image = image
            navigationItem.titleView = imageView
        }
        
        if navigationController?.viewControllers.count <= 1 {
            navigationItem.leftBarButtonItem = barButtonItem(withType: leftBarButtonType())
        } else {
            navigationItem.leftBarButtonItem = barButtonItem(withType: .Back)
        }
        navigationItem.rightBarButtonItem = barButtonItem(withType: rightBarButtonType())
    }
    
    func shouldHideNavigationBar() -> Bool {
        return false
    }
    
    private func barButtonItem(withType type: MXBarButtonType) -> UIBarButtonItem? {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        switch type {
        case .Notification:
            button.setBackgroundImage(UIImage(named: "martini3-1"), forState: .Normal)
            button.addTarget(self, action: #selector(BaseViewController.notificationBarButtonWasClicked(_:)), forControlEvents: .TouchUpInside)
            break
        case .Camera:
            button.setBackgroundImage(UIImage(named: "camera_icon"), forState: .Normal)
            button.frame = CGRect(x: 0, y: 0, width: 35, height: 30)
            button.addTarget(self, action: #selector(BaseViewController.cameraBarButtonWasClicked(_:)), forControlEvents: .TouchUpInside)
            break
        case .Back:
            button.setBackgroundImage(UIImage(named: "ArrowLeft"), forState: .Normal)
            button.frame = CGRect(x: 0, y: 0, width: 16, height: 28)
            button.addTarget(self, action: #selector(BaseViewController.backBarButtonWasClicked(_:)), forControlEvents: .TouchUpInside)
        default:
            return nil
        }
        
        return UIBarButtonItem(customView: button)
    }
}

// MARK: bar button actions
extension BaseViewController {
    @objc func notificationBarButtonWasClicked(button: UIBarButtonItem) {
        if let promotionVC = self.storyboard?.instantiateViewControllerWithIdentifier("PromotionsViewController") as? PromotionsViewController {
            self.navigationController?.pushViewController(promotionVC, animated: true)
        }
    }
    
    @objc func cameraBarButtonWasClicked(button: UIBarButtonItem) {
        displayActionSheetForCamera()
    }
    
    @objc func backBarButtonWasClicked(button: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension BaseViewController {
    /// Get Image From Video URL
    func videoSnapshot(filePathLocal: NSString) -> UIImage? {
        
        let vidURL = NSURL(fileURLWithPath:filePathLocal as String)
        let asset = AVURLAsset(URL: vidURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImageAtTime(timestamp, actualTime: nil)
            return UIImage(CGImage: imageRef)
        } catch let error as NSError {
            Log("Image generation failed with error \(error)")
            return nil
        }
    }
    
    func openCameraForVideo() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera;
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            imagePicker.videoMaximumDuration = 10.0
            imagePicker.showsCameraControls = true
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            Log("Camera not available.")
        }
    }
    
    func displayActionSheetForCamera() {
        let cancelButtonTitle = "Cancel"
        let photoButton = "Take Photo"
        let videoButton = "Record Video"
        
        let alertController = DOAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        // Create the actions.
        let cancelAction = DOAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
        }
        
        let photoButtonAction = DOAlertAction(title: photoButton, style: .Default) { action in
            self.dismissViewControllerAnimated(false, completion: nil)
            self.openPhotoGallery()
        }
        
        let videoButtonAction = DOAlertAction(title: videoButton, style: .Default) { action in
            self.dismissViewControllerAnimated(false, completion: nil)
            self.openCameraForVideo()
        }
        
        // Add the actions.
        alertController.addAction(cancelAction)
        alertController.addAction(photoButtonAction)
        alertController.addAction(videoButtonAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func openPhotoGallery() {
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
}
