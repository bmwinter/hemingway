//
//  SearchViewController.swift
//  MIXR
//
//  Created by imac04 on 11/28/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit



class SearchViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    let feedsArray : NSMutableArray = NSMutableArray()
    var searchingArray:NSMutableArray!
    
    @IBOutlet var searchBarObj: UISearchBar!
    
    var is_searching:Bool!
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var tableView: UITableView!
    
    //  MARK:- Tableview delegate -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        searchingArray = []
        is_searching = false
        
        searchBarObj.layer.cornerRadius = 10.0
        
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
        feedsArray.addObject(["Name":"Micheal Clarke","venueImage":"userImage1.jpg"])
        feedsArray.addObject(["Name":"John Woggs","venueImage":"userImage2.jpg"])
        feedsArray.addObject(["Name":"Hinns Hawks","venueImage":"userImage3.jpg"])
        feedsArray.addObject(["Name":"Stuart Jonald","venueImage":"userImage4.jpg"])
        feedsArray.addObject(["Name":"Steve Waugh","venueImage":"userImage5.png"])
        feedsArray.addObject(["Name":"Jimmy Walker","venueImage":"userImage6.jpg"])
        feedsArray.addObject(["Name":"Paul Smith","venueImage":"userImage7.jpg"])
        feedsArray.addObject(["Name":"Martin Samueals","venueImage":"userImage8.jpg"])
        feedsArray.addObject(["Name":"Ronny Hoggs","venueImage":"userImage9.png"])
        feedsArray.addObject(["Name":"Peter Hinns","venueImage":"userImage10.jpg"])
    }
    
    
    //  MARK:- Tableview delegate -
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        if is_searching == true {
            return searchingArray.count
        }else{
            return feedsArray.count  //Currently Giving default Value
        }
        
    }
    
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SearchTableViewCell
        
        if is_searching == true{
            let feedDict : NSDictionary = searchingArray[indexPath.row] as! NSDictionary
            cell.imagePerson.image  = UIImage(named: feedDict["venueImage"] as! String)
            cell.labelName.text = feedDict["Name"] as! NSString as String
            
            
            
            //            cell.textLabel!.text = searchingArray[indexPath.row] as! NSString as String
        }else{
            let feedDict : NSDictionary = feedsArray[indexPath.row] as! NSDictionary
            cell.imagePerson.image  = UIImage(named: feedDict["venueImage"] as! String)
            cell.labelName.text = feedDict["Name"] as? String
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("indexpath.row = \(indexPath.row)")
    }
    
    //  MARK:- Button Action -
    @IBAction func NotificatiDeatil(sender: AnyObject) {
        
        
        
        let NotificationView : NotificationViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Notification") as! NotificationViewController
        
        self.navigationController!.pushViewController(NotificationView, animated: true)
        
    }
    
    //  MARK:- Searchbar Delegate -
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text!.isEmpty{
            is_searching = false
            tableView.reloadData()
        } else {
            print(" search text %@ ",searchBar.text! as NSString)
            is_searching = true
            searchingArray.removeAllObjects()
            for var index = 0; index < feedsArray.count; index++
            {
                let currentString = feedsArray.objectAtIndex(index)["Name"] as! String
                if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil
                {
                    searchingArray.addObject(feedsArray.objectAtIndex(index))
                }
            }
            tableView.reloadData()
        }
    }
    
}
