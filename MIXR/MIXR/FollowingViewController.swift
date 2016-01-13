//
//  SearchViewController.swift
//  MIXR
//
//  Created by imac04 on 11/28/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit
import SwiftyJSON

class FollowingViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,APIConnectionDelegate {
    
    //var usersArray : Array<JSON> = []
    var usersArray : NSMutableArray = NSMutableArray()
    
    let isLocalData = true
    
    var is_searching:Bool!
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var tableView: UITableView!
    
    //  MARK:- Tableview delegate -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        is_searching = false
        self.tableView.separatorColor = UIColor .clearColor()
        self.loadData()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  MARK:- UITapGestureRecognizer  -
    //Calls this function when the tap is recognized.
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //  MARK:- function OF feedsArray  -
    func loadData()
    {
        if (isLocalData)
        {
            usersArray.addObject(["userName":"Micheal Clarke","userImage":"userImage1.jpg","phoneNumber":"1234567890"])
            usersArray.addObject(["userName":"John Woggs","userImage":"userImage2.jpg","phoneNumber":"1234567890"])
            usersArray.addObject(["userName":"Hinns Hawks","userImage":"userImage3.jpg","phoneNumber":"1234567890"])
            usersArray.addObject(["userName":"Stuart Jonald","userImage":"userImage4.jpg","phoneNumber":"1234567890"])
            usersArray.addObject(["userName":"Steve Waugh","userImage":"userImage5.png","phoneNumber":"1234567890"])
            usersArray.addObject(["userName":"Jimmy Walker","userImage":"userImage6.jpg","phoneNumber":"1234567890"])
            usersArray.addObject(["userName":"Paul Smith","userImage":"userImage7.jpg","phoneNumber":"1234567890"])
            usersArray.addObject(["userName":"Martin Samueals","userImage":"userImage8.jpg","phoneNumber":"1234567890"])
            usersArray.addObject(["userName":"Ronny Hoggs","userImage":"userImage9.png","phoneNumber":"1234567890"])
            usersArray.addObject(["userName":"Peter Hinns","userImage":"userImage10.jpg","phoneNumber":"1234567890"])
            reloadTable()
        }
        else
        {
            let param: Dictionary = Dictionary<String, AnyObject>()
            //call API for to get venues
            let object = APIConnection().POST(APIName.Users.rawValue, withAPIName:"SearchUser", withMessage:"", withParam: param, withProgresshudShow: true, withHeader: false) as! APIConnection
            object.delegate = self
        }
    }
    
    func reloadTable()
    {
        tableView.reloadData()
    }
    
    //  MARK:- Tableview delegate -
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        return usersArray.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FollowingCell", forIndexPath: indexPath) as! FollowingCell
        
        let feedDict : NSDictionary = usersArray[indexPath.row] as! NSDictionary
        cell.imagePerson.image  = UIImage(named: feedDict["userImage"] as! String)
        cell.labelName.text = feedDict["userName"] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("indexpath.row = \(indexPath.row)")
        let postViewController : PostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("post") as! PostViewController
        //postViewController.feedDict = feedDict
        self.navigationController!.pushViewController(postViewController, animated: true)
        
    }
    
    //  MARK:- Button Action -
    @IBAction func BackButtonAction(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //MARK: - APIConnection Delegate -
    
    func connectionFailedForAction(action: Int, andWithResponse result: Dictionary <String, JSON>!, method : String)
    {
        switch action
        {
        case APIName.Users.rawValue:
            if ( result != nil)
            {
                DLog("\(result)")
            }
            
        default:
            DLog("Nothing")
        }
    }
    
    func connectionDidFinishedErrorResponceForAction(action: Int, andWithResponse result: Dictionary <String, JSON>!, method : String)
    {
        switch action
        {
        case APIName.Users.rawValue:
            if ( result != nil)
            {
                DLog("\(result)")
            }
            
        default:
            DLog("Nothing")
        }
    }
    
    func connectionDidFinishedForAction(action: Int, andWithResponse result: Dictionary <String, JSON>!, method : String)
    {
        switch action
        {
        case APIName.Users.rawValue:
            
            if ( result != nil)
            {
                DLog("\(result)")
                self.usersArray = (result["data"]?.arrayObject as? NSMutableArray)!
                reloadTable()
                
                //usersArray = result["data"]!.arrayObject
                //usersArray = result["data"] as! NSMutableArray
            }
            DLog("Venue")
            
        default:
            DLog("Nothing")
        }
    }
    
    func connectionDidUpdateAPIProgress(action: Int,bytesWritten: Int64, totalBytesWritten: Int64 ,totalBytesExpectedToWrite: Int64)
    {
        
    }
}
