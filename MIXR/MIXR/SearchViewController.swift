//
//  SearchViewController.swift
//  MIXR
//
//  Created by imac04 on 11/28/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,APIConnectionDelegate {
    
    var usersArray : NSMutableArray = NSMutableArray()
    
    var usersArray1 : NSMutableArray = NSMutableArray()
    
    var searchingArray:NSMutableArray!
    let isLocalData = false
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
        if (isLocalData)
        {
            usersArray.addObject(["userName":"Micheal Clarke","userImage":"userImage1.jpg"])
            usersArray.addObject(["userName":"John Woggs","userImage":"userImage2.jpg"])
            usersArray.addObject(["userName":"Hinns Hawks","userImage":"userImage3.jpg"])
            usersArray.addObject(["userName":"Stuart Jonald","userImage":"userImage4.jpg"])
            usersArray.addObject(["userName":"Steve Waugh","userImage":"userImage5.png"])
            usersArray.addObject(["userName":"Jimmy Walker","userImage":"userImage6.jpg"])
            usersArray.addObject(["userName":"Paul Smith","userImage":"userImage7.jpg"])
            usersArray.addObject(["userName":"Martin Samueals","userImage":"userImage8.jpg"])
            usersArray.addObject(["userName":"Ronny Hoggs","userImage":"userImage9.png"])
            usersArray.addObject(["userName":"Peter Hinns","userImage":"userImage10.jpg"])
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
        if is_searching == true {
            return searchingArray.count
        }else{
            return usersArray.count  //Currently Giving default Value
        }
        
    }
    
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SearchTableViewCell
        
        if is_searching == true{
            let feedDict : NSDictionary = searchingArray[indexPath.row] as! NSDictionary
            cell.imagePerson.image  = UIImage(named: feedDict["userImage"] as! String)
            cell.labelName.text = feedDict["userName"] as! NSString as String
          cell.mobileNumber.text = feedDict["phoneNumber"] as! NSString as String
            
            
            //            cell.textLabel!.text = searchingArray[indexPath.row] as! NSString as String
        }else{
            let feedDict : NSDictionary = usersArray[indexPath.row] as! NSDictionary
            cell.imagePerson.image  = UIImage(named: feedDict["userImage"] as! String)
            cell.labelName.text = feedDict["userName"] as? String
           cell.mobileNumber.text = feedDict["phoneNumber"] as! NSString as String
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
            print("search text %@ ",searchBar.text! as NSString)
            is_searching = true
            searchingArray.removeAllObjects()
            
            let temp = self.searchBarObj.text
            print(self.usersArray)
            
            let resultPredicate : NSPredicate = NSPredicate(format: "userName contains[c] %@ || phoneNumber contains[c] %@",searchBar.text! as NSString,searchBar.text! as NSString)
            let searchResults = self.usersArray.filteredArrayUsingPredicate(resultPredicate)
            self.searchingArray = NSMutableArray(array: searchResults)
            
            print("seaarching array \(self.searchingArray)")
            
            tableView.reloadData()
        }
    }
    
    
    
    //MARK: - APIConnection Delegate -
    
    func connectionFailedForAction(action: Int, andWithResponse result: NSDictionary!, method : String)
    {
        switch action
        {
        case APIName.Users.rawValue:
            if ( result != nil)
            {
                if ( result.isKindOfClass(NSDictionary))
                {
                    DLog("\(result)")
                }
            }
            
        default:
            DLog("Nothing")
        }
    }
    
    func connectionDidFinishedErrorResponceForAction(action: Int, andWithResponse result: NSDictionary!, method : String)
    {
        switch action
        {
        case APIName.Users.rawValue:
            if ( result != nil)
            {
                if ( result.isKindOfClass(NSDictionary))
                {
                    DLog("\(result)")
                }
            }
            
        default:
            DLog("Nothing")
        }
        
    }
    
    func connectionDidFinishedForAction(action: Int, andWithResponse result: NSDictionary!, method : String)
    {
        switch action
        {
        case APIName.Users.rawValue:
            
            if ( result != nil)
            {
                if ( result.isKindOfClass(NSDictionary))
                {
                    usersArray = result["data"] as! NSMutableArray
                    DLog("usersArray \(usersArray)")
                    reloadTable()
                }
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
