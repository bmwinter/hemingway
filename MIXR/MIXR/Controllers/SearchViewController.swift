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
import AlamofireImage

import SpringIndicator

class SearchViewController: BaseViewController, SpringIndicatorTrait {
    
    var refreshControl:UIRefreshControl!
    var usersArray = NSMutableArray()
    
    @IBOutlet weak var lblNoResultFound: UILabel!
    var searchingArray:NSMutableArray!
    let isLocalData = true
    @IBOutlet var searchBarObj: UISearchBar!
    
    var is_searching:Bool!
    
    var query: String {
        switch searchBarObj.text {
        case .Some(let value):
            return value.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        case .None:
            return ""
        }
    }
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var feedcount : Int = 0
    
    var springIndicator: SpringIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        is_searching = false
        self.tableView.separatorColor = UIColor .clearColor()
        self.loadData()
        
        searchBarObj.delegate = self
        searchingArray = []
        searchBarObj.layer.cornerRadius = 10.0
    }
    
    func pullToReferesh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "")//Updating
        self.refreshControl!.addTarget(self, action: #selector(SearchViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
    }
    
    func refresh(sender:AnyObject) {
        feedcount = 0
        self.loadData()
        // Code to refresh table view
        self.performSelector(#selector(SearchViewController.endReferesh), withObject: nil, afterDelay: 1.0)
    }
    
    func endReferesh() {
        //End refresh control
        self.refreshControl?.endRefreshing()
        //Remove refresh control to superview
        //self.refreshControl?.removeFromSuperview()
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
    
    func loadSearchData() {
        startAnimatingSpringIndicator()
        
        var tokenString = "token "
        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
            
            APIManager.sharedInstance.search(withQuery: query,
                                             success: { (jsonResponse) in
                                                let tempArray = NSMutableArray(array: jsonResponse.arrayObject ?? [])
                                                self.usersArray = NSMutableArray(array: self.createDisplayArray(tempArray))
                                                self.feedcount = self.usersArray.count
                                                self.searchingArray = self.usersArray
                }, failure: { (error) in
                    
            })
        }
    }
    
    func createDisplayArray(inputArray: NSMutableArray) -> [AnyObject]
    {
        var newData = [AnyObject]()
        
        //for (cnt,inputDict) in inputArray.enumerate()
        for inputDict in inputArray
        //for (var cnt = 0 ; cnt < inputArray.count; cnt++ )
        {
            //if let inputDict = inputArray[cnt] as? NSDictionary
            //{
                let outPutDict :NSMutableDictionary = NSMutableDictionary(dictionary: inputDict as! [NSObject : AnyObject])
                
                if let _ = inputDict["venue_id"] as? String
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
                newData.append(outPutDict)
            //}
        }
        // TODO: move this to the server side
        return newData.filter({ (elem) -> Bool in
            if let dict = elem as? NSDictionary, let _ = dict["venue_id"] {
                return true
            }
            return false
        })
    }
    
    func reloadTable()
    {
        tableView.reloadData()
    }
    
    // if tableView is set in attribute inspector with selection to multiple Selection it should work.
    
    // Just set it back in deselect
    
    //  MARK:- Searchbar Delegate -
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.searchingArray.removeAllObjects()
        self.usersArray.removeAllObjects()
        
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
            //let temp = self.searchBarObj.text
            self.loadSearchData()
            
            return;
            /*
            print(self.usersArray)
            
            var tempArray : NSMutableArray = []
            
            let resultPredicate : NSPredicate = NSPredicate(format: "title contains[c] %@ || subtitle contains[c] %@",searchBar.text! as NSString,searchBar.text! as NSString)
            let searchResults = self.usersArray.filteredArrayUsingPredicate(resultPredicate)
            self.searchingArray = NSMutableArray(array: searchResults)
            
            print("seaarching array \(self.searchingArray)")
            
            tableView.reloadData()
             */
        }
    }
}
extension SearchViewController: UITableViewDataSource {
    //  MARK:- Tableview delegate -
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int
    {
        if (self.usersArray.count > 0)
        {
            self.lblNoResultFound.hidden = true
        }
        else
        {
            self.lblNoResultFound.hidden = false
        }
        return self.usersArray.count  //Currently Giving default Value
        
        //        if is_searching == true
        //        {
        //            return searchingArray.count
        //        }
        //        else
        //        {
        //            if (self.usersArray.count > 0)
        //            {
        //                self.lblNoResultFound.hidden = true
        //            }
        //            else
        //            {
        //                self.lblNoResultFound.hidden = false
        //            }
        //            return self.usersArray.count  //Currently Giving default Value
        //        }
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SearchTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        //        if is_searching == true
        //        {
        //            let feedDict : NSDictionary = searchingArray[indexPath.row] as! NSDictionary
        //            cell.imagePerson.image  = UIImage(named: feedDict["profile_picture"] as! String)
        //            cell.labelName.text = feedDict["title"] as! NSString as String
        //            cell.mobileNumber.text = feedDict["subtitle"] as! NSString as String
        //            //cell.textLabel!.text = searchingArray[indexPath.row] as! NSString as String
        //            if(indexPath.row == (searchingArray.count-4) && searchingArray.count > 8)
        //            {
        //                self.loadData()
        //            }
        //        }
        //        else
        //        {
        let feedDict : NSDictionary = self.usersArray[indexPath.row] as! NSDictionary
        
        if let imageNameStr = feedDict["image_url"] as? String
        {
            if (imageNameStr.characters.count > 0)
            {
                //cell.imagePerson.image  = aImage
                let URL = NSURL(string: imageNameStr)!
                //let URL = NSURL(string: "https://avatars1.githubusercontent.com/u/1846768?v=3&s=460")!
                
                Request.addAcceptableImageContentTypes(["binary/octet-stream"])
                let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                    size: cell.imagePerson.frame.size,
                    radius: 0.0
                )
                cell.imagePerson.af_setImageWithURL(URL, placeholderImage: UIImage(named: "ALPlaceholder"), filter: filter, imageTransition: .None, completion: { (response) -> Void in
                    print("image: \(cell.imagePerson.image)")
                    print(response.result.value) //# UIImage
                    print(response.result.error) //# NSError
                })
                
                //let placeholderImage = UIImage(named: "ALPlaceholder")!
                //cell.imagePerson.af_setImageWithURL(URL, placeholderImage: placeholderImage)
                
            }
            else
            {
                cell.imagePerson.image = UIImage(named:"ALPlaceholder")
            }
        }
        else
        {
            cell.imagePerson.image = UIImage(named:"ALPlaceholder")
        }
        
