//
//  NewsFeedTableViewController.swift
//  MIXR
//
//  Created by imac04 on 1/9/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit
import MediaPlayer
import Player
import AssetsLibrary
import SwiftyJSON
import Alamofire
import AlamofireImage

import SpringIndicator

let isLocalData = false
//let videoUrl = NSURL(string: "https://v.cdn.vine.co/r/videos/AA3C120C521177175800441692160_38f2cbd1ffb.1.5.13763579289575020226.mp4")!

let videoUrl = NSURL(string: "https://s3-us-west-2.amazonaws.com/mixruploads/2016_03_27_04_57_66.mp4")!

class NewsFeedTableViewController: UITableViewController, SpringIndicatorTrait {
    
    var feedcount : Int = 0
    var feedsArray : NSMutableArray  = NSMutableArray()
    private var player: Player!
    var moviePlayer : MPMoviePlayerController?
    
    var springIndicator: SpringIndicator?
    
    var venueId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        
        setupPullToRefresh()
    }
    
    func playVideoFile() {
        self.view.autoresizingMask = ([UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight])
        
        self.player = Player()
        self.player.delegate = self
        self.player.view.frame = self.view.bounds
        
        self.addChildViewController(self.player)
        self.view.addSubview(self.player.view)
        self.player.didMoveToParentViewController(self)
        
        self.player.setUrl(videoUrl)
        
        self.player.playbackLoops = true
        self.player.fillMode = AVLayerVideoGravityResizeAspect

        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewsFeedTableViewController.handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.player.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupPullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "")//Updating
        self.refreshControl!.addTarget(self, action: #selector(NewsFeedTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
    }
    
    func refresh(sender:AnyObject) {
        feedcount = 0
        self.loadData()
        // Code to refresh table view
        self.performSelector(#selector(NewsFeedTableViewController.endReferesh), withObject: nil, afterDelay: 1.0)
    }
    
    func endReferesh() {
        //End refresh control
        self.refreshControl?.endRefreshing()
        //Remove refresh control to superview
        //self.refreshControl?.removeFromSuperview()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(NewsFeedTableViewController.loadData), userInfo: nil, repeats: false)
    }

    func loadData() {
        if (isLocalData) {
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
            
        } else {
            if venueId == nil {
                self.getAllNewsFeed()
            } else {
                self.getVenueNewsfeed()
            }
            
        }
    }
    
    func newsFeedType() -> APIAction {
        if let controller = parentViewController as? PostViewController {
            if controller.isUserProfile {
                return .MyNewsfeed
            } else {
                return .NewsfeedUser
            }
        } else if venueId != nil {
            return .NewsfeedVenue
        }
        
        return .NewsfeedAll
    }
    
    // MARK: Retrieve All News Feed data.
    func getAllNewsFeed(){
        APIManager.sharedInstance.getNewsfeed(forType: newsFeedType(),
                                              success: { [weak self] (response) in
                                                if let arr = response.arrayObject {
                                                    self?.feedsArray = NSMutableArray(array: arr)
                                                } else {
                                                    self?.feedsArray = []
                                                }
                                                self?.reloadTable()
        }, failure: { (error) in
                
        })
    }
    
    func getVenueNewsfeed() {
        guard let venueId = venueId else { return }
        APIManager.sharedInstance.getNewsfeed(forVenueId: venueId,
                                              success: { [weak self] (response) in
                                                if let arr = response.arrayObject {
                                                    self?.feedsArray = NSMutableArray(array: arr)
                                                } else {
                                                    self?.feedsArray = []
                                                }
                                                self?.reloadTable()
            }, failure: { (error) in
                
        })
    }
    
    func reloadTable()
    {
        tableView.reloadData()
    }
    
    @IBAction func onUserBtnClicked(sender: AnyObject)
    {
        // TODO: change this short-circuit -- kept only in case this 
        // functionality is needed
        return
        
        // let postViewController : ProfileTableViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ProfileTableViewController") as! ProfileTableViewController
        // //postViewController.feedDict = feedDict
        // self.navigationController!.pushViewController(postViewController, animated: true)
        // return
        
        let feedBtn : UIButton = sender as! UIButton
        let feedTag = feedBtn.superview!.tag
        NSLog("feedTag = \(feedTag)")
        //let feedDict : NSDictionary = feedsArray[feedTag].dictionaryObject!
        let postViewController : PostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PostViewController") as! PostViewController
        postViewController.isUserProfile = false
        self.navigationController!.pushViewController(postViewController, animated: true)
    }
    
    @IBAction func onFeedClicked(sender: AnyObject)
    {
//        let aVenueProfileViewController : VenueProfileViewController = self.storyboard!.instantiateViewControllerWithIdentifier("VenueProfileViewController") as! VenueProfileViewController
//        self.navigationController!.pushViewController(aVenueProfileViewController, animated: true)
//        return
//        let followingViewController : FollowingViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FollowingViewController") as! FollowingViewController
//        self.navigationController!.pushViewController(followingViewController, animated: true)
//        return;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : GET Preview Image From Video URL
    
    func getPreviewImageForVideoAtURL(videoURL: NSURL, atInterval: Int) -> UIImage? {
        print("Taking pic at \(atInterval) second")
        let asset = AVAsset(URL: videoURL)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(Float64(atInterval), 100)
        do {
            let img = try assetImgGenerate.copyCGImageAtTime(time, actualTime: nil)
            let frameImg = UIImage(CGImage: img)
            return frameImg
        } catch {
            /* error handling here */
        }
        return nil
    }
    

    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK : UIImageView Double Tap Event.
    
    func doubleImageTapped(sender: UITapGestureRecognizer) {
        
        print("Double Tapped")
        
        let feedBtn : UIButton = sender.view as! UIButton
        let feedTag = feedBtn.superview!.tag
        self.likePost(feedTag)
        
//        self.performSegueWithIdentifier("MuestraImagen", sender: self)
    }

    func singleImageTapped(sender: UITapGestureRecognizer) {
        
        print("Single Tapped")

        let feedBtn : UIButton = sender.view as! UIButton
        let feedTag = feedBtn.superview!.tag
        let dicPost : NSDictionary = self.feedsArray[feedTag] as! NSDictionary
        if dicPost["media"] as! String == "video"{
            self.startPlayingVideo(dicPost["media_url"] as! String)
        }else{
            let fullScreenPicVC : FullScreenImageViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FullScreenImageViewController") as! FullScreenImageViewController
            fullScreenPicVC.dicData = dicPost.mutableCopy() as! NSMutableDictionary
            //            self.navigationController!.pushViewController(fullScreenPicVC, animated: false)
            self.presentViewController(fullScreenPicVC, animated: false, completion: {
                
            })
        }
    }
    
    func venueNameButtonTapped(sender : UIButton){
        let feedBtn : UIButton = sender 
        let feedTag = feedBtn.superview!.tag
        let dicPost : NSDictionary = self.feedsArray[feedTag] as! NSDictionary

//        let aVenueProfileViewController : VenueProfileViewController = self.storyboard!.instantiateViewControllerWithIdentifier("VenueProfileViewController") as! VenueProfileViewController
        if let venueProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VenueProfileV2ViewController") as? VenueProfileV2ViewController,
          let venueIdInt = dicPost["venue_id"] as? Int {
            AppPersistedStore.sharedInstance.selectedVenueId = String(venueIdInt)
            venueProfileViewController.venueId = String(venueIdInt)
            self.navigationController!.pushViewController(venueProfileViewController, animated: true)
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.isKindOfClass(UIScreenEdgePanGestureRecognizer)
    }
    
    func gestureRecognizer(_: UIGestureRecognizer,shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }


    // MARK : Like POST API call
    
    func likePost(tag: Int){
        
        let dicFeed = self.feedsArray.objectAtIndex(tag)
        
        if let postId = dicFeed["post_id"] as? Int, activeLike = dicFeed["user_likes"] as? Int {
            APIManager.sharedInstance.likePost(withPostId: String(postId),
                                               activeLike: activeLike == 0,
                                               success: { [weak self] (response) in
                                                if let _ = response["post_id"].string {
                                                    if let dicFeed = self?.feedsArray.objectAtIndex(tag).mutableCopy(),
                                                        var likeCount = dicFeed["likes"] as? Int,
                                                        let userlike = dicFeed["user_likes"] as? Int {
                                                        if userlike == 0 {
                                                            likeCount = likeCount + 1;
                                                            dicFeed.setValue(1, forKey: "user_likes")
                                                        }else{
                                                            likeCount = likeCount - 1;
                                                            dicFeed.setValue(0, forKey: "user_likes")
                                                        }
                                                        
                                                        dicFeed.setValue(likeCount, forKey: "likes")
                                                        self?.feedsArray.replaceObjectAtIndex(tag, withObject: dicFeed.mutableCopy())
                                                        self?.reloadTable()
                                                    }
                                                }
                }, failure: nil)
        }
    }
}

// MARK: - Table view data source
extension NewsFeedTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
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
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        //let feedDict : Dictionary <String, JSON> = feedsArray[indexPath.row]
        cell.venuBackground.tag = indexPath.row
        
        //        let cache = Shared.imageCache
        
        //        let URL = NSURL(string: "http://haneke.io/icon.png")!
        //        let fetcher = NetworkFetcher<UIImage>(URL: URL)
        //        cache.fetch(fetcher: fetcher).onSuccess { image in
        //            // Do something with image
        //            cell.venuImageView.image = image
        //
        //        }
        
        if let imageNameStr = feedsArray[indexPath.row]["media_url"] as? String
        {
            if (imageNameStr.characters.count > 0)
            {
                var URL = NSURL(string: imageNameStr)!
                if feedsArray[indexPath.row]["media"] as? String == "video"{
                    
                    URL = NSURL(string: (feedsArray[indexPath.row]["video_thumnail"] as? String)!)!
                    //                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    //                        let data = NSData(contentsOfURL: URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
                    //                        dispatch_async(dispatch_get_main_queue(), {
                    //                            cell.venuImageView.image = UIImage(data: data!)
                    //                        });
                    //                    }
                    
                    
                    Request.addAcceptableImageContentTypes(["binary/octet-stream"])
                    let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                        size: cell.venuImageView.frame.size,
                        radius: 0.0
                    )
                    cell.venuImageView.af_setImageWithURL(URL, placeholderImage: UIImage(named: "ALPlaceholder"), filter: filter, imageTransition: .None, completion: { (response) -> Void in
                        print("image: \(cell.venuImageView.image)")
                        print(response.result.value) //# UIImage
                        print(response.result.error) //# NSError
                    })
                }
                else
                {
                    Request.addAcceptableImageContentTypes(["binary/octet-stream"])
                    let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                        size: cell.venuImageView.frame.size,
                        radius: 0.0
                    )
                    cell.venuImageView.af_setImageWithURL(URL, placeholderImage: UIImage(named: "ALPlaceholder"), filter: filter, imageTransition: .None, completion: { (response) -> Void in
                        print("image: \(cell.venuImageView.image)")
                        print(response.result.value) //# UIImage
                        print(response.result.error) //# NSError
                    })
                }
            }
            else
            {
                cell.venuImageView.image = UIImage(named:"ALPlaceholder")
            }
        }
        else
        {
            cell.venuImageView.image = UIImage(named:"ALPlaceholder")
        }
        
        cell.FeedName.tag = indexPath.row;
        
        cell.FeedName.text = feedsArray[indexPath.row]["venue_name"] as? String
        cell.lblUserName.text = feedsArray[indexPath.row]["full_name"] as? String
        
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "martiniglass_iconNew.png")
        let attachmentString = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: " ")
        myString.appendAttributedString(attachmentString)
        let numLikes = feedsArray[indexPath.row]["likes"] as? NSInteger ?? 0
        myString.appendAttributedString(NSMutableAttributedString(string: String(numLikes)))
        cell.lblLike.attributedText = myString
        
        
        cell.venuImageView?.userInteractionEnabled = true
        cell.venuImageView?.tag = indexPath.row
        
        cell.venueButton.tag = indexPath.row
        cell.venueButton.addTarget(self, action: #selector(NewsFeedTableViewController.venueNameButtonTapped(_:)), forControlEvents: .TouchUpInside)
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(NewsFeedTableViewController.doubleImageTapped(_:)))
        doubleTapGestureRecognizer.numberOfTouchesRequired = 1
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        cell.feedBtn?.addGestureRecognizer(doubleTapGestureRecognizer)
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(NewsFeedTableViewController.singleImageTapped(_:)))
        singleTapGestureRecognizer.numberOfTouchesRequired = 1
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        cell.feedBtn?.addGestureRecognizer(singleTapGestureRecognizer)
        
        singleTapGestureRecognizer.requireGestureRecognizerToFail(doubleTapGestureRecognizer)
        
        
        /*
         cell.venuImageView.image = UIImage(named: feedDict["venueImage"] as! String)
         cell.FeedName.text = feedDict["venueName"] as? String
         cell.lblUserName.text = feedDict["userName"] as? String
         */
        if((indexPath.row == (feedsArray.count-2)) && feedsArray.count > 8)
        {
            self.loadData()
        }
        
        // updates for new design
        cell.userBtn.hidden = true
        cell.userBtn.enabled = false
        cell.lblUserName.hidden = true
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("indexpath.row = \(indexPath.row)")
    }
}

