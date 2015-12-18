//
//  APIConnection.swift
//  MIXR
//
//  Created by Sujal Bandhara on 09/12/2015.
//  Copyright (c) 2015 byPeople Technologies Pvt Limited. All rights reserved.
//

import UIKit
import Alamofire

let TIME_OUT_TIME = 60.0  // in seconds
let UseAlamofire = true

//MARK: - SERVER URL's -
let MOCK_SERVER = "http://private-9f4d0-mixr1.apiary-mock.com/"
let PRODUCTION_SERVER = "http://private-9f4d0-mixr1.apiary-mock.com/"

let BASE_URL                = MOCK_SERVER
let CONTENT_TYPE_ENCODED    = "urlencoded"
let CONTENT_TYPE_JSON       = "json"
let kAPIData                = "Data"
let kAPIAuthToken           = "APIAuthToken"
let kAPIErrorCode           =   "errorCode"

let ALERT_TITLE = "MIXR"
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

public enum Method: String
{
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

protocol APIConnectionDelegate
{
    func connectionFailedForAction(action: Int, andWithResponse result: NSDictionary!, method : String)
    
    func connectionDidFinishedForAction(action: Int, andWithResponse result: NSDictionary!, method : String)
    
    func connectionDidFinishedErrorResponceForAction(action: Int, andWithResponse result: NSDictionary!, method : String)

    func connectionDidUpdateAPIProgress(action: Int,bytesWritten: Int64, totalBytesWritten: Int64 ,totalBytesExpectedToWrite: Int64)
}

class APIConnection: NSObject {
    
    var delegate: APIConnectionDelegate! =  nil
    var param : NSDictionary?
    
    
    func CoreHTTPAuthorizationHeaderWithXAuthToken(param : NSDictionary , token : String) -> NSDictionary
    {
        let username: AnyObject? = param[kAPIUsername]
        let password: AnyObject? = param[kAPIPassword]
        var headers: NSDictionary?

        if param.count > 0 && param[kAPIPassword] != nil && param[kAPIUsername] != nil
        {
            //send x-auth token and authorization header
            let str = "\(username!):\(password!)"
            let base64Encoded = encodeStringToBase64(str)
            
             headers = [
                //"Content-Type":"application/json, charset=utf-8",
                //"Authorization": "Bearer \(token)"
                "x-auth": token,
                "authorization": "Basic \(base64Encoded)"
            ]
        }
        else
        {
            //send x-auth token
             headers = ["x-auth": token]
        }
        return headers!
    }
    
//    func SocialCoreHTTPAuthorizationHeaderWithXAuthToken(param : NSDictionary , token : String) -> NSDictionary
//    {
//        let socialType: AnyObject? = param[kAPISocialType]
//        let socialId: AnyObject? = param[kAPISocialId]
//        let socialToken: AnyObject? = param[kAPISocialToken]
//
//        var headers: NSDictionary?
//        
//        if param.count > 0 && param[kAPISocialType] != nil && param[kAPISocialId] != nil && param[kAPISocialToken] != nil
//        {
//            //send x-auth token and authorization header
//            let str = "\(socialType!)_\(socialId!):\(socialToken!)"
//            let base64Encoded = encodeStringToBase64(str)
//            
//            headers = [
//                "x-auth": token,
//                "authorization": "Basic \(base64Encoded)"
//            ]
//        }
//        else
//        {
//            //send x-auth token
//            headers = ["x-auth": token]
//        }
//        return headers!
//    }

    func addQueryStringToUrl(url : String, param : NSDictionary) -> String
    {
        var queryString : String = url
        
        if param.count > 0
        {
            for (key, value) in param {
                
                DLog("\(key) = \(value)")

                if queryString.rangeOfString("?") == nil
                {
                    queryString = queryString.stringByAppendingString("?\(key)=\(value)")
                }
                else
                {
                   queryString = queryString.stringByAppendingString("&\(key)=\(value)")

                }
            }
            DLog("\(queryString)")
            return queryString
            
        }
        return queryString

    }
    func GET(action: Int,withAPIName apiName: String, andMessage message: String, param:NSDictionary, withProgresshudShow isProgresshudShow: CBool,  isShowNoInternetView: CBool , token : String) -> AnyObject
    {
        if isProgresshudShow == true
        {
            showLoader()
        }
        
        let headers: NSDictionary  = CoreHTTPAuthorizationHeaderWithXAuthToken(param, token: token)
        
        let request = NSMutableURLRequest(URL: NSURL(string: self.addQueryStringToUrl( BASE_URL +  apiName ,param: param))!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: TIME_OUT_TIME)
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = headers as? [String : String] 
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
          
            let httpResponse = response as? NSHTTPURLResponse

            /*if (error != nil) {
                print(error)
            } else {
                print(httpResponse)
            }*/
            
            dispatch_async(dispatch_get_main_queue()) {
                 self.coreResponseHandling(request, response: httpResponse, json: data, error: error, action: action, method : Method.GET.rawValue)
            }

        })
        
