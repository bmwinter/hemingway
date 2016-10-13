//
//  APIConnection.swift
//  MIXR
//
//  Created by Sujal Bandhara on 09/12/2015.
//  Copyright (c) 2015 byPeople Technologies Pvt Limited. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

import SpringIndicator

let TIME_OUT_TIME = 60.0  // in seconds
let UseAlamofire = true

//MARK: - SERVER URL's -
let IP_SERVER = "http://54.174.249.237/"
let MOCK_SERVER = "http://private-9f4d0-mixr1.apiary-mock.com/"
let PRODUCTION_SERVER = "http://private-9f4d0-mixr1.apiary-mock.com/"

let BASE_URL                = IP_SERVER
let CONTENT_TYPE_ENCODED    = "urlencoded"
let CONTENT_TYPE_JSON       = "json"
let kAPIData                = "Data"
let kAPIAuthToken           = "APIAuthToken"
let kAPIErrorCode           =  "errorCode"

let ALERT_TITLE             = "MIXR"
let ALERT_OK                = "OK"
let ALERT_CANCEL            = "Cancel"
let ALERT_NO                = "No"
let ALERT_YES               = "Yes"
let ALERT_TITLE_404         = "404 - File or directory not found"
let ALERT_404_FOUND         = "HTTP standard response code indicating that the client was able to communicate with a given server, but the server could not find what was requested."
let ALERT_SESSION_TIME_OUT  = "Session Timeout. Please login again."

let USER_DEFAULT_LOGIN_USER_DATA =   "loginUserData"

let kAPIUsername            = "Username"
let kAPIPassword            = "Password"
let IS_TESTING              = true

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
var appHeader: NSDictionary = ["":""]

typealias MIXRResponseSuccessClosure = (response: JSON) -> Void
typealias MIXRResponseFailureClosure = (error: ErrorType) -> Void

public enum MixrMethod: String {
    case OPTIONS    = "OPTIONS"
    case GET        = "GET"
    case HEAD       = "HEAD"
    case POST       = "POST"
    case PUT        = "PUT"
    case PATCH      = "PATCH"
    case DELETE     = "DELETE"
    case TRACE      = "TRACE"
    case CONNECT    = "CONNECT"
}

enum MixrError: Int {
    case StandardError = 0
}

enum APIAction: String {
    // Login Flow
    case Login
    case Signup
    case GetVerificationCode
    case ConfirmVerificationCode
    case PasswordRecover
    case PasswordRecoverChange
    case PasswordChange
    
    case ProfileUser
    case ProfileUpdate
    case ProfileOther
    case ProfileVenue
    case ProfileVenueSpecial
    case ProfileVenueEvent
    case VenueDetails
    
    case Notifications
    case Promotions
    
    case Settings
    
    case Search
    
    case Following
    case Followers
    case FollowRequest
    case FollowRequestForVenue
    case FollowRequestUpdate
    case FollowStatusForUser
    case FollowStatusForVenue
    
    case VenueCoordinates

    case Post
    
    case Newsfeed
    case NewsfeedUser
    case MyNewsfeed
    case NewsfeedVenue
    case NewsfeedAll
    
    case ProfilePrivacy
    case LikePost
    case Venues
    
    var requiresAuthToken: Bool {
        switch self {
        case .Signup, .GetVerificationCode, .ConfirmVerificationCode, .PasswordRecover, .PasswordRecoverChange, .Login, .ProfileVenue, .ProfileVenueSpecial, .ProfileVenueEvent:
            return false
        default:
            return true
        }
    }
    
    var completeURLString: String {
        return "\(BASE_URL)\(apiURI)"
    }
    
    var apiURI: String {
        switch self {
        case .Login:
            return "login"
        case .Signup:
            return "register"
        case .GetVerificationCode:
            return "confirmation"
        case .ConfirmVerificationCode:
            return "confirmation/check"
        case .PasswordRecover:
            return "password/recover"
        case .PasswordRecoverChange:
            return "password/recover/change"
        case .PasswordChange:
            return "password/change"
            
        case .ProfileUser:
            return "UserProfile"
        case .ProfileUpdate:
            return "profile"
        case .ProfileOther:
            return "profile/other"
        case .ProfileVenue:
            return "profile/venue"
            
        case .ProfileVenueSpecial:
            return "venue/specials"
        case .ProfileVenueEvent:
            return "venue/events"
        case .VenueDetails:
            return "VenueDetails"
            
        case .Notifications:
            return "Notifications"
        case .Promotions:
            return "Promotions"
        case .Settings:
            return "UserSettings"
            
        case .Search:
            return "search"
            
        case .Following:
            return "following"
        case .Followers:
            return "followers"
        case .FollowRequest:
            return "follow/request"
        case .FollowRequestForVenue:
            return "follow/request/venue"
        case .FollowRequestUpdate:
            return "follow/request/update"
        case .FollowStatusForUser:
            return "follow/status/user"
        case .FollowStatusForVenue:
            return "follow/status/venue"
            
        case .Newsfeed:
            return "newsfeed"
        case .NewsfeedUser:
            return "newsfeed/user"
        case .MyNewsfeed:
            return "newsfeed/my"
        case .NewsfeedVenue:
            return "newsfeed/venue"
        case .NewsfeedAll:
            return "newsfeed"
            
        case .VenueCoordinates:
            return "venue"
            
        case .Post:
            return "post"
        case .ProfilePrivacy:
            return "profile/public"
        case .LikePost:
            return "post/like"
        case .Venues:
            return "venue"
        }
    }
}

