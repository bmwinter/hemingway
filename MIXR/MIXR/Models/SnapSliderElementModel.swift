//
//  SnapSliderModel.swift
//  MIXR
//
//  Created by Michael Ciesielka on 10/17/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//
import Foundation

struct SnapSliderElementModel {
    /// the label to display for this elemnt of the slider
    let label: String
    
    /// the fraction between 0 and 1 that corresponds to
    /// this element's location on the slider
    let value: Double
}
