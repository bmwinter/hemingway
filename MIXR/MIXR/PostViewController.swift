//
//  PostViewController.swift
//  MIXR
//
//  Created by imac04 on 11/30/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    var feedDict : NSDictionary = NSDictionary()
    @IBOutlet weak var FeedName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var venuImageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.loadData()
        // Do any additional setup after loading the view.
    }

    func loadData()
    {
        if (feedDict.allKeys.count > 0)
        {
            self.venuImageView.image = UIImage(named: feedDict["venueImage"] as! String)
            self.FeedName.text = feedDict["venueName"] as? String
            self.lblUserName.text = feedDict["userName"] as? String
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackClicked(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
