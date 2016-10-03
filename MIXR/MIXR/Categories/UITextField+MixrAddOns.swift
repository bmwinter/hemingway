//
//  File.swift
//  MIXR
//
//  Created by Michael Ciesielka on 9/26/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit

extension UITextField {
    var textValue: String {
        switch text {
        case .Some(let value):
            return value
        case .None:
            return ""
        }
    }
}
