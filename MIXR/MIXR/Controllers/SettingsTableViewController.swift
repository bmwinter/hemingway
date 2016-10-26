//
//  SettingsTableViewController.swift
//  MIXR
//
//  Created by Nilesh Patel on 31/10/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

enum SettingsTag: Int {
    case ChangePassword = 0
    case PrivacyPolicy = 1
    case Terms = 2
    case Logout = 3
    
    var stringLabel: String {
        switch self {
        case .ChangePassword:
            return "Change Password"
        case .PrivacyPolicy:
            return "Privacy Policy"
        case .Terms:
            return "Terms & Conditions"
        case .Logout:
            return "Log Out"
        }
    }
}

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var publicPrivateSwitch: UISwitch?
    /*
    // Table View delegate methods
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.navigationController?.interactivePopGestureRecognizer!.delegate =  self
        //self.navigationController?.interactivePopGestureRecognizer!.enabled = true        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
        self.title = "Settings"
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getProfilePrivacy()
    }
    
    //MARK: PublicPrivate Switch Event
    
    @IBAction func publicPrivateSwitchChange (sender:AnyObject){
        self.updateProfilePrivacy()
    }
    
    func getProfilePrivacy() {
        APIManager.sharedInstance.fetchProfilePrivacy({ [weak self] (response) in
            self?.publicPrivateSwitch?.on = response["public"].boolValue
            }, failure: nil)
    }
    
    func updateProfilePrivacy() {
        APIManager.sharedInstance.updateProfilePrivacy({ [weak self] (response) in
            self?.publicPrivateSwitch?.on = response["public"].boolValue
            }, failure: nil)
    }
}

// MARK: UITableViewDataSource Protocol
extension SettingsTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("settingsTableViewCell", forIndexPath: indexPath) as? SettingsTableViewCell{
            let value = indexPath.section * 2 + indexPath.row
            let setting = SettingsTag(rawValue: value)
            cell.setting = setting?.stringLabel
            return cell
        }
        /// shouldn't make it here
        return UITableViewCell(style: .Default, reuseIdentifier: "nullCell")
    }
}

// MARK: UITableViewDelegate Protocol
extension SettingsTableViewController {
    
    func textForSection(section: Int) -> String {
        if section == 0 {
            return "Me"
        } else {
            return "MIXR"
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let height = self.tableView(tableView, heightForHeaderInSection: section)
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: height)
        let view = UIView(frame: frame)
        
        let label = UILabel()
        label.font = UIFont.boldFontWithSize(20.0)
        label.text = textForSection(section)
        label.sizeToFit()
        
        label.frame = CGRect(x: 20, y: (height-label.frame.height)/2, width: label.frame.width, height: label.frame.height)
        
        let lineView = UIView(frame: CGRect(x: label.frame.maxX + 5, y: (height-1)/2, width: tableView.frame.width - label.frame.maxX - 20, height: 1))
        lineView.backgroundColor = UIColor.mixrLightGray()
        
        view.addSubview(label)
        view.addSubview(lineView)
        
        return view
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // super-hacky should refactor
        let value = indexPath.section * 2 + indexPath.row
        if let setting = SettingsTag(rawValue: value) {
            switch setting {
            case .ChangePassword:
                let aChangePassword : ChangePassword = self.storyboard!.instantiateViewControllerWithIdentifier("ChangePassword") as! ChangePassword
                self.navigationController!.pushViewController(aChangePassword, animated: true)
            case .PrivacyPolicy:
                print("Terms & Condition")
            case .Terms:
                print("Terms & Condition")
            case .Logout:
                NSUserDefaults.standardUserDefaults().setObject("", forKey: "LoginToken")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }
}
