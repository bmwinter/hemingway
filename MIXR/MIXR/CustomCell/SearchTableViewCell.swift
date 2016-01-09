//
//  SearchTableViewCell.swift
//  MIXR
//
//  Created by macMini on 02/12/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    let feedsArray : NSMutableArray = NSMutableArray()
    @IBOutlet var imageview: UIView!
    
    @IBOutlet weak var mobileNumber: UILabel!
    @IBOutlet var imagePerson: UIImageView!
    @IBOutlet var labelName: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        //self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.contentView.layer.borderWidth = 2.0
        self.contentView.layer.borderColor = UIColor(red: (214.0/255.0), green: (214.0/255.0), blue: (214.0/255.0), alpha: 1).CGColor
    }
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
