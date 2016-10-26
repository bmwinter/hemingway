//
//  VenueAnnotation.swift
//  MIXR
//
//  Created by Brendan Winter on 3/23/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import Foundation
import Mapbox

class VenueAnnotation: MGLPointAnnotation {
    var venue_id: String
    
    init(venue_id: String) {
        self.venue_id = venue_id
        super.init()
    }
    
}



