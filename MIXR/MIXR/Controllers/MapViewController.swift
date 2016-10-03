//
//  SecondViewController.swift
//  MIXR
//
//  Created by Brendan Winter on 10/2/15.
//  Copyright (c) 2015 MIXR LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Mapbox
import MapKit

class MapViewController: BaseViewController {
    
    @IBOutlet var mapView: MGLMapView!
    
    override func viewDidLoad() {
      super.viewDidLoad()

      mapView.delegate = self
      loadMapData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMapData() {
        
        APIManager.sharedInstance.getAllVenueCoordinates({ [weak self] (response) in
            for subJson in response.arrayValue {
                let venue = Venue(venue: subJson.dictionaryObject ?? [:])
                
                let name = venue.name
                let address = venue.location?.address
                let longitude = venue.location?.longitude
                let latitude = venue.location?.latitude
                
                if let long = longitude, let lat = latitude {
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let point = MGLPointAnnotation()
                    point.coordinate = coordinate
                    point.title = name
                    point.subtitle = address
                    self?.mapView.addAnnotation(point)
                }
            }
        }, failure: nil)
        
//        let URL =  globalConstants.kAPIURL + globalConstants.kVenueCoordinatesAPIEndPoint
//        
//        Alamofire.request(.GET, URL , encoding: .JSON)
//            .responseJSON { response in
//                guard let value = response.result.value else {
//                    print("Error: did not receive data")
//                    return
//                }
//                
//                guard response.result.error == nil else {
//                    print("error calling POST")
//                    print(response.result.error)
//                    return
//                }
//                
//                
//                let json = JSON(response.result.value!)
//              
//                for (_, subJson): (String, JSON) in json {
//                  let venue = Venue(venue: subJson.dictionaryObject!)
//                
//                  let name = venue.name
//                  let address = venue.location?.address
//                  let longitude = venue.location?.longitude
//                  let latitude = venue.location?.latitude
//                
//                  if let long = longitude, let lat = latitude {
//                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//                    let point = MGLPointAnnotation()
//                    point.coordinate = coordinate
//                    point.title = name
//                    point.subtitle = address
//                    self.mapView.addAnnotation(point)
//                  }
//                  
//                }
//                
//                print("Response String:")
//        }
    }
}

// MARK: MGLMapViewDelegate Protocol
extension MapViewController: MGLMapViewDelegate {
  
  func mapView(mapView: MGLMapView, rightCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
    
    let button   = UIButton(type: UIButtonType.System) as UIButton
    button.frame = CGRectMake(100, 100, 60, 50)
    button.backgroundColor = UIColor.whiteColor()
    button.setTitle("View", forState: UIControlState.Normal)
    button.titleLabel?.textColor = UIColor.redColor()
    button.targetForAction(Selector("buttonAction"), withSender:self )
    
    return button
    
  }
  
  func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
    
    let filename = "locationDroplet"
    var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(filename)
    
    if annotationImage == nil {
      var image = UIImage(named: filename)!
      
      // disregard the image padding added to compensate for no anchor point offset in API
      image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
      annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: filename)
    }
    
    return annotationImage
  }
  
  func mapView(mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
    // hide the callout view
    mapView.deselectAnnotation(annotation, animated: false)
    
    let title = annotation.title!!
    
    //PUSH TO VENUE PROFILE use TITLE AS ID
    
    
    //potentially dangerous if multiple bars named identically
    //saves from inheriting MGLAnnotation, adding a venue_id string, extending the MGLMapViewDelegate with passing the VenueAnnotation (custom class with string) to this function annotation: VenueAnnotation. problem is that Mapbox is in Objective C so extending the protocol requires bridging header but the Swift VenueAnnotation object won't import in the extened protocol class nor could I import the extended protocol class
    
    UIAlertView(title: "\(annotation.title!!)", message: "A lovely \(title) bar!", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
  }
  
  func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
    return true
  }
}


