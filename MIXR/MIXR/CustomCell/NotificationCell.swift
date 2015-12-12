//
//  NotificationCell.swift
//  MIXR
//
//  Created by Nilesh Patel on 22/11/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var notificationText: UILabel!
    @IBOutlet weak var notificationTimeStamp: UILabel!
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var cellBGView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellBGView.layer.cornerRadius = 10.0
        cellBGView.layer.borderColor = UIColor.grayColor().CGColor
        cellBGView.layer.borderWidth = 1.0
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
