//
//  VenueProfileTableViewController.swift
//  MIXR
//
//  Created by Nilesh Patel on 22/10/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyJSON
import Alamofire
import AlamofireImage

class VenueProfileTableViewController: UITableViewController,UIGestureRecognizerDelegate {
    
    var feedsArray : Array<JSON> = []
    var venueSpecialArray : NSArray = []
    var venueEventArray : NSArray = []
    var feedcount : Int = 0
    var venueDict : NSDictionary = NSDictionary()
    
    @IBOutlet weak var venuePicture: UIImageView!
    @IBOutlet weak var noofFillsImage: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnVenueName: UIButton!
    @IBOutlet weak var barTiming: UILabel!
    @IBOutlet weak var venueAddress: UILabel!
    @IBOutlet weak var venueSpecial: UILabel!
    @IBOutlet weak var eventsAtVenue: UILabel!
    @IBOutlet weak var eventsScrollView: UIScrollView!
    @IBOutlet weak var venueSpecialScrollView: UIScrollView!
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var showLatestVideos: UIBarButtonItem!
    @IBOutlet weak var bottomView: UIView!
    
    var venuId: String! = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.navigationController?.interactivePopGestureRecognizer!.delegate =  self
        //self.navigationController?.interactivePopGestureRecognizer!.enabled = true
        self.title = "Spanky's"
        self.navigationItem.rightBarButtonItem = showLatestVideos;
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
        // Do any additional setup after loading the view, typically from a nib.
        //self.pullToReferesh()
        self.btnVenueName.titleLabel?.font = UIFont(name: "ForgottenFuturistRg-Bold", size: 24)
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true