extension NewsFeedTableViewController: UIGestureRecognizerDelegate {
    
    func handleTapGestureRecognizer(gestureRecognizer: UITapGestureRecognizer) {
        switch (self.player.playbackState.rawValue) {
        case PlaybackState.Stopped.rawValue:
            self.player.playFromBeginning()
        case PlaybackState.Paused.rawValue:
            self.player.playFromCurrentTime()
        case PlaybackState.Playing.rawValue:
            self.player.pause()
        case PlaybackState.Failed.rawValue:
            self.player.pause()
        default:
            self.player.pause()
        }
    }
}

extension NewsFeedTableViewController: PlayerDelegate {
    // MARK: PlayerDelegate
    
    func playerReady(player: Player) {
    }
    
    func playerPlaybackStateDidChange(player: Player) {
    }
    
    func playerBufferingStateDidChange(player: Player) {
    }
    
    func playerCurrentTimeDidChange(player: Player) { }
    
    func playerPlaybackWillStartFromBeginning(player: Player) {
    }
    
    func playerPlaybackDidEnd(player: Player) {
    }
    
    
    func videoHasFinishedPlaying(notification: NSNotification){
        
        print("Video finished playing")
        
        /* Find out what the reason was for the player to stop */
        let reason =
            notification.userInfo![MPMoviePlayerPlaybackDidFinishReasonUserInfoKey]
                as! NSNumber?
        
        if let theReason = reason{
            
            let reasonValue = MPMovieFinishReason(rawValue: theReason.integerValue)
            
            switch reasonValue!{
            case .PlaybackEnded:
                /* The movie ended normally */
                print("Playback Ended")
            case .PlaybackError:
                /* An error happened and the movie ended */
                print("Error happened")
            case .UserExited:
                /* The user exited the player */
                print("User exited")
            }
            
            print("Finish Reason = \(theReason)")
            stopPlayingVideo()
        }
        
    }
    