protocol APIConnectionDelegate: class {
    func connectionFailedForAction(action: APIAction, andWithResponse result: Dictionary <String, JSON>!, method : String)
    func connectionDidFinishedForAction(action: APIAction, andWithResponse result: Dictionary <String, JSON>!, method : String)
    func connectionDidFinishedErrorResponceForAction(action: APIAction, andWithResponse result: Dictionary <String, JSON>!, method : String)
    func connectionDidUpdateAPIProgress(action: APIAction,bytesWritten: Int64, totalBytesWritten: Int64 ,totalBytesExpectedToWrite: Int64)
}

enum APIError: ErrorType {
    case NoAuthToken
    case Failure(response: JSON)
    case UnknownError
}

class APIConnection: NSObject, SpringIndicatorTrait {
    
    var springIndicator: SpringIndicator? = SpringIndicator()
    let sessionManager = Alamofire.Manager()
    
    weak var delegate: APIConnectionDelegate? {
        return nil
    }
    
    func CoreHTTPAuthorizationHeaderWithXAuthToken(param : NSDictionary , token : String) -> NSDictionary {
//        let username: AnyObject? = param[kAPIUsername]
//        let password: AnyObject? = param[kAPIPassword]
//        var headers: NSDictionary?
//        
//        if param.count > 0 && param[kAPIPassword] != nil && param[kAPIUsername] != nil {
//            //send x-auth token and authorization header
//            let str = "\(username!):\(password!)"
//            let base64Encoded = encodeStringToBase64(str)
//            
//            headers = [
//                //"Content-Type":"application/json, charset=utf-8",
//                //"Authorization": "Bearer \(token)"
//                "x-auth": token,
//                "authorization": "Basic \(base64Encoded)"
//            ]
//        } else {
//            //send x-auth token
//            headers = ["x-auth": token]
//        }
//        
//        appHeader = headers!
//        return headers!
        return NSDictionary()
    }
    
    func addQueryStringToUrl(url : String, param : NSDictionary) -> String {
        var queryString : String = url
        
        if param.count > 0 {
            for (key, value) in param {
                
                DLog("\(key) = \(value)")
                
                if queryString.rangeOfString("?") == nil {
                    queryString = queryString.stringByAppendingString("?\(key)=\(value)")
                } else {
                    queryString = queryString.stringByAppendingString("&\(key)=\(value)")
                }
            }
            DLog("\(queryString)")
            return queryString
        }
        return queryString
    }
    
}

// MARK: core api functions
extension APIConnection {

    func POST(action: APIAction, params: [String: AnyObject]?, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) throws {
        try API(Method.POST, action: action, params: params, success: success, failure: failure)
    }
    
    func GET(action: APIAction, params: [String: AnyObject]?, withHeader isHeaderNeeded: Bool, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure) throws {
        try API(Method.GET, action: action, params: params, success: success, failure: failure)
    }
    
    func API(type: Alamofire.Method, action: APIAction, params: [String: AnyObject]?, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) throws {
        let isHeaderNeeded = action.requiresAuthToken
        let apiURL = action.completeURLString
        
        let sharedCompletion = { [weak self] (response: Response<String, NSError>, action: APIAction) in
            self?.hideSpringIndicator()
            self?.processResponse(response, action: action, success: success, failure: failure)
        }
        
        showSpringIndicator()
        
        if(UseAlamofire) {
            if (!isHeaderNeeded) {
                sessionManager.request(type, apiURL, parameters: params, encoding: .JSON).responseString { response in
                    sharedCompletion(response, action)
                }
            } else {
                guard let authToken =  AppPersistedStore.sharedInstance.authToken else {
                    throw APIError.NoAuthToken
                }
                let tokenString = "token \(authToken)"
                sessionManager.request(type, apiURL, parameters: params, encoding: .JSON, headers: ["Authorization": tokenString]).responseString { response in
                    sharedCompletion(response, action)
                }
            }
        } else {
            let request = NSMutableURLRequest(URL: NSURL(string: apiURL)!,
                cachePolicy: .UseProtocolCachePolicy,
                timeoutInterval: TIME_OUT_TIME)
            request.HTTPMethod = "POST"
            request.HTTPBody =  try? NSJSONSerialization.dataWithJSONObject(params ?? [:] , options: NSJSONWritingOptions())
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            if(isHeaderNeeded) {
                request.allHTTPHeaderFields = appHeader as? [String : String]
            }
            
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                let httpResponse = response as? NSHTTPURLResponse
                
                let jsonResponse = JSON(data!)
                dispatch_async(dispatch_get_main_queue()) {
                    self.coreResponseHandling(request, response: httpResponse, jsonResponse: jsonResponse, error: error, action: action, method : Method.POST.rawValue, success: success, failure: failure)
                }
            })
            