        dataTask.resume()
        return self
    }
    
    func PUT(action: Int,withAPIName apiName: String, andMessage message: String, param:[String:AnyObject], withProgresshudShow isProgresshudShow: CBool,  isShowNoInternetView: CBool , token : String) -> AnyObject
    {
        if isProgresshudShow == true
        {
            showLoader()
        }
        let headers: NSDictionary  = CoreHTTPAuthorizationHeaderWithXAuthToken(param, token: token)
        
        let request = NSMutableURLRequest(URL: NSURL(string: BASE_URL +  apiName)!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval:TIME_OUT_TIME)
        request.HTTPMethod = "PUT"
        request.allHTTPHeaderFields = headers as? [String : String] 
       /* request.HTTPBody = self.convertDicToMutableData(param)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")*/
        request.HTTPBody =  try? NSJSONSerialization.dataWithJSONObject(param, options: NSJSONWritingOptions())
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        DLog(request.allHTTPHeaderFields!)

        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            let httpResponse = response as? NSHTTPURLResponse

            /*if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? NSHTTPURLResponse
                print(httpResponse)
            }*/
            dispatch_async(dispatch_get_main_queue()) {
                self.coreResponseHandling(request, response: httpResponse, json: data, error: error, action: action, method : Method.PUT.rawValue)
            }
        })
        
        dataTask.resume()
        
        return self
    }
    
    func POST(action: Int, withAPIName apiName: String, withMessage message: String, withParam param: [String:AnyObject], withProgresshudShow isProgresshudShow: CBool,  isShowNoInternetView: CBool) -> AnyObject
    {
        if isProgresshudShow == true
        {
           showLoader()
        }
        let apiURL = BASE_URL +  apiName;
        DLog("apiURL = \(apiURL)")
        
        if(UseAlamofire)
        {
//            Alamofire.request(.POST, apiURL).response
//                .responseJSON { _, _, result in
//                    print(result)
//                    debugPrint(result)
//            }
        }
        else
        {
            let request = NSMutableURLRequest(URL: NSURL(string: apiURL)!,
                cachePolicy: .UseProtocolCachePolicy,
                timeoutInterval: TIME_OUT_TIME)
            request.HTTPMethod = "POST"
            request.HTTPBody =  try? NSJSONSerialization.dataWithJSONObject(param , options: NSJSONWritingOptions())
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                let httpResponse = response as? NSHTTPURLResponse
                
                /* if (error != nil) {
                print(error)
                } else {
                let httpResponse = response as? NSHTTPURLResponse
                print(httpResponse)
                }*/
                dispatch_async(dispatch_get_main_queue()) {
                    self.coreResponseHandling(request, response: httpResponse, json: data, error: error, action: action, method : Method.POST.rawValue)
                }
                
            })
            
            dataTask.resume()
        }
        return self
    }

    func POST_WITH_HEADER(action: Int,withAPIName apiName: String, andMessage message: String, param:NSDictionary,paramHeader:NSDictionary, withProgresshudShow isProgresshudShow: CBool,  isShowNoInternetView: CBool , token : String, ContentType : String) -> AnyObject
    {
        if isProgresshudShow == true
        {
            showLoader()
        }

        let headers: NSDictionary  = CoreHTTPAuthorizationHeaderWithXAuthToken(paramHeader, token: token)
        
        let request = NSMutableURLRequest(URL: NSURL(string: BASE_URL +  apiName)!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: TIME_OUT_TIME)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = headers as? [String : String]
        
        if ContentType == CONTENT_TYPE_ENCODED
        {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            if param.count > 0
            {
                request.HTTPBody = self.convertDicToMutableData(param)
            }
        }                    
        else
        {
            //json
            if param[kAPIData] != nil
            {
                request.HTTPBody =  try? NSJSONSerialization.dataWithJSONObject(param[kAPIData]! , options: NSJSONWritingOptions())
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                

            }
            else
            {
                request.HTTPBody =  try? NSJSONSerialization.dataWithJSONObject(param , options: NSJSONWritingOptions())
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")

            }
        }
  
        DLog(request.allHTTPHeaderFields!)

        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
           
            let httpResponse = response as? NSHTTPURLResponse

            /*if (error != nil) {
                print(error)
            } else {

                print(httpResponse)
            }*/
            dispatch_async(dispatch_get_main_queue()) {
                self.coreResponseHandling(request, response: httpResponse, json: data, error: error, action: action, method : Method.POST.rawValue)
            }

        })
        dataTask.resume()
        return self
    }
    


    func DELETE(action: Int,withAPIName apiName: String, andMessage message: String, param:NSDictionary,paramHeader:NSDictionary, withProgresshudShow isProgresshudShow: CBool,  isShowNoInternetView: CBool , token : String) -> AnyObject
    {
        if isProgresshudShow == true
        {
            showLoader()
        }
       
        let headers: NSDictionary  = CoreHTTPAuthorizationHeaderWithXAuthToken(paramHeader, token: token)
        
        let request = NSMutableURLRequest(URL: NSURL(string: BASE_URL +  apiName)!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: TIME_OUT_TIME)
        request.HTTPMethod = "DELETE"
        request.allHTTPHeaderFields = headers as? [String : String]
        DLog(request.allHTTPHeaderFields!)
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            let httpResponse = response as? NSHTTPURLResponse

           /* if (error != nil) {
                print(error)
            } else {
                print(httpResponse)
            }*/
            dispatch_async(dispatch_get_main_queue()) {
                self.coreResponseHandling(request, response: httpResponse, json: data, error: error, action: action, method :Method.DELETE.rawValue )
            }

        })
        
        dataTask.resume()
        return self
    }

    func UPLOAD_PROFILE_PIC(action: Int, withAPIName apiName: String, withMessage message: String, withParam param:NSDictionary, withProgresshudShow isProgresshudShow: CBool,  isShowNoInternetView: CBool, token : String) -> AnyObject
    {
        
        if isProgresshudShow == true
        {
            showLoader()
        }
        let headers: NSDictionary  = CoreHTTPAuthorizationHeaderWithXAuthToken(param, token: token)
       
        if isProfilePicExist()
        {
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

               /* if (error != nil) {
                    print(error)
                } else {
                    print(httpResponse)
                }*/
                dispatch_async(dispatch_get_main_queue()) {
                    self.coreResponseHandling(request, response: httpResponse, json: data, error: error, action: action, method : Method.PUT.rawValue)
                }
            })
            
            dataTask.resume()

        }
        
        return self
    }
    //MARK: - Respose Handling -
    func coreResponseHandling(request: NSURLRequest,response: NSHTTPURLResponse?,json: NSData!,error: NSError?,action: Int,method : String)
    {
        //DLog("Stop loading \(action)")
        hideLoader()
        
        if(error != nil)
        {
            DLog("\(error!.localizedDescription) res:\(response?.statusCode)")
            
            if(response == nil)
            {
                if let delegate = self.delegate
                {
                    delegate.connectionFailedForAction(action, andWithResponse: nil, method : method)
                }
            }
            else
            {
                if let delegate = self.delegate
                {
                    delegate.connectionFailedForAction(action, andWithResponse: nil, method : method)
                }
                
            }
        }
        else
        {
            DLog("req:\(request) \n res:\(response?.statusCode) \n \(error) ")
            
            if ((response?.statusCode == 200) || (response?.statusCode == 201))
            {
                var dic : NSDictionary = NSDictionary()
                var string : String = String()
                
                if (json  != nil)
                {
                    //String
                    do {
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments) as? String
                        // use anyObj here
                        if (jsonResult != nil && jsonResult?.characters.count > 0)
                        {
                            DLog(jsonResult!)
                            
                            if ( jsonResult!.isKindOfClass(NSString))
                            {
                                string = jsonResult!
                                
                                if (action == APIName.AuthenticationTokens.rawValue) || (action == APIName.Venues.rawValue)
                                {
                                    let myDict:NSDictionary = [kAPIAuthToken : string]
                                    dic = myDict
                                    
                                }
                                DLog(string)
                            }
                        }
                        
                    } catch
                    {
                        print(error)
                        DLog(ALERT_TITLE_404 + ALERT_404_FOUND)

                    }
                    
                    //NSDictinary
                    do {
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                        // use anyObj here
                        if (( jsonResult?.isKindOfClass(NSDictionary)) != nil)
                        {
                            //DLog(jsonResult)
                            
                            dic = jsonResult!
                        }
                        
                    } catch {
                        print(error)
                        DLog(ALERT_TITLE_404 + ALERT_404_FOUND)

                    }
                    
                    //Array
                    do {
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments) as? NSArray
                        // use anyObj here
                        if (( jsonResult?.isKindOfClass(NSArray)) != nil)
                        {
                            DLog(jsonResult!)
                            
                            let dicMutable : NSMutableDictionary = NSMutableDictionary()
                            dicMutable.setObject(jsonResult!, forKey: kAPIData)
                            dic = dicMutable as NSDictionary
                        }
                        
                        
                    } catch {
                        print(error)
                        DLog(ALERT_TITLE_404 + ALERT_404_FOUND)

                    }
                    
                    
                    if let delegate = self.delegate
                    {
                        delegate.connectionDidFinishedForAction(action, andWithResponse: dic,method : method)
                    }
                }
            }
            else
            {
                var dic : NSDictionary = NSDictionary()
                
                if (json  != nil)
                {
                    do {
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(json, options: []) as! [NSDictionary:AnyObject]
                        
                        if jsonResult.count > 0
                        {
                            dic = jsonResult as NSDictionary
                            DLog(dic)
                            //AccessDenied
                            if(response?.statusCode == 400 && dic[kAPIErrorCode] as? String == "AccessDenied")//GenericError
                            {
                                if appDelegate.navigationController != nil
                                {
                                    //Check for if kAPIAuthToken is available then session is running otherwise session time out.
                                    let dicLoginData: NSMutableDictionary = getUserDefaultDataFromKey(USER_DEFAULT_LOGIN_USER_DATA)
                                    
                                    if(dicLoginData.isKindOfClass(NSDictionary))
                                    {
                                        if dicLoginData.valueForKey(kAPIAuthToken) != nil
                                        {
                                            let alert = UIAlertView()
                                            alert.title = ALERT_TITLE
                                            alert.message = ALERT_SESSION_TIME_OUT
                                            alert.addButtonWithTitle(ALERT_OK)
                                            alert.show()
                                            
                                            //appDelegate.navigationController?.popToRootViewControllerAnimated(true)
                                            //BaseVC.sharedInstance.popForcefullyLoginScreenWhenSessionTimeOutWithClassName(WelComeStep1aLoginVC(), identifier:"WelComeStep1aLoginVC" , animated: true, animationType: AnimationType.Default)
                                        }
                                    }
                                }
                            }
                            else
                            {
                                if let delegate = self.delegate
                                {
                                    delegate.connectionDidFinishedErrorResponceForAction(action, andWithResponse: dic,method: method )
                                }
                            }
                        }
                        
                        
                        // use anyObj here
                    } catch {
                        print(error)
                        DLog(ALERT_TITLE_404 + ALERT_404_FOUND)
                       //DAlert(ALERT_TITLE_404, message: ALERT_404_FOUND, action: ALERT_OK, sender:(appDelegate.navigationController?.topViewController)!)//\(jsonParseError.localizedDescription)
                        
                    }
                    
                }
                else
                {
                    //static
                    if let delegate = self.delegate
                    {
                        delegate.connectionDidFinishedForAction(action, andWithResponse: dic,method : method)
                    }
                }
            }
        }
    }
    

    
    //MARK: - Convert Dictinary To Data -
    //        request.HTTPBody = self.convertDicToMutableData(param)
    //request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    func convertDicToMutableData(param:NSDictionary) -> NSMutableData
    {
        var postData : NSMutableData?
        
        if param.count > 0
        {
            for (key, value) in param
            {
               // DLog("\(key) : \(value)")

                if postData == nil
                {
                    postData = NSMutableData(data: "\(key)=\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
                }
                else
                {
                    postData!.appendData("&\(key)=\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
                }
            }
            return postData!
            
        }
        return postData!
    }

}

//MARK: - BASE64 To String & String To Base64 -
func encodeStringToBase64(str : String) -> String
{
    // UTF 8 str from original
    // NSData! type returned (optional)
    let utf8str = str.dataUsingEncoding(NSUTF8StringEncoding)
    
    // Base64 encode UTF 8 string
    // fromRaw(0) is equivalent to objc 'base64EncodedStringWithOptions:0'
    // Notice the unwrapping given the NSData! optional
    // NSString! returned (optional)
    let base64Encoded = utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    // DLog("Encoded:  \(base64Encoded)")
    
    /*// Base64 Decode (go back the other way)
    // Notice the unwrapping given the NSString! optional
    // NSData returned
    let data = NSData(base64EncodedString: base64Encoded, options: NSDataBase64DecodingOptions(rawValue: 0))
    
    // Convert back to a string
    let base64Decoded = NSString(data: data!, encoding: NSUTF8StringEncoding)
    DLog("Decoded:  \(base64Decoded)")*/
    
    
    return base64Encoded;
}

//MARK: - DLog -

func DLog(message: AnyObject = "",file: String = __FILE__, line: UInt = __LINE__ , function: String = __FUNCTION__)
{
    /*  #if DEBUG : In comment then display log
    #if DEBUG : Not comment then stop log
    */
    //#if IS_TESTING
        print("fuction:\(function) line:\(line) file:\(file) \n=================================================================================================\n \(message) ")
   // #endif
}

func Log(message: AnyObject = "",file: String = __FILE__, line: UInt = __LINE__ , function: String = __FUNCTION__)
{
    /*  #if DEBUG : In comment then display log
    #if DEBUG : Not comment then stop log
    */
    //#if IS_TESTING
        print("\(message) ")
    //#endif
}

func DAlert(title: String, message: String, action: String, sender: UIViewController)
{
    if sender.respondsToSelector("UIAlertController")
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.Default, handler:nil))
        sender.presentViewController(alert, animated: true, completion: nil)
    }
    else
    {
        let alert = UIAlertView(title: title, message: message, delegate: sender, cancelButtonTitle:action)
        alert.show()
    }
}

