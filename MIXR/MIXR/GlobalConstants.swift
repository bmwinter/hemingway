//
//  GlobalConstants.swift
//  MIXR
//
//  Created by Nilesh Patel on 16/10/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import Foundation

enum APIName : Int
{
    case AuthenticationTokens       = 1
    case ProfileImages              = 2
    case Venues                     = 3
     case Users                     = 4
}


struct globalConstants {
    static let kAppName = "MIXR"
    
    static let kValidEmailError = "Please enter valid email"
    static let kEmailError = "Please enter email"
    static let kpasswordError = "Please enter password"
    static let kfirstnameError = "Please enter firstname"
    static let klastnameError = "Please enter lastname"
    static let kconfirmPasswordError = "Please enter confirm password"
    static let kpasswordconfirmPasswordError = "Password and confirm password must be same"
    static let kageRestrictionError = "To use this application, Your age should be greather that 18 years"
    static let ktermsandConditionError = "Please accept terms & condition!"
    
    /*
    // Method to check wether email is valid or not.
    */
    
    static func isValidEmail(testStr:String) -> Bool {
        print("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }
}