        cell.labelName.text = feedDict["title"] as? String
        cell.mobileNumber.text = feedDict["subtitle"] as! NSString as String
        
        if(indexPath.row == (self.usersArray.count-4) && self.usersArray.count > 8)
        {
            self.loadData()
        }
        //}
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // let cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        //  cellToDeSelect.contentView.backgroundColor = UIColor.lightGrayColor()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("indexpath.row = \(indexPath.row)")
        
        if (self.usersArray.count > indexPath.row)
        {
            let feedDict : NSDictionary = self.usersArray[indexPath.row] as! NSDictionary
            
            if let venue_idStr = feedDict["venue_id"] as? String
            {
                // Venu Id
                NSLog("venue_idStr = \(venue_idStr)")
                let aVenueProfileViewController : VenueProfileViewController = self.storyboard!.instantiateViewControllerWithIdentifier("VenueProfileViewController") as! VenueProfileViewController
                AppPersistedStore.sharedInstance.selectedVenueId = venue_idStr
                self.navigationController!.pushViewController(aVenueProfileViewController, animated: true)
            }
            else
            {
                // User Id
                if let user_idStr = feedDict["user_id"] as? String
                {
                    NSLog("user_idStr = \(user_idStr)")
                    let postViewController : PostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PostViewController") as! PostViewController
                    postViewController.isUserProfile = false
                    postViewController.userId = user_idStr
                    self.navigationController!.pushViewController(postViewController, animated: true)
                }
            }
        }
        else
        {
            reloadTable()
        }
        //let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        //selectedCell.contentView.backgroundColor = UIColor.clearColor()
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        for subview: UIView in ((searchBar.subviews[0] )).subviews {
            
            if let btn = subview as? UIButton {
                btn.setTitleColor(UIColor.mixrLightGray(), forState: .Normal)
            }
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
