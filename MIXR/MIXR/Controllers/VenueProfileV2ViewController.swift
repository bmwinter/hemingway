//
//  VenueProfileV2ViewController.swift
//  MIXR
//
//  Created by Michael Ciesielka on 10/23/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit

class VenueProfileV2ViewController: BaseViewController {
    
    // top view
    @IBOutlet weak var likesContainerView: UIView!
    @IBOutlet private weak var numberOfLikesLabel: UILabel!
    @IBOutlet private weak var venueLogoImageView: UIImageView!
    
    // middle view
    @IBOutlet private weak var hoursLabel: UILabel!
    @IBOutlet private weak var streetAddressLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    
    @IBOutlet private var borderedContainerViews: [UIView]!
    
    private var name: String?
    
    var venueId: String? {
        didSet {
            reloadData()
        }
    }
    
    private var numberOfLikes = 0 {
        didSet {
            numberOfLikesLabel.text = String(numberOfLikes)
        }
    }
    private var liked = false

    override func viewDidLoad() {
        super.viewDidLoad()

        for containerView in borderedContainerViews {
            containerView.backgroundColor = UIColor.clearColor()
            containerView.layer.borderWidth = 3.0
            containerView.layer.borderColor = UIColor.venueBorderColor().CGColor
        }
        
        numberOfLikesLabel.text = "0"
        likesContainerView.userInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VenueProfileV2ViewController.handleLikeButton(_:)))
        likesContainerView.addGestureRecognizer(gestureRecognizer)
        
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VenueProfileV2ViewController.handleImageTapped(_:)))
        venueLogoImageView.userInteractionEnabled = true
        venueLogoImageView.addGestureRecognizer(imageGestureRecognizer)
    }
    
    override func shouldUseDefaultImage() -> Bool {
        return false
    }
    
    @objc func handleLikeButton(gestureRecognizer: UITapGestureRecognizer) {
        // TODO: likes are not hooked up on the backend for venues
        if liked {
            liked = false
            numberOfLikes -= 1
        } else {
            liked = true
            numberOfLikes += 1
        }
    }
    
    @objc func handleImageTapped(gestureRecognizer: UITapGestureRecognizer) {
        if let venueFeedContainerVC = storyboard?.instantiateViewControllerWithIdentifier("VenueNewsFeedContainerViewController") as? VenueNewsFeedContainerViewController, let name = name {
            venueFeedContainerVC.venueId = venueId
            venueFeedContainerVC.name = name
            navigationController?.pushViewController(venueFeedContainerVC, animated: true)
        }
    }
}

private extension VenueProfileV2ViewController {
    func reloadData() {
        guard let venueId = venueId else { return }
        
        // TODO: refactor background to return all this info in one API call
        
        // get basic profile info
        APIManager.sharedInstance.getVenueProfile(venueId: venueId, success: { [weak self] (response) in
            if response.arrayValue.count > 0 {
                guard let model = response.arrayValue[0].dictionaryObject else { return }
                let venueModel = Venue(venue: model)
                self?.updateUIForModel(venueModel)
            }
        }, failure: nil)
        
        // TODO: API doesn't give enough detail to show events correctly
        // get venue events
        APIManager.sharedInstance.getVenueEvents(venueId: venueId, success: { (response) in
            print(response)
        }, failure: nil)
    
        // get venue specials
        APIManager.sharedInstance.getVenueSpecials(venueId: venueId, success: { (response) in
            print(response)
        }, failure: nil)
    }
    
    func updateUIForModel(model: Venue) {
        navigationItem.title = model.name
        name = model.name
        hoursLabel.text = model.operatingHours
        streetAddressLabel.text = model.location?.address
        
        if let city = model.location?.city, let state = model.location?.state, let zip = model.location?.zipcode {
            cityLabel.text = "\(city), \(state) \(zip)"
        }
        
        if let urlString = model.imageFilename where !urlString.isEmpty {
            if let url = NSURL(string: urlString), let data = NSData(contentsOfURL: url) {
                venueLogoImageView.image = UIImage(data: data)
            }
        }
    }
}
