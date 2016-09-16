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
    
    enum MyProfileSegment: Int {
        case MyPosts = 0
        case MySettings = 1
    }
    
    var userDict : NSDictionary = NSDictionary()
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var feedView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl?
    
    @IBOutlet weak var settingsContainerView: UIView?
    @IBOutlet weak var feedContainerView: UIView?
    
    private var selectedViewController: UIViewController?
    
    // TODO: remove if possible
    var userId = ""
    var isUserProfile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        segmentedControl?.addTarget(self, action: #selector(PostViewController.segmentedControlValueDidChange(_:)), forControlEvents: .ValueChanged)
        segmentedControl?.selectedSegmentIndex = 0
        
        if let segmentedControl = segmentedControl {
            segmentedControlValueDidChange(segmentedControl)
        }
    }
    
    func setupUI() {
        // segmented control
        if let segmentedControl = segmentedControl {
            let font = UIFont.regularFontWithSize(12.0)
            segmentedControl.setTitleTextAttributes([
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: UIColor.blackColor()
                ], forState: .Normal)
            segmentedControl.setTitleTextAttributes([
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: UIColor.blackColor()
                ], forState: .Selected)
            segmentedControl.backgroundColor = UIColor.clearColor()
            segmentedControl.tintColor = UIColor.mixrGreen()
            
            for subview in segmentedControl.subviews {
                subview.layer.borderColor = UIColor.grayColor().CGColor
                subview.layer.cornerRadius = 0.0
                subview.layer.borderWidth = 1.0
            }
        }
        
    }
    
    func segmentedControlValueDidChange(sender: UISegmentedControl) {
        if let segment = MyProfileSegment(rawValue: sender.selectedSegmentIndex) {
            switch (segment) {
            case .MyPosts:
                feedContainerView?.alpha = 1
                settingsContainerView?.alpha = 0
                return
            case .MySettings:
                feedContainerView?.alpha = 0
                settingsContainerView?.alpha = 1
                return
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
}