//MARK: - Loader Hide/Show  -
func showLoader()
{
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
}

func hideLoader()
{
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
}

//MARK: - Profile Pic -
func isProfilePicExist() -> Bool
{
    let fileManager = NSFileManager.defaultManager()
    
    if (fileManager.fileExistsAtPath(getProfilePicPath()))
    {
        return true
    }
    return false
}

func deleteProfilePic()
{
    let fileManager = NSFileManager.defaultManager()
    
    let path = getProfilePicPath()
    if (fileManager.fileExistsAtPath(path))
    {
        do {
            try fileManager.removeItemAtPath(path)
        } catch _ {
        }
    }
    
}
func deleteContactProfilePic()
{
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    
    let dataPath = paths.stringByAppendingPathComponent("ContactProfilePicture")
    
    if NSFileManager.defaultManager().fileExistsAtPath(dataPath)
    {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(dataPath)
        } catch _ {
        }
        
    }
}
//MARK: - Image TO Base64 <-> Base64 TO Image -

// convert images into base64 and keep them into string

func convertImageToBase64(image: UIImage) -> String {
    
    let imageData = UIImageJPEGRepresentation(image,1.0)
    //        let imageData = UIImagePNGRepresentation(image)
    
    if imageData != nil
    {
        let base64String = imageData!.base64EncodedStringWithOptions([.Encoding64CharacterLineLength, .EncodingEndLineWithCarriageReturn])
        
        return base64String
        
    }
    return ""
    
}// end convertImageToBase64


