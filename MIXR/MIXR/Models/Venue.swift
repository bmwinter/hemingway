//
//  Venue.swift
//  MIXR
//
//  Created by Michael Ciesielka on 7/26/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import Foundation

struct Venue {
  
  private static let kVenueIdKey = "venue_id"
  private static let kVenueNameKey = "name"
  private static let kVenueLocationKey = "location"
  private static let kVenueImageFilenameKey = "image_filename"
  private static let kVenueOperatingHoursKey = "operating_hours"

  let venue_id: Int?
  let name: String?
  let location: Location?
  let imageFilename: String?
  let operatingHours: String?
  
  init(venue: [String: AnyObject]) {
    venue_id = venue[Venue.kVenueIdKey] as? Int
    name = venue[Venue.kVenueNameKey] as? String
    if let locationObj = venue[Venue.kVenueLocationKey] as? [String: AnyObject] {
      location = Location(location: locationObj)
    } else {
      location = nil
    }
    imageFilename = venue[Venue.kVenueImageFilenameKey] as? String
    operatingHours = venue[Venue.kVenueOperatingHoursKey] as? String
  }

}