    func stopPlayingVideo() {
        
        if let player = moviePlayer{
            NSNotificationCenter.defaultCenter().removeObserver(self)
            player.stop()
            player.view.removeFromSuperview()
        }
        
    }
    
    func startPlayingVideo(urlString:NSString){
        
        /* First let's construct the URL of the file in our application bundle
         that needs to get played by the movie player */
        
        //        let dataPath = globalConstants.getStoreImageVideoPath(globalConstants.kTempVideoFileName)
        //documentsDirectory.stringByAppendingPathComponent("/vid1.mp4")
        let url = NSURL(string: urlString as String)
        
        /* If we have already created a movie player before,
         let's try to stop it */
        if let _ = moviePlayer{
            stopPlayingVideo()
        }
        
        /* Now create a new movie player using the URL */
        moviePlayer = MPMoviePlayerController(contentURL: url)
        
        if let player = moviePlayer{
            
            /* Listen for the notification that the movie player sends us
             whenever it finishes playing */
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: #selector(NewsFeedTableViewController.videoHasFinishedPlaying(_:)),
                                                             name: MPMoviePlayerPlaybackDidFinishNotification,
                                                             object: nil)
            
            print("Successfully instantiated the movie player")
            
            /* Scale the movie player to fit the aspect ratio */
            player.scalingMode = .AspectFit
            player.movieSourceType = .Streaming
            player.contentURL = url
            view.addSubview(player.view)
            
            player.setFullscreen(true, animated: false)
            
            /* Let's start playing the video in full screen mode */
            player.play()
            
        } else {
            print("Failed to instantiate the movie player")
        }
        
    }

}

