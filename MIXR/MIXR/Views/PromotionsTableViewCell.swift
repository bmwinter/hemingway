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
    
    @IBOutlet private weak var containerBottomPaddingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTopPaddingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var statusLabelTopPaddingConstraint: NSLayoutConstraint?
    @IBOutlet private weak var statusLabelBottomPaddingConstraint: NSLayoutConstraint?
    
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
    
    private struct Constants {
        static let verticalContainerPadding: CGFloat = 3.0
        static let verticalLabelPadding: CGFloat = 20.0
    }
    
    static let estimatedRowHeight = Constants.verticalLabelPadding*2 + Constants.verticalContainerPadding*2 + 20
    
    private func textFromTimestamp(timestamp: NSTimeInterval?) -> String {
        if let _ = timestamp {
            let date = NSDate().timeIntervalSince1970 - 60*60*3
            return NSDate(timeIntervalSince1970: date).timeAgo()
        }
        return "n/a"
    }
    
    private func doInits() {
        containerView?.layer.borderColor = UIColor.mixrGray().CGColor
        containerView?.layer.borderWidth = 2.0
        containerView?.layer.cornerRadius = 5.0
        
        statusLabel?.font = UIFont.boldItalicFontWithSize(14.0)
        timestampLabel?.font = UIFont.boldFontWithSize(12.0)
        timestampLabel?.textColor = UIColor.mixrLightGray()
        timestampLabel?.textAlignment = .Center
        
        containerView?.translatesAutoresizingMaskIntoConstraints = false
        statusLabel?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        containerTopPaddingConstraint?.constant = Constants.verticalContainerPadding
        containerBottomPaddingConstraint?.constant = Constants.verticalContainerPadding
        statusLabelTopPaddingConstraint?.constant = Constants.verticalLabelPadding
        statusLabelBottomPaddingConstraint?.constant = Constants.verticalLabelPadding
        super.layoutSubviews()
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
