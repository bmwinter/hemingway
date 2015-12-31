//
//  Specials.swift
//  MIXR
//
//  Created by Nilesh Patel on 27/12/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import Foundation
class Specials: NSObject{
    var specialsTitle : String!
    var specialsDate : String!
    
    init(specialsTitle: String, specialsDate: String) {
        super.init()
        self.specialsTitle = specialsTitle
        self.specialsDate = specialsDate
    }
    
}
