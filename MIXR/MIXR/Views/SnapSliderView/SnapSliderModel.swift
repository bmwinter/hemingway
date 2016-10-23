//
//  SnapSliderModel.swift
//  MIXR
//
//  Created by Michael Ciesielka on 10/22/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import Foundation

class SnapSliderModel {
    private var _value: Double = 0.0
    
    var value: Double {
        set {
            var new = newValue
            if newValue >= 1 { new = 1 }
            if newValue <= 0 { new = 0 }
            _value = new
        }
        
        get {
            return _value
        }
    }
    
    private var delta: Double {
        return 1.0 / Double(intervals - 1)
    }
    
    private var intervals: Int
    
    init?(intervals: Int) {
        guard intervals >= 1 else { return nil }
        self.intervals = intervals
    }
    
    func nearestIntervalIndex() -> Int {
        guard value >= 0 && value <= 1 else { return -1 }
        return min(lround(value / delta), intervals - 1)
    }
}
