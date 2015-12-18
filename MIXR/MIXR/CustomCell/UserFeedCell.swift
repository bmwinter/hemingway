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
    
    @IBOutlet weak var venuImageView: UIImageView!
    @IBOutlet weak var venuBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        venuBackground.layer.cornerRadius = 0.0
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 0.5

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
