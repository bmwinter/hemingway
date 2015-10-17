//
//  ProfileTableViewController.swift
//  MIXR
//
//  Created by Nilesh Patel on 12/10/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit

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
        
        self.navigationItem.rightBarButtonItem = showLatestVideos;
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