// convert images into base64 and keep them into string

func convertBase64ToImage(base64String: String) -> UIImage {
    
    //        let decodedData = NSData(base64EncodedString: base64String, options:NSDataBase64DecodingOptions(rawValue: 0))
    //        let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
    var decodedimage = UIImage(named: "placeHolder")
    
    if let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions(rawValue: 0)) {
        decodedimage = UIImage(data: decodedData)
        
    } else {
        print("Not Base64")
    }
    if decodedimage == nil
    {
        decodedimage = UIImage(named: "placeHolder")
    }
    return decodedimage!
    
}// end convertBase64ToImage


func getProfilePicPath() -> String
{
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    
    let path = paths.stringByAppendingPathComponent("ProfilePic.png")
    
    return path
    
}

extension String {
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
}
//MARK: - UserDefault Operation -
func isExistUserDefaultKey(key : String) -> Bool
{
    if  (NSUserDefaults.standardUserDefaults().valueForKey(key) != nil)
    {
        return true;
    }
    return false;
}

func removeUserDefaultKey(key : String)
{
    if  (NSUserDefaults.standardUserDefaults().valueForKey(key) != nil)
    {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

func clearUserDefaultAllKey()
{
    for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
    }
}

func getUserDefaultDataFromKey(key : String) -> NSMutableDictionary
{
    var dic: NSMutableDictionary = NSMutableDictionary()
    
    if  (NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA) != nil)
    {
        dic = NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!.mutableCopy() as! NSMutableDictionary
        return dic
    }
    return dic
}
func getUserDefaultIntergerFromKey(key : String) -> Int
{
    var value : Int = 0
    
    if  (NSUserDefaults.standardUserDefaults().valueForKey(key) != nil)
    {
        value = NSUserDefaults.standardUserDefaults().valueForKey(key) as! Int
        return value
    }
    return value
}

