//
//  PromotionDetail.swift
//  MIXR
//
//  Created by Nilesh Patel on 25/11/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import UIKit

@objc class PromotionViewController: BaseViewController {
    
    @IBOutlet private weak var promotionContainerView: UIView?
    @IBOutlet private weak var priceLabel : UILabel!
    @IBOutlet private weak var timeUntilExpirationLabel : UILabel?
    @IBOutlet private weak var expirationDateLabel : UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var promotionImageView: UIImageView?
    
    @IBOutlet private weak var dividerView: UIView?
    @IBOutlet private weak var redeemButton: UIButton?
    
    var promotionModel: PromotionModel? {
        didSet {
            resetUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dividerView?.backgroundColor = UIColor.mixrLightGray()
        redeemButton?.backgroundColor = UIColor.mixrGreen()
        
        promotionContainerView?.layer.borderColor = UIColor.mixrLightGray().CGColor
        promotionContainerView?.layer.borderWidth = 2.0
        promotionImageView?.layer.borderColor = UIColor.mixrLightGray().CGColor
        promotionImageView?.layer.borderWidth = 2.0
        
    }
    
    func resetUI() {
        guard let promotion = promotionModel else { return }
        
        priceLabel?.text = promotion.priceLabel
        timeUntilExpirationLabel?.text = promotion.timeUntilExpirationString
        expirationDateLabel?.text = promotion.expirationDateString
        descriptionLabel?.text = promotion.description
        
        // TODO: implement SDWebImage for easy caching
        if let imageURLString = promotion.imageURLString,
            let url = NSURL(string: imageURLString),
            let data = NSData(contentsOfURL: url) {
            promotionImageView?.image = UIImage(data: data)
        }
        
    }
    
    @IBAction func redeemPromotion (sender : UIButton){
        
    }
}
