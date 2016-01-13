//
//  UserFeedCell.swift
//  MIXR
//
//  Created by imac04 on 11/25/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit

class UserFeedCell: UITableViewCell {
    
    @IBOutlet weak var FeedName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLike: UILabel!
    
    @IBOutlet weak var venuImageView: UIImageView!
    @IBOutlet weak var venuBackground: UIView!
    
    @IBOutlet weak var userBtn: UIButton!
    @IBOutlet weak var feedBtn: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        venuBackground.layer.cornerRadius = 0.0
        venuBackground.layer.borderColor = UIColor(red: (214.0/255.0), green: (214.0/255.0), blue: (214.0/255.0), alpha: 1).CGColor //UIColor.lightGrayColor().CGColor
        venuBackground.layer.borderWidth = 2.0
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
