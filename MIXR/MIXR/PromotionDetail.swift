//
//  PromotionDetail.swift
//  MIXR
//
//  Created by Nilesh Patel on 25/11/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit


class PromotionDetail: UITableViewController {
    
    @IBOutlet weak var lblOfferPrice : UILabel!
    @IBOutlet weak var lblExpireTime : UILabel!
    @IBOutlet weak var lblExpireDateTime : UILabel!
    
    @IBAction func redeembuttonTapped (sender : AnyObject){
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}