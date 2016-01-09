//
//  ProfileTableViewController.swift
//  MIXR
//
//  Created by Nilesh Patel on 12/10/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum tags:Int {
    case biography
    case favBar
}

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var status: UIButton!
    @IBOutlet weak var followers: UIButton!
    @IBOutlet weak var following: UIButton!
    @IBOutlet weak var biography: UITextView!
    @IBOutlet weak var favBars: UITextView!
    
    @IBOutlet weak var biographyLabel: UILabel!
    @IBOutlet weak var favBarsLabel: UILabel!
    
    @IBOutlet weak var showLatestVideos: UIBarButtonItem!
    
    override func viewDidLoad() {
        self.title = "Pete Dewitt"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
        //        self.navigationItem.rightBarButtonItem = showLatestVideos;
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
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
    // Show past 72 hours videos/photos
    */
    
    @IBAction func showLatestVideosButtonTapped(sender: AnyObject){
        self.performSegueWithIdentifier("RecentPhoto", sender: nil)
    }
    
    /*
    // Setting button method
    */
    
    @IBAction func settingsButtontapped(sender: AnyObject) {
    }
    
    /*
    // Status button method
    */
    @IBAction func statusButtontapped(sender: AnyObject) {
    }
    
    /*
    // Follower button method
    */
    @IBAction func followerButtontapped(sender: AnyObject) {
    }
    
    /*
    // Following button method
    */
    @IBAction func followingButtontapped(sender: AnyObject) {
    }
    
    
    /*
    // getProfileData used to Call Profile API & retrieve the user's profile data
    */
    
    func getProfileData(){
        let parameters = [
            "userID": "1"
        ]
        
        let URL =  globalConstants.kAPIURL + globalConstants.kUserProfileAPIEndPoint
        
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
    // Text View Delegate Method
    */
    func textViewDidBeginEditing(textView: UITextView){
        
    }
    func textViewDidEndEditing(textView: UITextView){
        
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        return true;
    }
    func textViewDidChange(textView: UITextView){
        
        switch (textView.tag){
        case tags.biography.rawValue :
            if !textView.hasText(){
                biographyLabel.hidden = false;
            }else{
                biographyLabel.hidden = true;
            }
        case tags.favBar.rawValue :
            if !textView.hasText(){
                favBarsLabel.hidden = false;
            }else{
                favBarsLabel.hidden = true;
            }
        default :
            print("Fizz")
        }
        
        
    }
    
}