func getUserDefaultStringFromKey(key : String) -> String
{
    var value : String = String()
    
    if  (NSUserDefaults.standardUserDefaults().valueForKey(key) != nil)
    {
        value = NSUserDefaults.standardUserDefaults().valueForKey(key) as! String
        return value
    }
    return value
}
func getUserDefaultDictionaryFromKey(key : String) -> NSMutableDictionary
{
    var dic: NSMutableDictionary = NSMutableDictionary()
    
    if  (NSUserDefaults.standardUserDefaults().valueForKey(key) != nil)
    {
        dic = NSUserDefaults.standardUserDefaults().valueForKey(key)!.mutableCopy() as! NSMutableDictionary
        return dic
    }
    return dic
}

func getUserDefaultBoolFromKey(key : String) -> Bool
{
    let value : Bool = false
    
    if  (NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA) != nil)
    {
        let dic: NSMutableDictionary = NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!.mutableCopy() as! NSMutableDictionary
        
        if(dic.isKindOfClass(NSDictionary))
        {
            if (dic.valueForKey(key) != nil)
            {
                return dic.valueForKey(key) as! Bool
            }
        }
    }
    return value
}

func setUserDefaultDataFromKey(key : String ,dic : NSMutableDictionary)
{
    if dic.isKindOfClass(NSMutableDictionary)
    {
        NSUserDefaults.standardUserDefaults().setObject(dic, forKey:USER_DEFAULT_LOGIN_USER_DATA)
        NSUserDefaults.standardUserDefaults().synchronize()
        DLog("\(getUserDefaultDataFromKey(USER_DEFAULT_LOGIN_USER_DATA))")
    }
}
func setUserDefaultIntergerFromKey(key : String ,value : Int)
{
    NSUserDefaults.standardUserDefaults().setObject(value, forKey:key)
    NSUserDefaults.standardUserDefaults().synchronize()
}