            dataTask.resume()
        }
    }
}

// MARK: Response Handling
extension APIConnection {
    func processResponse(response: Response<String, NSError>, action: APIAction, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        
        if true {
            print("Request Header: \(response.request?.allHTTPHeaderFields)")
            print("Request:\(response.request)")  // original URL request
            print("Response: \(response.response)") // URL response
//            print("Data: \(response.data)")     // server data
            print("Result: \(response.result)")   // result of response serialization
        }
        
        
        switch response.result {
        case .Success(let value):
            // TODO: check out errors here
            let jsonResponse = JSON.parse(value)
            dispatch_async(dispatch_get_main_queue()) {
                success?(response: jsonResponse)
            }
        case .Failure(let error):
            dispatch_async(dispatch_get_main_queue()) {
                failure?(error: error)
            }
        }
        
    }
    
    /// DEPRECATED
    func coreResponseHandling(request: NSURLRequest,
                              response: NSHTTPURLResponse?,
                              jsonResponse: JSON,
                              error: NSError?,
                              action: APIAction,
                              method: String,
                              success: MIXRResponseSuccessClosure?,
                              failure: MIXRResponseFailureClosure?) {
        hideLoader()
        
        if(error != nil) {
            DLog("\(error!.localizedDescription) res:\(response?.statusCode)")
            
            if(response == nil) {
                if let delegate = self.delegate {
                    delegate.connectionFailedForAction(action, andWithResponse: nil, method : method)
                }
            } else {
                if let delegate = self.delegate {
                    delegate.connectionFailedForAction(action, andWithResponse: nil, method : method)
                }
            }
        } else {
            DLog("req:\(request) \n res:\(response?.statusCode) \n \(error) ")
            
            if ((response?.statusCode == 200) || (response?.statusCode == 201)) {
                //let json = JSON(data: jsonResponse)
                
                //If not a Dictionary or nil, return [:]
                let dic: Dictionary <String, JSON> = jsonResponse.dictionaryValue
                //                var dic : NSDictionary = NSDictionary()
                
                if let delegate = self.delegate
                {
                    delegate.connectionDidFinishedForAction(action, andWithResponse: dic,method : method)
                }
                return
            }
        }
    }
}

// MARK: loading indicator
extension APIConnection {
    func showSpringIndicator() {
        if let topVC = appDelegate.visibleViewController {
            addSpringIndicatorToView(topVC.view)
            startAnimatingSpringIndicator()
        }
    }
    
    func hideSpringIndicator() {
        stopAnimatingSpringIndicator()
        springIndicator?.removeFromSuperview()
        springIndicator = nil
    }
}

// MARK: misc unused code
extension APIConnection {
    // TODO: this is unused why is it here?
    func UPLOAD_PROFILE_PIC(action: APIAction,
                            withAPIName apiName: String,
                                        withMessage message: String,
                                                    withParam param: NSDictionary,
                                                              withProgresshudShow isProgresshudShow: CBool,
                                                                                  isShowNoInternetView: CBool,
                                                                                  token: String) -> AnyObject {
        
        if isProgresshudShow == true {
            showLoader()
        }
        let headers: NSDictionary  = CoreHTTPAuthorizationHeaderWithXAuthToken(param, token: token)
        
        if isProfilePicExist() {
            let image: UIImage = UIImage(contentsOfFile: getProfilePicPath())!
            
            let base64String = convertImageToBase64(image)
            
            let param = ["ImageData" : "\(base64String)"]
            
            //let postData = NSMutableData(data: "ImageData=\(base64String)".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            DLog("ImageData=\(base64String)")
            
            let request = NSMutableURLRequest(URL: NSURL(string: BASE_URL +  apiName)!,
                                              cachePolicy: .UseProtocolCachePolicy,
                                              timeoutInterval: TIME_OUT_TIME)
            request.HTTPMethod = "PUT"
            request.allHTTPHeaderFields = headers as? [String : String]
            request.HTTPBody =  try? NSJSONSerialization.dataWithJSONObject(param , options: NSJSONWritingOptions())
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            DLog(request.allHTTPHeaderFields!)
            
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                let httpResponse = response as? NSHTTPURLResponse
                
                let jsonResponse = JSON(data!)
                dispatch_async(dispatch_get_main_queue())
                {
                    self.coreResponseHandling(request, response: httpResponse, jsonResponse: jsonResponse, error: error, action: action, method : Method.POST.rawValue, success: nil, failure: nil)
                }
            })
            
            dataTask.resume()
        }
        
        return self
    }
}
