//
//  PromotionsTableViewCell.swift
//  MIXR
//
//  Created by Michael Ciesielka on 8/22/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit

class PromotionTableViewCell: UITableViewCell {

    @IBOutlet private weak var statusLabel: UILabel?
    @IBOutlet private weak var timestampLabel: UILabel?
    
    @IBOutlet private weak var containerView: UIView?
    
    private var _status: String?
    private var _timestamp: NSTimeInterval?
    
    var status: String? {
        set {
            _status = newValue
            statusLabel?.text = _status
        }
        
        get {
            return _status
        }
    }
    
    var timestamp: NSTimeInterval? {
        set {
            _timestamp = newValue
            timestampLabel?.text = textFromTimestamp(_timestamp)
        }
        
        get {
            return _timestamp
        }
    }
    
    private func textFromTimestamp(timestamp: NSTimeInterval?) -> String {
        if let _ = timestamp {
            return ""
        }
        return "..."
    }
    
    private func doInits() {
        containerView?.layer.borderColor = UIColor.mixrGrey().CGColor
        containerView?.layer.borderWidth = 2.0
        containerView?.layer.cornerRadius = 5.0
        
        statusLabel?.font = UIFont.boldItalicFontWithSize(12.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doInits()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doInits()
    }
}
