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
  
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        imageview.layer.cornerRadius = 10.0
//        imageview.layer.borderColor = UIColor.grayColor().CGColor
//        imageview.layer.borderWidth = 1.0
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
