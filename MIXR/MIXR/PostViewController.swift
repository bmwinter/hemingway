//
//  PostViewController.swift
//  MIXR
//
//  Created by imac04 on 11/30/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit

class PostViewController: BaseViewController {
    
    var feedDict : NSDictionary = NSDictionary()
    @IBOutlet weak var FeedName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var venuImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var feedView: UIView!
    @IBOutlet weak var btnFollowing: UIButton!
    @IBOutlet weak var btnFeedName: UIButton!
    var isUserProfile : Bool = false
    
    @IBAction func OnSettingBtnAction(sender: AnyObject)
    {
        
        let aSettingsTableViewController : SettingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SettingViewController") as! SettingViewController
        //postViewController.feedDict = feedDict
        self.navigationController!.pushViewController(aSettingsTableViewController, animated: true)
    }
    
    @IBOutlet weak var SettingBtn: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.navigationController?.interactivePopGestureRecognizer!.delegate =  self
        //self.navigationController?.interactivePopGestureRecognizer!.enabled = true        
        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
    }
    
    func loadData()
    {
        if (feedDict.allKeys.count > 0)
        {
            self.userImageView.image = UIImage(named: "userImage4.jpg")
            self.venuImageView.image = UIImage(named: feedDict["venueImage"] as! String)
            //self.FeedName.text = feedDict["venueName"] as? String
            //self.lblUserName.text = feedDict["userName"] as? String
        }
        
        if (
            isUserProfile)
        {
            self.SettingBtn.hidden = false
        }
        else
        {
            self.SettingBtn.hidden = true
        }
        
        for subview in feedView.subviews
        {
            if (subview.tag == 26)
            {
                subview.layer.cornerRadius = 0.0
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnFollowing(sender: AnyObject)
    {
        let btn : UIButton = (sender as? UIButton)!
        btn.selected = !btn.selected
        if(btn.selected)
        {
            self.btnFollowing.backgroundColor = UIColor(red: 96/255,green: 134/255.0,blue: 72/255,alpha: 1.0)
        }
        else
        {
            self.btnFollowing.backgroundColor = UIColor(red: 194/255,green: 194/255.0,blue: 194/255,alpha: 1.0)
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
