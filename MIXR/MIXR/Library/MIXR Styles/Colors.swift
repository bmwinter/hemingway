//
//  Colors.swift
//  MIXR
//
//  Created by Michael Ciesielka on 8/22/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }
}

extension UIColor {
    class func mixrGray() -> UIColor {
        return UIColor(r: 214, g: 214, b: 214)
    }
    
    class func mixrLightGray() -> UIColor {
        return UIColor(r: 120, g: 120, b: 120)
    }
    
    class func mixrGreen() -> UIColor {
        return UIColor(r: 127, g: 162, b: 105)
    }
    
    class func snapSliderBackgroundViewColor() -> UIColor {
        return UIColor(r: 158, g: 158, b: 158)
    }
    
    class func venueBorderColor() -> UIColor {
        return UIColor(r: 224, g: 224, b: 224)
    }
    
    class func gradientLightColor() -> UIColor {
        return UIColor(r: 247, g: 247, b: 247)
    }
    
    class func gradientDarkColor() -> UIColor {
        return UIColor(r: 233, g: 233, b: 233)
    }
}