func setUserDefaultStringFromKey(key : String ,value : String)
{
    if value.isKindOfClass(NSString)
    {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey:key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
func setUserDefaultDictionaryFromKey(key : String ,value : NSDictionary)
{
    if value.isKindOfClass(NSDictionary)
    {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey:key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

func setUserDefaultIntergerObjectFromKey(key : String ,object : Int)
{
    if  (NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA) != nil)
    {
        let dic: NSMutableDictionary = NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!.mutableCopy() as! NSMutableDictionary
        
        if(dic.isKindOfClass(NSDictionary))
        {
            if (dic.valueForKey(key) != nil)
            {
                dic.setObject(object, forKey: key)
                
            }
            else
            {
                dic.setObject(object, forKey: key)
            }
        }
        NSUserDefaults.standardUserDefaults().setObject(dic, forKey: USER_DEFAULT_LOGIN_USER_DATA)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        DLog(NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!)
    }
    
}

func setUserDefaultStringObjectFromKey(key : String ,object : String)
{
    if  (NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA) != nil)
    {
        let dic: NSMutableDictionary = NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!.mutableCopy() as! NSMutableDictionary
        
        if(dic.isKindOfClass(NSDictionary))
        {
            if (dic.valueForKey(key) != nil)
            {
                dic.setObject(object, forKey: key)
                
            }
            else
            {
                dic.setObject(object, forKey: key)
            }
        }
        NSUserDefaults.standardUserDefaults().setObject(dic, forKey: USER_DEFAULT_LOGIN_USER_DATA)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        DLog(NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!)
    }
    
}

func setUserDefaultBOOLObjectFromKey(key : String ,object : Bool)
{
    if  (NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA) != nil)
    {
        let dic: NSMutableDictionary = NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!.mutableCopy() as! NSMutableDictionary
        
        if(dic.isKindOfClass(NSDictionary))
        {
            if (dic.valueForKey(key) != nil)
            {
                dic.setObject(object, forKey: key)
                
            }
            else
            {
                dic.setObject(object, forKey: key)
            }
        }
        NSUserDefaults.standardUserDefaults().setObject(dic, forKey: USER_DEFAULT_LOGIN_USER_DATA)
        NSUserDefaults.standardUserDefaults().synchronize()
        DLog(NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!)
    }
    
}
