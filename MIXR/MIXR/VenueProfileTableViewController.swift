//
//  VenueProfileTableViewController.swift
//  MIXR
//
//  Created by Nilesh Patel on 22/10/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VenueProfileTableViewController: UITableViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var venuePicture: UIImageView!
    @IBOutlet weak var noofFillsImage: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnVenueName: UIButton!
    @IBOutlet weak var barTiming: UILabel!
    @IBOutlet weak var venueAddress: UILabel!
    @IBOutlet weak var venueSpecial: UILabel!
    @IBOutlet weak var eventsAtVenue: UILabel!
    @IBOutlet weak var eventsScrollView: UIScrollView!
    @IBOutlet weak var venueSpecialScrollView: UIScrollView!
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var showLatestVideos: UIBarButtonItem!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.navigationController?.interactivePopGestureRecognizer!.delegate =  self
        //self.navigationController?.interactivePopGestureRecognizer!.enabled = true        
        self.title = "Spanky's"
        self.navigationItem.rightBarButtonItem = showLatestVideos;
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
        loadDummyScrollViewData()
        
        // Do any additional setup after loading the view, typically from a nib.
        //self.pullToReferesh()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        //self.navigationController?.navigationBarHidden = false
    }
    
    func loadDummyScrollViewData()
    {
        
        var eventHeight : CGFloat = 40.0
        for i in 1...15
        {
            let test:UILabel
            test = UILabel()
            test.textAlignment = NSTextAlignmentFromCTTextAlignment(CTTextAlignment.Left)
            test.text = "Event Data \(i)"
            test.font = UIFont(name: "ForgottenFuturistRg-Regular", size: 20)
            test.frame = CGRectMake(5, (CGFloat)(i * 20), self.eventsScrollView.frame.size.width-10, 20);
            eventHeight = eventHeight + 20
            self.eventsScrollView.addSubview(test)
        }
        
        self.eventsScrollView.layer.borderColor = UIColor(red: (214.0/255.0), green: (214.0/255.0), blue: (214.0/255.0), alpha: 1).CGColor
        self.eventsScrollView.layer.borderWidth = 2.0
        
        var SpecialHeight : CGFloat = 40.0
        
        for i in 1...5
        {
            let test:UILabel
            test = UILabel()
            test.textAlignment = NSTextAlignmentFromCTTextAlignment(CTTextAlignment.Left)
            test.text = "Special Deal \(i)"
            test.font = UIFont(name: "ForgottenFuturistRg-Regular", size: 20)
            test.frame = CGRectMake(5, (CGFloat)(i * 20), self.venueSpecialScrollView.frame.size.width-10, 20);
            SpecialHeight = SpecialHeight + 20
            self.venueSpecialScrollView.addSubview(test)
        }
        
        var bottomViewFrame = self.bottomView.frame
        bottomViewFrame.size.height = (eventHeight > SpecialHeight) ? eventHeight: SpecialHeight
        self.bottomView.frame = bottomViewFrame
        var outerViewFrame = self.outerView.frame
        outerViewFrame.size.height = self.bottomView.frame.origin.y + self.bottomView.frame.size.height
        self.outerView.frame = outerViewFrame
        
        self.venueSpecialScrollView.contentSize = CGSizeMake( 145, self.bottomView.frame.size.height)
        self.venueSpecialScrollView.scrollEnabled = false
        self.eventsScrollView.contentSize = CGSizeMake( 145, self.bottomView.frame.size.height)
        self.eventsScrollView.scrollEnabled = false
        self.venueSpecialScrollView.layer.borderColor = UIColor(red: (214.0/255.0), green: (214.0/255.0), blue: (214.0/255.0), alpha: 1).CGColor
        self.venueSpecialScrollView.layer.borderWidth = 2.0
        self.noofFillsImage.layer.borderColor = UIColor(red: (214.0/255.0), green: (214.0/255.0), blue: (214.0/255.0), alpha: 1).CGColor
        self.noofFillsImage.layer.borderWidth = 2.0
        self.btnVenueName.setTitle("Mad River", forState: .Normal)
    }
    
    /*
    // getProfileData used to Call Profile API & retrieve the user's profile data
    */
    
    func getVenueProfileData(){
        let parameters = [
            "userID": "1"
        ]
        
        let URL =  globalConstants.kAPIURL + globalConstants.kVenueDetailsAPIEndPoint
        
        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                guard let value = response.result.value else {
                    print("Error: did not receive data")
                    return
                }
                
                guard response.result.error == nil else {
                    print("error calling POST")
                    print(response.result.error)
                    return
                }
                let post = JSON(value)
                print("The post is: " + post.description)
        }
    }
    
    
    
    /*
    // Table View delegate methods
    */
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    /*
    // IBAction methods
    */
    
    /*
    // Following button method
    */
    
    
    @IBAction func likeBtnClicked(sender: AnyObject)
    {
        let btn : UIButton = (sender as? UIButton)!
        btn.selected = !btn.selected
        if(btn.selected)
        {
            self.btnLike.backgroundColor = UIColor(red: 96/255,green: 134/255.0,blue: 72/255,alpha: 1.0)
        }
        else
        {
            self.btnLike.backgroundColor = UIColor(red: 194/255,green: 194/255.0,blue: 194/255,alpha: 1.0)
        }
    }
    
}