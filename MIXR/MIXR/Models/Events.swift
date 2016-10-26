//
//  Events.swift
//  MIXR
//
//  Created by Nilesh Patel on 27/12/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import Foundation

class Events: NSObject{
    var eventTitle : String!
    var eventDate : String!
    
    init(eventTitle: String, eventDate: String) {
        super.init()
        self.eventTitle = eventTitle
        self.eventDate = eventDate
    }
    
}
