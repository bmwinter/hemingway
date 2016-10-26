//
//  Location.swift
//  MIXR
//
//  Created by Michael Ciesielka on 7/26/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import Foundation

struct Location {
  
  private static let kLocationAddressKey = "address"
  private static let kLocationStateKey = "state"
  private static let kLocationZipKey = "zipcode"
  private static let kLocationCityKey = "city"
  private static let kLocationLongitudeKey = "longitude"
  private static let kLocationLatitudeKey = "latitude"
  
  let address: String?
  let state: String? // use full state name, not abbreviation
  let zipcode: String?
  let city: String?
  
  // coordinates
  let longitude: Double?
  let latitude: Double?
  
  init(location: [String: AnyObject]) {
    address = location[Location.kLocationAddressKey] as? String
    state = location[Location.kLocationStateKey] as? String
    zipcode = location[Location.kLocationZipKey] as? String
    city = location[Location.kLocationCityKey] as? String
    
    if let long = location[Location.kLocationLongitudeKey] as? String {
      longitude = Double(long)
    } else {
      longitude = nil
    }
    
    if let lat = location[Location.kLocationLatitudeKey] as? String {
      latitude = Double(lat)
    } else {
      latitude = nil
    }
  }
}