//
//  Fonts.swift
//  MIXR
//
//  Created by Michael Ciesielka on 8/22/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit

extension UIFont {
    private struct Constants {
        static let regularFontName = "ForgottenFuturistRg-Regular"
        static let boldItalicFontName = "ForgottenFuturistRg-BoldItalic"
        static let boldFontName = "ForgottenFuturistRg-Bold"
    }
    
    private class func themeFont(name: String, withSize size: CGFloat) -> UIFont {
        if let font = UIFont(name: name, size: size) {
            return font
        }
        return systemFontOfSize(size)
    }
    
    class func regularFontWithSize(size: CGFloat) -> UIFont {
        return themeFont(Constants.regularFontName, withSize: size)
    }
    
    class func boldItalicFontWithSize(size: CGFloat) -> UIFont {
        return themeFont(Constants.boldItalicFontName, withSize: size)
    }
    
    class func boldFontWithSize(size: CGFloat) -> UIFont {
        return themeFont(Constants.boldFontName, withSize: size)
    }
}