//
//  FollowersViewController.Swift
//  MIXR
//
//  Created by Sujal Bandhara on 30/16/16.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class FollowersViewController: BaseViewController, UITableViewDelegate,UITableViewDataSource {
    
    //var usersArray : Array<JSON> = []
    var usersArray : NSMutableArray = NSMutableArray()
    
    let isLocalData = true
    
    var is_searching:Bool!
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var refreshControl : UIRefreshControl = UIRefreshControl()
    //  MARK:- Tableview delegate -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //self.navigationController?.interactivePopGestureRecognizer!.delegate =  self
        //self.navigationController?.interactivePopGestureRecognizer!.enabled = true
        
        is_searching = false
        self.tableView.separatorColor = UIColor .clearColor()
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
        self.pullToReferesh()
        self.dismissKeyboard()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.loadData()
    }
    
    func pullToReferesh()
    {
        self.refreshControl.attributedTitle = NSAttributedString(string: "")//Updating
        self.refreshControl.addTarget(self, action: #selector(FollowersViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    
    func refresh(sender:AnyObject)
    {
        self.loadData()
        // Code to refresh table view
        self.performSelector(#selector(FollowersViewController.endReferesh), withObject: nil, afterDelay: 1.0)
    }
    
    func endReferesh()
    {
        //End refresh control
        self.refreshControl.endRefreshing()
        //Remove refresh control to superview
        //self.refreshControl?.removeFromSuperview()
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
        loadFollowingData()
    }
    
    func loadFollowingData() {
        self.usersArray.removeAllObjects()
        
        APIManager.sharedInstance.getFollowing({ [weak self] (response) in
            guard let `self` = self else { return }
            let searchArray = NSMutableArray(array: response.arrayObject ?? [])
            self.usersArray = self.createDisplayArray(searchArray)
            self.reloadTable()
        }, failure: nil)
    }
    
    func createDisplayArray(inputArray :NSMutableArray)->NSMutableArray
    {
        let newData : NSMutableArray = []
        
        for cnt in 0  ..< inputArray.count
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
                        outPutDict.setValue("\(first_nameStr) \(inputDict["last_name"] as! String)", forKey: "userName")
                    }
                    
                    if let image_url_Str = inputDict["image_url"] as? String
                    {
                        outPutDict.setValue(image_url_Str, forKey: "userImage")
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
        return usersArray.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FollowingCell", forIndexPath: indexPath) as! FollowingCell
        //cell.selectionStyle = UITableViewCellSelectionStyle.None
        let feedDict : NSDictionary = usersArray[indexPath.row] as! NSDictionary
        //cell.imagePerson.image  = UIImage(named: feedDict["userImage"] as! String)
        cell.labelName.text = feedDict["userName"] as? String
        
        if let imageNameStr = feedDict["image_url"] as? String
        {
            if (imageNameStr.characters.count > 0)
            {
                //cell.imagePerson.image  = aImage
                let URL = NSURL(string: imageNameStr)!
                //let URL = NSURL(string: "https://avatars1.githubusercontent.com/u/1846768?v=3&s=460")!
                
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
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if (self.usersArray.count > indexPath.row)
        {
            let feedDict : NSDictionary = self.usersArray[indexPath.row] as! NSDictionary
            
            if let venue_idStr = feedDict["venue_id"] as? Int
            {
                // Venu Id
                NSLog("venue_idStr = \(venue_idStr)")
                let aVenueProfileViewController : VenueProfileViewController = self.storyboard!.instantiateViewControllerWithIdentifier("VenueProfileViewController") as! VenueProfileViewController
                assert(false)
                // TODO: fix selected venue id
                AppPersistedStore.sharedInstance.selectedVenueId = "\(venue_idStr)"
                self.navigationController!.pushViewController(aVenueProfileViewController, animated: true)
            }
            else
            {
                // User Id
                if let user_idStr = feedDict["user_id"] as? Int
                {
                    NSLog("user_idStr = \(user_idStr)")
                    let postViewController : PostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PostViewController") as! PostViewController
                    postViewController.isUserProfile = false
                    postViewController.userId = "\(user_idStr)"
                    self.navigationController!.pushViewController(postViewController, animated: true)
                }
            }
        }
        else
        {
            reloadTable()
        }
        //        print("indexpath.row = \(indexPath.row)")
        //        let postViewController : PostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PostViewController") as! PostViewController
        //        postViewController.isUserProfile = true
        //        self.navigationController!.pushViewController(postViewController, animated: true)
        
    }
}