        loadData()
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        //self.navigationController?.navigationBarHidden = false
    }
    
    func pullToReferesh()
    {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "")
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
    }
    
    func refresh(sender:AnyObject)
    {
        feedcount = 0
        self.loadFeedData()
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
    
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    func loadDummyScrollViewData()
    {
        //self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        //self.tableView.estimatedSectionHeaderHeight = self.outerView.frame.size.height
        
        if(self.venueDict.allKeys.count > 0)
        {
            if let venueName = self.venueDict["name"]! as? String
            {
                self.btnVenueName.setTitle(venueName, forState: UIControlState.Normal)
            }
            
            if let operating_hours = self.venueDict["operating_hours"]! as? String
            {
                self.barTiming.text = operating_hours
            }
            
            if let locationDict = self.venueDict["location"]! as? NSDictionary
            {
                print("The location is: \(self.venueDict["location"]!)")
                self.venueAddress.text = "\(locationDict["address"]!) \(locationDict["city"]!) \(locationDict["state"]!) \(locationDict["zipcode"]!)"
            }
        }

        loadFeedData()
        var eventHeight : CGFloat = 10
        for (var i = 0 ; i < self.venueEventArray.count ; i++ )
        {
            var eventDetail = " This Tuesday and Thursday be sure to stop by since we are offering a buy 2-get-1-free deal."
            let venueEventResponseDic:[String:AnyObject]? = self.venueEventArray[i] as? [String : AnyObject]
            print("The venueEventResponseDic   \(venueEventResponseDic)")
            
            if let eventDict = venueEventResponseDic!["event"] as? NSDictionary
            {
                if let description = eventDict["description"] as? String
                {
                    eventDetail = " \(description)"
                }
            }
            /*
            [
                {
                    "event": 
                    {
                        "description": "Stop by for the race track beer keg stand!",
                        "venue_id": "1"
                    }
                },
                {
                    "event": 
                    {
                        "description": "Stop by for the race track beer keg stand!",
                        "venue_id": "1"
                    }
                }
            ]
            */
            let test:UILabel
            test = UILabel(frame: CGRectMake(0, eventHeight, self.eventsScrollView.frame.size.width, CGFloat.max))
            test.numberOfLines = 0
            test.textAlignment = NSTextAlignmentFromCTTextAlignment(CTTextAlignment.Left)
            test.backgroundColor = UIColor.clearColor()
            //test.text = "This Tuesday and Thursday be sure to stop by since we are offering a buy 2-get-1-free deal."
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "greenBullat.png")
            let attachmentString = NSAttributedString(attachment: attachment)
            let myString = NSMutableAttributedString(string: "")
            myString.appendAttributedString(attachmentString)
            myString.appendAttributedString(NSMutableAttributedString(string:eventDetail ))
            test.attributedText = myString
            
            test.font = UIFont(name: "ForgottenFuturistRg-Regular", size: 20)
            test.sizeToFit()
            let height = heightForView(test.text!, font: test.font!, width: self.eventsScrollView.frame.size.width-20)
            test.frame = CGRectMake(10, (CGFloat)(eventHeight), self.eventsScrollView.frame.size.width-20, height)
            
            eventHeight = eventHeight + height + 5.0
            self.eventsScrollView.addSubview(test)
        }
        
        self.eventsScrollView.layer.borderColor = UIColor(red: (214.0/255.0), green: (214.0/255.0), blue: (214.0/255.0), alpha: 1).CGColor
        self.eventsScrollView.layer.borderWidth = 2.0
        self.eventsScrollView.backgroundColor = UIColor.clearColor()
        
        var SpecialHeight : CGFloat = 10.0
        
        for (var i = 0 ; i < self.venueSpecialArray.count ; i++ )
        {
            let venueSpecialResponseDic:[String:AnyObject]? = self.venueSpecialArray[i] as? [String : AnyObject]
            var specialDetail = " This Sunday and MOnday be sure to stop by since we are offering a buy 2-get-1-free deal."
            print("The  venueSpecialResponseDic   \(venueSpecialResponseDic)")
            if let specialDict = venueSpecialResponseDic!["special"] as? NSDictionary
            {
                if let description = specialDict["description"] as? String
                {
                    specialDetail = " \(description)"
                }
            }
            /*
            [
                {
                    "special": 
                    {
                        "description": "Free Baileys if you purchase shot of expresso.",
                        "venue_id": "1"
                    }
                },
                {
                    "special": 
                    {
                        "description": "Free Baileys if you purchase shot of expresso.",
                        "venue_id": "1"
                    }
                }
            ]
            */
            let test:UILabel
            test = UILabel(frame: CGRectMake(10, SpecialHeight, self.venueSpecialScrollView.frame.size.width-20, CGFloat.max))
            test.numberOfLines = 0
            test.textAlignment = NSTextAlignmentFromCTTextAlignment(CTTextAlignment.Left)
            test.backgroundColor = UIColor.clearColor()
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "greenBullat.png")
            let attachmentString = NSAttributedString(attachment: attachment)
            let myString = NSMutableAttributedString(string: "")
            myString.appendAttributedString(attachmentString)
            myString.appendAttributedString(NSMutableAttributedString(string: specialDetail))
            test.attributedText = myString
            
            //test.text = "This Sunday and MOnday be sure to stop by since we are offering a buy 2-get-1-free deal."
            test.font = UIFont(name: "ForgottenFuturistRg-Regular", size: 20)
            test.sizeToFit()
            let height = heightForView(test.text!, font: test.font!, width: self.venueSpecialScrollView.frame.size.width-20)
            test.frame = CGRectMake(10, (CGFloat)(SpecialHeight), self.venueSpecialScrollView.frame.size.width-20, height)
            
            SpecialHeight = SpecialHeight + height + 5.0
            self.venueSpecialScrollView.addSubview(test)
        }
        
        // for i in 1...5
        // {
        //     let test:UILabel
        //     test = UILabel()
        //
        //     test.frame = CGRectMake(0, (CGFloat)(eventHeight), self.eventsScrollView.frame.size.width, CGFloat.max);
        //
        //     test.textAlignment = NSTextAlignmentFromCTTextAlignment(CTTextAlignment.Center)
        //     test.text = "Special Deal \(i)"
        //     test.font = UIFont(name: "ForgottenFuturistRg-Regular", size: 20)
        //
        //     test.numberOfLines = 0
        //     test.lineBreakMode = NSLineBreakMode.ByWordWrapping
        //
        //     test.sizeToFit()
        //
        //     SpecialHeight = SpecialHeight + test.frame.height
        //     self.venueSpecialScrollView.addSubview(test)
        // }
        
        var bottomViewFrame = self.bottomView.frame
        bottomViewFrame.size.height = (eventHeight > SpecialHeight) ? eventHeight: SpecialHeight
        self.bottomView.frame = bottomViewFrame
        var outerViewFrame = self.outerView.frame
        outerViewFrame.size.height = self.bottomView.frame.origin.y + self.bottomView.frame.size.height + 20.0
        self.outerView.frame = outerViewFrame
        self.bottomView.backgroundColor = UIColor.clearColor()
        self.outerView.backgroundColor = UIColor.clearColor()
        self.venueSpecialScrollView.contentSize = CGSizeMake( self.eventsScrollView.frame.size.width, self.bottomView.frame.size.height)
        self.venueSpecialScrollView.scrollEnabled = false
        self.eventsScrollView.contentSize = CGSizeMake( self.eventsScrollView.frame.size.width, self.bottomView.frame.size.height)
        self.eventsScrollView.scrollEnabled = false
        self.venueSpecialScrollView.layer.borderColor = UIColor(red: (214.0/255.0), green: (214.0/255.0), blue: (214.0/255.0), alpha: 1).CGColor
        self.venueSpecialScrollView.layer.borderWidth = 2.0
        self.noofFillsImage.layer.borderColor = UIColor(red: (214.0/255.0), green: (214.0/255.0), blue: (214.0/255.0), alpha: 1).CGColor
        self.noofFillsImage.layer.borderWidth = 2.0
        //self.btnVenueName.setTitle("Mad River", forState: .Normal)
        
        if(self.outerView.frame.size.height > 295)
        {
            self.tableView.estimatedSectionHeaderHeight = self.outerView.frame.size.height - 295
        }
        else
        {
            self.tableView.estimatedSectionHeaderHeight = 0.0
        }
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        reloadTable()
    }
    
    /*
    // getProfileData used to Call Profile API & retrieve the user's profile data
    */
    
    func getVenueProfileData(){
        let parameters = [
            "userID": "1"
        ]
        
        let URL =  globalConstants.kAPIURL + globalConstants.kVenueDetailsAPIEndPoint
        
        Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                guard let value = response.result.value else {
                    print("Error: did not receive data")
                    return
                }
                
                guard response.result.error == nil else {
                    print("error calling POST")
                    print(response.result.error)
                    return
                }
                let post = JSON(value)
                print("The post is: " + post.description)
        }
    }
    
    
    /*
    // Table View delegate methods
    */
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return 0
    //    }
    
    /*
    // IBAction methods
    */
    
    /*
    // Following button method
    */
    
    
    @IBAction func likeBtnClicked(sender: AnyObject)
    {
        let btn : UIButton = (sender as? UIButton)!
        btn.selected = !btn.selected
        if(btn.selected)
        {
            self.btnLike.backgroundColor = UIColor(red: 96/255,green: 134/255.0,blue: 72/255,alpha: 1.0)
        }
        else
        {
            self.btnLike.backgroundColor = UIColor(red: 194/255,green: 194/255.0,blue: 194/255,alpha: 1.0)
        }
    }
    
    func loadFeedData()
    {
        if (!isLocalData)
        {
            feedsArray = [["venueName":"Mad River1","venueImage":"venueImage1.jpg","userName":"Grant Boyle1"],
                ["venueName":"Mad River2","venueImage":"venueImage2.jpg","userName":"Grant Boyle2"],
                ["venueName":"Mad River3","venueImage":"venueImage3.jpg","userName":"Grant Boyle3"],
                ["venueName":"Mad River4","venueImage":"venueImage4.jpg","userName":"Grant Boyle4"],
                ["venueName":"Mad River5","venueImage":"venueImage5.jpg","userName":"Grant Boyle5"],
                ["venueName":"Mad River6","venueImage":"venueImage6.jpg","userName":"Grant Boyle6"],
                ["venueName":"Mad River7","venueImage":"venueImage7.jpg","userName":"Grant Boyle7"],
                ["venueName":"Mad River8","venueImage":"venueImage8.jpg","userName":"Grant Boyle8"],
                ["venueName":"Mad River9","venueImage":"venueImage9.jpg","userName":"Grant Boyle9"],
                ["venueName":"Mad River10","venueImage":"venueImage10.jpg","userName":"Grant Boyle10"]]
            reloadTable()
            
        }
//        else
//        {
//            let param: Dictionary = Dictionary<String, AnyObject>()
//            //call API for to get venues
//            let object = APIConnection().POST(APIName.Venues.rawValue, withAPIName: "VenueList", withMessage: "", withParam: param, withProgresshudShow: true, withHeader: false) as! APIConnection
//            object.delegate = self
//            
//        }
    }
    
    func reloadTable()
    {
        self.tableView.reloadData()
    }
    
    @IBAction func onUserBtnClicked(sender: AnyObject)
    {
        // let postViewController : ProfileTableViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ProfileTableViewController") as! ProfileTableViewController
        // //postViewController.venueDict = venueDict
        // self.navigationController!.pushViewController(postViewController, animated: true)
        // return
        
        let feedBtn : UIButton = sender as! UIButton
        let feedTag = feedBtn.superview!.tag
        NSLog("feedTag = \(feedTag)")
        //let venueDict : NSDictionary = feedsArray[feedTag].dictionaryObject!
        let postViewController : PostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PostViewController") as! PostViewController
        postViewController.isUserProfile = false
        self.navigationController!.pushViewController(postViewController, animated: true)
    }
    
    @IBAction func onFeedClicked(sender: AnyObject)
    {
        let aVenueProfileViewController : VenueProfileViewController = self.storyboard!.instantiateViewControllerWithIdentifier("VenueProfileViewController") as! VenueProfileViewController
        self.navigationController!.pushViewController(aVenueProfileViewController, animated: true)
        
        return
    }
    // MARK: - Table view data source
    
    //    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 1
    //    }
    //    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if(section == 0)
        {
            outerView.backgroundColor = UIColor.clearColor()
            return self.outerView
        }
        else
        {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if(section == 0)
        {
            return self.outerView.frame.size.height
        }
        else
        {
            return 0
        }
    }
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        return feedsArray.count;
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as! UserFeedCell
        
        cell.contentView.frame = cell.bounds;
        
        //        var cellFrame : CGRect = cell.frame
        //        cellFrame.origin.y = 0
        //        cell.frame = cellFrame
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        //let venueDict : Dictionary <String, JSON> = feedsArray[indexPath.row]
        cell.contentView.tag = indexPath.row
        
        cell.venuImageView.image = UIImage(named: feedsArray[indexPath.row]["venueImage"].string!)
        cell.FeedName.text = feedsArray[indexPath.row]["venueName"].string
        cell.lblUserName.text = feedsArray[indexPath.row]["userName"].string
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "martiniglass_icon.png")
        let attachmentString = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: " ")
        myString.appendAttributedString(attachmentString)
        myString.appendAttributedString(NSMutableAttributedString(string: " 250"))
        cell.lblLike.attributedText = myString
        
        if((indexPath.row == (feedsArray.count-2)) && feedsArray.count > 8)
        {
            self.loadFeedData()
        }
        /*
        cell.venuImageView.image = UIImage(named: venueDict["venueImage"] as! String)
        cell.FeedName.text = venueDict["venueName"] as? String
        cell.lblUserName.text = venueDict["userName"] as? String
        */
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("indexpath.row = \(indexPath.row)")
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        var headerFrame = self.outerView.frame
        if (scrollOffset < 0) {
            // Adjust map
            headerFrame = CGRect(x: self.outerView.frame.origin.x,
                y: self.outerView.frame.origin.y,
                width: self.outerView.frame.size.width,
                height: self.outerView.frame.size.height)
        } else {
            // Adjust map
            headerFrame = CGRect(x: self.outerView.frame.origin.x,
                y: self.outerView.frame.origin.y,
                width: self.outerView.frame.size.width,
                height: self.outerView.frame.size.height)
        }
        self.outerView.frame = headerFrame
        if (self.outerView.superview == nil)
        {
            self.tableView.addSubview(self.outerView)
        }
    }
 
    func loadData()
    {
        if (appDelegate.selectedVenueId.count == 0)
        {
            self.venuId = "1"
        }
        else
        {
            self.venuId = appDelegate.selectedVenueId
        }
        
        self.venueSpecialArray = []
        self.loadVenueSpecialData()

        self.venueEventArray = []
        self.loadVenueEventData()
        
        self.venueDict = NSDictionary()
        self.loadVenueData()
    }
    
    func loadVenueData()
    {
        
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)
        
        var tokenString = "token "
        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
            
            let URL =  globalConstants.kAPIURL + globalConstants.kProfileVenue
            
            
            let headers = [
                "Authorization": tokenString,
            ]
            
            let parameters = [
                "venue_id": self.venuId//.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            ]
            Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON, headers : headers)
                .responseString { response in
                    
                    print("response \(response)")
                    appDelegate.stopAnimation()
                    guard let value = response.result.value else
                    {
                        print("Error: did not receive data")
                        self.loadDummyScrollViewData()
                        
                        return
                    }
                    
                    guard response.result.error == nil else
                    {
                        print("error calling POST on Login")
                        print(response.result.error)
                        self.loadDummyScrollViewData()
                        
                        return
                    }
                    
                    let post = JSON(value)
                    if let string = post.rawString()
                    {
                        if (response.response?.statusCode == 400 || response.response?.statusCode == 401)
                        {
                            let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                            print("The Response Error is:   \(response.response?.statusCode)")
                            
                            if let val = responseDic?["code"]
                            {
                                if val[0].isEqualToString("13")
                                {
                                    //print("Equals")
                                    self.displayCommonAlert(responseDic?["detail"]?[0] as! String)
                                    self.loadDummyScrollViewData()
                                    
                                    return
                                }
                                // now val is not nil and the Optional has been unwrapped, so use it
                            }
                            
                            if let errorData = responseDic?["detail"]
                            {
                                
                                if let errorMessage = errorData as? String
                                {
                                    self.displayCommonAlert(errorMessage)
                                    
                                }
                                else if let errorMessage = errorData as? NSArray
                                {
                                    if let errorMessageStr = errorMessage[0] as? String
                                    {
                                        self.displayCommonAlert(errorMessageStr)
                                    }
                                }
                                self.loadDummyScrollViewData()
                                return;
                            }
                            
                        }
                        else if (response.response?.statusCode == 200 || response.response?.statusCode == 201)
                        {
                            let responseArray : NSArray =  self.convertStringToArray(string)!
                            let responseDic:[String:AnyObject]? = responseArray[0] as? [String : AnyObject]
                            self.venueDict = responseDic!
                            print("The  responseDic is:   \(self.venueDict)")
                            print("The  id is:   \(self.venueDict["id"]!)")
                            print("The  name is:   \(self.venueDict["name"]!)")
                            print("The  location is:   \(self.venueDict["location"]!)")
                            print("The  operating_hours is:   \(self.venueDict["operating_hours"]!)")
                            /*
                            {
                                "id": "1",
                                "name": "Harry's Bar",
                                "operating_hours": "5pm-3am",
                                "location": 
                                    {
                                        "address": "169 Grandview Road",
                                        "city": "Springfield",
                                        "state": "Pennsylvania",
                                        "zipcode": "19064",
                                        "longitude": "-75.337555",
                                        "latitude": "39.9392799"
                                    }
                                }
                            */
                            
                        }
                        else
                        {
                            
                        }
                        
                        self.loadDummyScrollViewData()
                    }
            }
        }
    }
    
    func loadVenueSpecialData()
    {
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)
        
        var tokenString = "token "
        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
            
            let URL =  globalConstants.kAPIURL + globalConstants.kProfileVenueSpecial
            
            
            let headers = [
                "Authorization": tokenString,
            ]
            
            let parameters = [
                "venue_id": self.venuId//.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            ]
            Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON, headers : headers)
                .responseString { response in
                    
                    print("response \(response)")
                    appDelegate.stopAnimation()
                    guard let value = response.result.value else
                    {
                        print("Error: did not receive data")
                        self.loadDummyScrollViewData()
                        
                        return
                    }
                    
                    guard response.result.error == nil else
                    {
                        print("error calling POST on Login")
                        print(response.result.error)
                        self.loadDummyScrollViewData()
                        
                        return
                    }
                    
                    
                    let post = JSON(value)
                    if let string = post.rawString()
                    {
                        if (response.response?.statusCode == 400 || response.response?.statusCode == 401)
                        {
                            let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                            print("The Response Error is:   \(response.response?.statusCode)")
                            
                            if let val = responseDic?["code"]
                            {
                                if val[0].isEqualToString("13")
                                {
                                    //print("Equals")
                                    self.displayCommonAlert(responseDic?["detail"]?[0] as! String)
                                    self.loadDummyScrollViewData()
                                    
                                    return
                                }
                                // now val is not nil and the Optional has been unwrapped, so use it
                            }
                            
                            if let errorData = responseDic?["detail"]
                            {
                                
                                if let errorMessage = errorData as? String
                                {
                                    self.displayCommonAlert(errorMessage)
                                    
                                }
                                else if let errorMessage = errorData as? NSArray
                                {
                                    if let errorMessageStr = errorMessage[0] as? String
                                    {
                                        self.displayCommonAlert(errorMessageStr)
                                    }
                                }
                                self.loadDummyScrollViewData()
                                return;
                            }
                        }
                        else if (response.response?.statusCode == 200 || response.response?.statusCode == 201)
                        {
                            //let responseArray : NSArray =  self.convertStringToArray(string)!
                            //let responseDic:[String:AnyObject]? = responseArray[0] as? [String : AnyObject]
                            self.venueSpecialArray = self.convertStringToArray(string)!
                            print("The  venueSpecialArray is:   \(self.venueSpecialArray)")
                           
                            /*
                            {
                            "id": "1",
                            "name": "Harry's Bar",
                            "operating_hours": "5pm-3am",
                            "location":
                            {
                            "address": "169 Grandview Road",
                            "city": "Springfield",
                            "state": "Pennsylvania",
                            "zipcode": "19064",
                            "longitude": "-75.337555",
                            "latitude": "39.9392799"
                            }
                            }
                            */
                            
                        }
                        else
                        {
                            
                        }
                        
                        self.loadDummyScrollViewData()
                    }
            }
        }
    }
    
    func loadVenueEventData()
    {
        let appDelegate=AppDelegate() //You create a new instance,not get the exist one
        appDelegate.startAnimation((self.navigationController?.view)!)
        
        var tokenString = "token "
        if let appToken =  NSUserDefaults.standardUserDefaults().objectForKey("LoginToken") as? String
        {
            tokenString +=  appToken
            
            let URL =  globalConstants.kAPIURL + globalConstants.kProfileVenueEvent
            
            
            let headers = [
                "Authorization": tokenString,
            ]
            
            let parameters = [
                "venue_id": self.venuId//.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()),
            ]
            Alamofire.request(.POST, URL , parameters: parameters, encoding: .JSON, headers : headers)
                .responseString { response in
                    
                    print("response \(response)")
                    appDelegate.stopAnimation()
                    guard let value = response.result.value else
                    {
                        print("Error: did not receive data")
                        self.loadDummyScrollViewData()
                        
                        return
                    }
                    
                    guard response.result.error == nil else
                    {
                        print("error calling POST on Login")
                        print(response.result.error)
                        self.loadDummyScrollViewData()
                        
                        return
                    }
                    
                    
                    let post = JSON(value)
                    if let string = post.rawString()
                    {
                        if (response.response?.statusCode == 400 || response.response?.statusCode == 401)
                        {
                            let responseDic:[String:AnyObject]? = self.convertStringToDictionary(string)
                            print("The Response Error is:   \(response.response?.statusCode)")
                            
                            if let val = responseDic?["code"]
                            {
                                if val[0].isEqualToString("13")
                                {
                                    //print("Equals")
                                    self.displayCommonAlert(responseDic?["detail"]?[0] as! String)
                                    self.loadDummyScrollViewData()
                                    
                                    return
                                }
                                // now val is not nil and the Optional has been unwrapped, so use it
                            }
                            
                            if let errorData = responseDic?["detail"]
                            {
                                
                                if let errorMessage = errorData as? String
                                {
                                    self.displayCommonAlert(errorMessage)
                                    
                                }
                                else if let errorMessage = errorData as? NSArray
                                {
                                    if let errorMessageStr = errorMessage[0] as? String
                                    {
                                        self.displayCommonAlert(errorMessageStr)
                                    }
                                }
                                self.loadDummyScrollViewData()
                                return;
                            }
                        }
                        else if (response.response?.statusCode == 200 || response.response?.statusCode == 201)
                        {
                            //let responseArray : NSArray =  self.convertStringToArray(string)!
                            //let responseDic:[String:AnyObject]? = responseArray[0] as? [String : AnyObject]
                            self.venueEventArray = self.convertStringToArray(string)!
                            print("The  venueEventArray is:   \(self.venueEventArray)")
                            
                            /*
                            {
                            "id": "1",
                            "name": "Harry's Bar",
                            "operating_hours": "5pm-3am",
                            "location":
                            {
                            "address": "169 Grandview Road",
                            "city": "Springfield",
                            "state": "Pennsylvania",
                            "zipcode": "19064",
                            "longitude": "-75.337555",
                            "latitude": "39.9392799"
                            }
                            }
                            */
                            
                        }
                        else
                        {
                            
                        }
                        
                        self.loadDummyScrollViewData()
                    }
            }
        }
    }
    
    func convertStringToDictionary(text:String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func convertStringToArray(text:String) -> NSArray? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    /*
    // Common alert method need to be used to display alert, by passing alert string as parameter to it.
    */
    
    func displayCommonAlert(alertMesage : NSString){
        
        let alertController = UIAlertController (title: globalConstants.kAppName, message: alertMesage as String?, preferredStyle:.Alert)
        let okayAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        alertController.addAction(okayAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}