//
//  VenueNewsFeedContainerViewController.swift
//  MIXR
//
//  Created by Michael Ciesielka on 10/23/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit

class VenueNewsFeedContainerViewController: BaseViewController {
    var name: String!
    var venueId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = name
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? NewsFeedTableViewController {
            vc.venueId = venueId
        }
    }
    
    override func shouldUseDefaultImage() -> Bool {
        return false
    }
}
