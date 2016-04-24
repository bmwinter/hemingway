//
//  GlobalConstants.swift
//  MIXR
//
//  Created by Nilesh Patel on 16/10/15.
//  Copyright © 2015 MIXR LLC. All rights reserved.
//

import Foundation

extension String {
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
}


enum APIName : Int
{
    case AuthenticationTokens       = 1
    case ProfileImages              = 2
    case Venues                     = 3
    case Users                      = 4
}


struct globalConstants {
    static let kAPIURL = "http://54.174.249.237/"
    
    static let kLoginAPIEndPoint = "login"
    static let kSignUpAPIEndPoint = "register"
    static let kGetVerificationCode = "confirmation"
    static let kVerifyCodeAPIEndPoint = "confirmation/check"
    static let kPasswordRecover = "password/recover"
    static let kPasswordRecoverChange = "password/recover/change"
    
    static let kProfileUpdate = "profile"
    static let kProfileOther = "profile/other"
    static let kProfileVenue = "profile/venue"
    
    static let kProfileVenueSpecial = "venue/specials"
    static let kProfileVenueEvent = "venue/events"
    
    static let kChangePasswordAPIEndPoint = "password/change"
    
    static let kVenueDetailsAPIEndPoint = "VenueDetails"
    static let kNotificationsAPIEndPoint = "Notifications"
    static let kPromotionAPIEndPoint = "Promotions"
    static let kUserProfileAPIEndPoint = "UserProfile"
    static let kSettingAPIEndPoint = "UserSettings"
    
    
    static let kSearchAPIEndPoint = "search"
    static let kFollowingAPIEndPoint = "following"
    static let kFollowersAPIEndPoint = "followers"
    
    static let kFollowRequestForVenueAPIEndPoint = "follow/request/venue"
    static let kFollowRequestAPIEndPoint = "follow/request"
    static let kFollowRequestUpdateAPIEndPoint = "follow/request/update"
    static let kFollowStatusForUserAPIEndPoint = "follow/status/user"
    static let kFollowStatusForVenueAPIEndPoint = "follow/status/venue"
    
    static let kNewsfeedAPIEndPoint = "newsfeed"
    static let kNewsfeedUserAPIEndPoint = "newsfeed/user"
    static let kNewsfeedMyAPIEndPoint = "newsfeed/my"
    static let kNewsfeedVenueAPIEndPoint = "newsfeed/venue"
    
    static let kVenueCoordinatesAPIEndPoint = "venue" // get coordinates for map
    
    static let kPostVenuePhotoVideo = "post"
    static let kAllNewsFeed = "newsfeed"
    static let kMakeProfilePublicPrivate = "profile/public"
    static let kLikePost = "post/like"
    static let kGetVenuesList = "venue"

    static let kAppName = "MIXR"
    
    static let kValidEmailError = "Please enter valid email"
    static let kEmailError = "Please enter email"
    static let kpasswordError = "Please enter password"
    static let kfirstnameError = "Please enter firstname"
    static let klastnameError = "Please enter lastname"
    static let kconfirmPasswordError = "Please enter confirm password"
    static let kCountryCodeError = "Please enter country code"
    static let kPhoneNoError = "Please enter phone No"
    static let kverificationCodeError = "Please enter verification code"
    static let kNewPassword = "Please enter new password"
    static let kpasswordconfirmPasswordError = "Password and confirm password must be same"
    static let kageRestrictionError = "To use this application, Your age should be greather that 18 years"
    static let ktermsandConditionError = "Please accept terms & condition!"
    static let kEnterValidPhoneNumber = "Please enter valid phone number with country code"
    static let kCurrentPassword = "Please enter current password"
    
    
    static let kTempVideoFileName = "video.mp4"
    static let kTempImageFileNmae = "image.png"
    static let kProfilePicName = "profilepic.png"
    
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
    
    static func storeImageVideoToDocumentDirectory(rowData:NSData, name:NSString)->Bool{
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent(name as String)
        
        let stored =  rowData.writeToFile(dataPath, atomically: false)
        print(stored)
        return stored
    }
    
    static func getStoreImageVideoPath(filename:NSString)->NSString{
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent(filename as String)
        return dataPath
    }
    
    static func convertStringToArray(text:String) -> NSArray? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }

    static func convertStringToDictionary(text:String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }

}

