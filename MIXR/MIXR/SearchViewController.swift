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

class SearchViewController: BaseViewController, UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
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
        
    }
    
    func loadSearchData()
    {
        self.usersArray.removeAllObjects()
        self.searchingArray .removeAllObjects()
        
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)
        
        var tokenString = "token "
        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
            
            Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue(tokenString, forKey: "authorization")
            
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
                        self.reloadTable()
                        
                        return
                    }
                    
                    guard response.result.error == nil else
                    {
                        print("error calling POST on Login")
                        print(response.result.error)
                        self.reloadTable()
                        
                        return
                    }
                    
                    
                    let post = JSON(value)
                    if let string = post.rawString()
                    {
                        if response.response?.statusCode == 400
                        {
                            let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                            print("The Response Error is:   \(response.response?.statusCode)")
                            
                            if let val = responseDic?["code"]
                            {
                                if val[0].isEqualToString("13")
                                {
                                    //print("Equals")
                                    self.displayCommonAlert(responseDic?["detail"]?[0] as! String)
                                    self.reloadTable()
                                    
                                    return
                                }
                                // now val is not nil and the Optional has been unwrapped, so use it
                            }
                            
                            if let errorData = responseDic?["detail"]
                            {
                                let errorMessage = errorData[0] as! String
                                self.displayCommonAlert(errorMessage)
                                self.reloadTable()
                                
                                return;
                            }
                        }
                        else if (response.response?.statusCode == 200 || response.response?.statusCode == 201)
                        {
                            let responseArray:NSArray? = self.convertStringToArray(string)
                            if let searchArray = responseArray as? NSMutableArray
                            {
                                //    if(self.feedcount == 0)
                                //    {
                                //        self.usersArray = self.createDisplayArray(searchArray)
                                //        self.feedcount = self.usersArray.count
                                //    }
                                //    else
                                //    {
                                //        if(self.usersArray.count > 0)
                                //        {
                                //            let newData : NSMutableArray = self.createDisplayArray(searchArray)
                                //            
                                //            for (var cnt = 0; cnt < newData.count ; cnt++)
                                //            {
                                //                self.usersArray.addObject(newData[cnt])
                                //            }
                                //            
                                //            self.feedcount = self.usersArray.count
                                //        }
                                //    }
                                
                                self.usersArray = self.createDisplayArray(searchArray)
                                self.feedcount = self.usersArray.count
                                self.searchingArray = self.usersArray
                                
                            }
                        }
                        
                        self.reloadTable()
                    }
            }
        }
    }
    
    func createDisplayArray(inputArray :NSMutableArray)->NSMutableArray
    {
        let newData : NSMutableArray = []
        
        for (var cnt = 0 ; cnt < inputArray.count; cnt++ )
        {
            if let inputDict = inputArray[cnt] as? NSDictionary
            {
                let outPutDict :NSMutableDictionary = NSMutableDictionary(dictionary: inputDict)
                
                if let venue_idStr = inputDict["venue_id"] as? String
                {
                    outPutDict.setValue("\(inputDict["name"] as! String)", forKey: "title")
                    outPutDict.setValue("", forKey: "profile_picture")
                    outPutDict.setValue("", forKey: "subtitle")
                }
                else
                {
                    if let first_nameStr = inputDict["first_name"] as? String
                    {
                        outPutDict.setValue("\(first_nameStr) \(inputDict["last_name"] as! String)", forKey: "title")
                    }
                    
                    if let image_url_Str = inputDict["image_url"] as? String
                    {
                        outPutDict.setValue(image_url_Str, forKey: "profile_picture")
                    }
                }
                
                outPutDict.setValue("", forKey: "subtitle")
                newData.addObject(outPutDict)
            }
        }
        return newData
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
            
            if let imageNameStr = feedDict["profile_picture"] as? String
            {
                if (imageNameStr.characters.count > 0)
                {
                    if let aImage = UIImage(named: imageNameStr)
                    {
                        cell.imagePerson.image  = aImage
                        // let URL = NSURL(string: imageStr)!
                        // let placeholderImage = UIImage(named: "placeholder.png")!
                        // cell.imagePerson.af_setImageWithURL(URL, placeholderImage: placeholderImage)
                    }
                    else
                    {
                        cell.imagePerson.image = UIImage(named:"placeholder.png")
                    }
                }
                else
                {
                    cell.imagePerson.image = UIImage(named:"placeholder.png")
                }
            }
            else
            {
                cell.imagePerson.image = UIImage(named:"placeholder.png")
            }
            
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
        searchingArray.removeAllObjects()
        usersArray.removeAllObjects()
        
        if searchBar.text!.isEmpty
        {
            is_searching = true
            tableView.reloadData()
        }
        else
        {
            print("search text %@ ",searchBar.text! as NSString)
            is_searching = false
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
}
