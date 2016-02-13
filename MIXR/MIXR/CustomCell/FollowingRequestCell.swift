//
//  NotificationCell.swift
//  MIXR
//
//  Created by Nilesh Patel on 22/11/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit

class FollowingRequestCell: UITableViewCell
{
    @IBOutlet weak var followingRequestLbl: UILabel!
    @IBOutlet weak var notificationTimeStamp: UILabel!
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var cellBGView: UIView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        cellBGView.layer.cornerRadius = 0.0
        cellBGView.layer.borderWidth = 2.0
        cellBGView.layer.borderColor = UIColor(red: (214.0/255.0), green: (214.0/255.0), blue: (214.0/255.0), alpha: 1).CGColor
    }
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if (selected)
        {
            cellBGView.backgroundColor = UIColor(red: (214.0/255.0), green: (214.0/255.0), blue: (214.0/255.0), alpha: 1)
        }
        else
        {
            cellBGView.backgroundColor = UIColor.clearColor()
        }
    }
}
