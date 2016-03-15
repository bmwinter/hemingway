//
//  SearchViewController.swift
//  MIXR
//
//  Created by imac04 on 11/28/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SearchViewController: BaseViewController, UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,APIConnectionDelegate {
    
    var refreshControl:UIRefreshControl!
    //var usersArray : Array<JSON> = []
    var usersArray : NSMutableArray = NSMutableArray()
    
    var searchingArray:NSMutableArray!
    let isLocalData = true
    @IBOutlet var searchBarObj: UISearchBar!
    
    var is_searching:Bool!
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var feedcount : Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        is_searching = false
        self.tableView.separatorColor = UIColor .clearColor()
        self.loadData()
        
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        // view.addGestureRecognizer(tap)
        
        searchingArray = []
        searchBarObj.layer.cornerRadius = 10.0
        
        // self.pullToReferesh()
        // Do any additional setup after loading the view.
    }
    
    func pullToReferesh()
    {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Updating")
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
    }
    
    func refresh(sender:AnyObject)
    {
        feedcount = 0
        self.loadData()
        // Code to refresh table view
        self.performSelector(Selector("endReferesh"), withObject: nil, afterDelay: 1.0)
    }
    
    func endReferesh()
    {
        //End refresh control
        self.refreshControl?.endRefreshing()
        //Remove refresh control to superview
        //self.refreshControl?.removeFromSuperview()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  MARK:- UITapGestureRecognizer  -
    //Calls this function when the tap is recognized.
    
    func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //  MARK:- function OF feedsArray  -
    func loadData()
    {
        if (isLocalData)
        {
            //profile_picture, title, subtitle
            usersArray.addObject(["title":"Micheal Clarke","profile_picture":"userImage1.jpg","subtitle":"1234567890"])
            usersArray.addObject(["title":"Mad River1","profile_picture":"venueImage1.jpg","subtitle":"Grant Boyle1"])
            usersArray.addObject(["title":"John Woggs","profile_picture":"userImage2.jpg","subtitle":"1234567890"])
            usersArray.addObject(["title":"Mad River2","profile_picture":"venueImage2.jpg","subtitle":"Grant Boyle2"])
            usersArray.addObject(["title":"Hinns Hawks","profile_picture":"userImage3.jpg","subtitle":"1234567890"])
            usersArray.addObject(["title":"Mad River3","profile_picture":"venueImage3.jpg","subtitle":"Grant Boyle3"])
            usersArray.addObject(["title":"Stuart Jonald","profile_picture":"userImage4.jpg","subtitle":"1234567890"])
            usersArray.addObject(["title":"Mad River4","profile_picture":"venueImage4.jpg","subtitle":"Grant Boyle4"])
            usersArray.addObject(["title":"Steve Waugh","profile_picture":"userImage5.png","subtitle":"1234567890"])
            usersArray.addObject(["title":"Mad River5","profile_picture":"venueImage5.jpg","subtitle":"Grant Boyle5"])
            usersArray.addObject(["title":"Jimmy Walker","profile_picture":"userImage6.jpg","subtitle":"1234567890"])
            usersArray.addObject(["title":"Mad River6","profile_picture":"venueImage6.jpg","subtitle":"Grant Boyle6"])
            usersArray.addObject(["title":"Paul Smith","profile_picture":"userImage7.jpg","subtitle":"1234567890"])
            usersArray.addObject(["title":"Martin Samueals","profile_picture":"userImage8.jpg","subtitle":"1234567890"])
            usersArray.addObject(["title":"Mad River7","profile_picture":"venueImage7.jpg","subtitle":"Grant Boyle7"])
            usersArray.addObject(["title":"Ronny Hoggs","profile_picture":"userImage9.png","subtitle":"1234567890"])
            usersArray.addObject(["title":"Peter Hinns","profile_picture":"userImage10.jpg","subtitle":"1234567890"])
            usersArray.addObject(["title":"Mad River8","profile_picture":"venueImage8.jpg","subtitle":"Grant Boyle8"])
            reloadTable()
        }
        else
        {
            /*
            "id": 4,
            "user_id": "6",
            "first_name": "Megan",
            "last_name": "Rain",
            "image_url": "https://s3-us-west-2.amazonaws.com/mixrprofile/2016_02_13_07_04_6.jpg"
            
            Or
            
            "id": 29,
            "venue_id": "1",
            "name": "Harry's Bar"
            */
            let param: Dictionary = Dictionary<String, AnyObject>()
            let object = APIConnection().POST(APIName.Users.rawValue, withAPIName:"SearchUser", withMessage:"", withParam: param, withProgresshudShow: true, withHeader: false) as! APIConnection
            object.delegate = self
        }
    }
    
    func loadSearchData()
    {
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)
        
        var tokenString = "token "
        tokenString +=  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as! String
        
        
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(tokenString, forKey: "Authorization")
        let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as! String
        
        let parameters = [
            "query": self.searchBarObj.text!//.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
        ]
        let URL =  globalConstants.kAPIURL + globalConstants.kSearchAPIEndPoint
        
        //Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue("application/json", forKey: "Accept")
        
        
        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
            .responseString { response in
                
                appDelegate.stopAnimation()
                guard let value = response.result.value else
                {
                    print("Error: did not receive data")
                    return
                }
                
                guard response.result.error == nil else
                {
                    print("error calling POST on Login")
                    print(response.result.error)
                    return
                }
                
                
                let post = JSON(value)
                if let string = post.rawString() {
                    let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                    
                    if response.response?.statusCode == 400{
                        print("The Response Error is:   \(response.response?.statusCode)")
                        
                        if let val = responseDic?["code"] {
                            if val[0].isEqualToString("13") {
                                //                                print("Equals")
                                self.displayCommonAlert(responseDic?["detail"]?[0] as! String)
                                return
                            }
                            // now val is not nil and the Optional has been unwrapped, so use it
                        }
                        
                        if let errorData = responseDic?["detail"] {
                            
                            let errorMessage = errorData[0] as! String
                            self.displayCommonAlert(errorMessage)
                            return;
                        }
                    }
                    
                    if let value = response.result.value
                    {
                        let jsonResponse = JSON(value)
                        let responseDic: Dictionary <String, JSON> = jsonResponse.dictionaryValue
                        DLog("\(responseDic)")
                        return
                        if(self.feedcount == 0)
                        {
                            self.usersArray = (responseDic["data"]!.arrayObject as? NSMutableArray)!
                            self.feedcount = self.usersArray.count
                        }
                        else
                        {
                            if(self.usersArray.count > 0)
                            {
                                let newData : NSMutableArray = (responseDic["data"]!.arrayObject as? NSMutableArray)!
                                
                                for (var cnt = 0; cnt < newData.count ; cnt++)
                                {
                                    self.usersArray.addObject(newData[cnt])
                                }
                                
                                self.feedcount = self.usersArray.count
                            }
                        }
                        self.reloadTable()
                    }
                }
                
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
        if is_searching == true
        {
            return searchingArray.count
        }
        else
        {
            return usersArray.count  //Currently Giving default Value
        }
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SearchTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if is_searching == true
        {
            let feedDict : NSDictionary = searchingArray[indexPath.row] as! NSDictionary
            cell.imagePerson.image  = UIImage(named: feedDict["profile_picture"] as! String)
            cell.labelName.text = feedDict["title"] as! NSString as String
            cell.mobileNumber.text = feedDict["subtitle"] as! NSString as String
            //cell.textLabel!.text = searchingArray[indexPath.row] as! NSString as String
            if(indexPath.row == (searchingArray.count-4) && searchingArray.count > 8)
            {
                self.loadData()
            }
        }
        else
        {
            let feedDict : NSDictionary = usersArray[indexPath.row] as! NSDictionary
            cell.imagePerson.image  = UIImage(named: feedDict["profile_picture"] as! String)
            cell.labelName.text = feedDict["title"] as? String
            cell.mobileNumber.text = feedDict["subtitle"] as! NSString as String
            
            if(indexPath.row == (usersArray.count-4) && usersArray.count > 8)
            {
                self.loadData()
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("indexpath.row = \(indexPath.row)")
        
        //let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        //selectedCell.contentView.backgroundColor = UIColor.clearColor()
    }
    
    // if tableView is set in attribute inspector with selection to multiple Selection it should work.
    
    // Just set it back in deselect
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // let cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        //  cellToDeSelect.contentView.backgroundColor = UIColor.lightGrayColor()
    }
    
    //  MARK:- Searchbar Delegate -
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text!.isEmpty
        {
            is_searching = false
            tableView.reloadData()
        }
        else
        {
            print("search text %@ ",searchBar.text! as NSString)
            is_searching = true
            searchingArray.removeAllObjects()
            
            let temp = self.searchBarObj.text
            self.loadSearchData()
            
            return;
            print(self.usersArray)
            
            var tempArray : NSMutableArray = []
            
            let resultPredicate : NSPredicate = NSPredicate(format: "title contains[c] %@ || subtitle contains[c] %@",searchBar.text! as NSString,searchBar.text! as NSString)
            let searchResults = self.usersArray.filteredArrayUsingPredicate(resultPredicate)
            self.searchingArray = NSMutableArray(array: searchResults)
            
            print("seaarching array \(self.searchingArray)")
            
            tableView.reloadData()
        }
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
                
                if(feedcount == 0)
                {
                    self.usersArray = (result["data"]!.arrayObject as? NSMutableArray)!
                    feedcount = self.usersArray.count
                }
                else
                {
                    if(self.usersArray.count > 0)
                    {
                        let newData : NSMutableArray = (result["data"]!.arrayObject as? NSMutableArray)!
                        
                        for (var cnt = 0; cnt < newData.count ; cnt++)
                        {
                            self.usersArray.addObject(newData[cnt])
                        }
                        
                        feedcount = self.usersArray.count
                    }
                }
                reloadTable()
            }
            
            DLog("Search")
            
        default:
            DLog("Nothing")
        }
    }
    
    func connectionDidUpdateAPIProgress(action: Int,bytesWritten: Int64, totalBytesWritten: Int64 ,totalBytesExpectedToWrite: Int64)
    {
        
    }
}
