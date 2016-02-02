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
    @IBOutlet weak var fillsCount: UILabel!
    @IBOutlet weak var barTiming: UILabel!
    @IBOutlet weak var venueAddress: UILabel!
    @IBOutlet weak var venueSpecial: UILabel!
    @IBOutlet weak var eventsAtVenue: UILabel!
    @IBOutlet weak var eventsScrollView: UIScrollView!
    @IBOutlet weak var venueSpecialScrollView: UIScrollView!
    
    
    @IBOutlet weak var showLatestVideos: UIBarButtonItem!
    
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
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        //self.navigationController?.navigationBarHidden = false
    }
    func loadDummyScrollViewData()
    {
        self.eventsScrollView.contentSize = CGSizeMake( 145, 20*51);
        for i in 1...50
        {
            let test:UILabel
            test = UILabel()
            test.textAlignment = NSTextAlignmentFromCTTextAlignment(CTTextAlignment.Center)
            test.text = "Test Data"
            test.font = UIFont(name: "ForgottenFuturistRg-Regular", size: 20)
            test.frame = CGRectMake(0, (CGFloat)(i * 20), self.eventsScrollView.frame.size.width, 20);
            self.eventsScrollView.addSubview(test)
        }
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
    @IBAction func followingButtontapped(sender: AnyObject) {
    }
    
    
}