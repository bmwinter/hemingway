//
//  PromotionDetail.swift
//  MIXR
//
//  Created by Nilesh Patel on 25/11/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit


class PromotionDetail: UITableViewController {
    
    @IBOutlet weak var promotionContainerView: UIView?
    @IBOutlet weak var lblOfferPrice : UILabel!
    @IBOutlet weak var lblExpireTime : UILabel!
    @IBOutlet weak var promotionImageView: UIImageView?
    @IBOutlet weak var lblExpireDateTime : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "BG"))
        self.title = "Promotions"
        
        promotionContainerView?.layer.borderColor = UIColor.mixrLightGray().CGColor
        promotionContainerView?.layer.borderWidth = 2.0
        promotionImageView?.layer.borderColor = UIColor.mixrLightGray().CGColor
        promotionImageView?.layer.borderWidth = 2.0
        
    }

    
    @IBAction func redeembuttonTapped (sender : AnyObject){
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}
