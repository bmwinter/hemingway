//
//  GlobalFunctions.swift
//  MIXR
//
//  Created by Michael Ciesielka on 9/22/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit

//MARK: - Convert Dictinary To Data -
//        request.HTTPBody = self.convertDicToMutableData(param)
//request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
func convertDicToMutableData(param:NSDictionary) -> NSMutableData
{
    var postData : NSMutableData?
    
    if param.count > 0 {
        for (key, value) in param {
            // DLog("\(key) : \(value)")
            
            if postData == nil {
                postData = NSMutableData(data: "\(key)=\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
            } else {
                postData!.appendData("&\(key)=\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
            }
        }
        return postData!
    }
    return postData!
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

func DLog(message: AnyObject = "",file: String = #file, line: UInt = #line , function: String = #function) {
    /*  #if DEBUG : In comment then display log
     #if DEBUG : Not comment then stop log
     */
    //#if IS_TESTING
    print("fuction:\(function) line:\(line) file:\(file) \n=================================================================================================\n \(message) ")
    // #endif
}

func Log(message: AnyObject = "",file: String = #file, line: UInt = #line , function: String = #function) {
    /*  #if DEBUG : In comment then display log
     #if DEBUG : Not comment then stop log
     */
    //#if IS_TESTING
    print("\(message) ")
    //#endif
}

func DAlert(title: String, message: String, action: String, sender: UIViewController) {
    if sender.respondsToSelector(Selector("UIAlertController")) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.Default, handler:nil))
        sender.presentViewController(alert, animated: true, completion: nil)
    } else {
        let alert = UIAlertView(title: title, message: message, delegate: sender, cancelButtonTitle:action)
        alert.show()
    }
}

//MARK: - Loader Hide/Show  -
func showLoader() {
    // stub for now -- certainly set by alamofire
//    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
}

func hideLoader() {
    // stub for now -- certainly set by alamofire
//    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
}

//MARK: - Profile Pic -
func isProfilePicExist() -> Bool {
    let fileManager = NSFileManager.defaultManager()
    
    if (fileManager.fileExistsAtPath(getProfilePicPath())) {
        return true
    }
    return false
}

func deleteProfilePic() {
    let fileManager = NSFileManager.defaultManager()
    
    let path = getProfilePicPath()
    if (fileManager.fileExistsAtPath(path)) {
        do {
            try fileManager.removeItemAtPath(path)
        } catch _ { }
    }
    
}

func deleteContactProfilePic() {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    let dataPath = paths.stringByAppendingPathComponent("ContactProfilePicture")
    if NSFileManager.defaultManager().fileExistsAtPath(dataPath) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(dataPath)
        } catch _ { }
    }
}
//MARK: - Image TO Base64 <-> Base64 TO Image -

// convert images into base64 and keep them into string

func convertImageToBase64(image: UIImage) -> String {
    
    let imageData = UIImageJPEGRepresentation(image,1.0)
    //        let imageData = UIImagePNGRepresentation(image)
    
    if imageData != nil {
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
    
    if decodedimage == nil {
        decodedimage = UIImage(named: "placeHolder")
    }
    
    return decodedimage!
    
}// end convertBase64ToImage


func getProfilePicPath() -> String {
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
func isExistUserDefaultKey(key : String) -> Bool {
    if (NSUserDefaults.standardUserDefaults().valueForKey(key) != nil) {
        return true;
    }
    return false;
}

func removeUserDefaultKey(key : String) {
    if  (NSUserDefaults.standardUserDefaults().valueForKey(key) != nil) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

func clearUserDefaultAllKey() {
    for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
    }
}

func getUserDefaultDataFromKey(key : String) -> NSMutableDictionary {
    var dic: NSMutableDictionary = NSMutableDictionary()
    
    if  (NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA) != nil) {
        dic = NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!.mutableCopy() as! NSMutableDictionary
        return dic
    }
    return dic
}

func getUserDefaultIntergerFromKey(key : String) -> Int {
    var value : Int = 0
    
    if  (NSUserDefaults.standardUserDefaults().valueForKey(key) != nil) {
        value = NSUserDefaults.standardUserDefaults().valueForKey(key) as! Int
        return value
    }
    return value
}

func getUserDefaultStringFromKey(key : String) -> String {
    var value : String = String()
    
    if  (NSUserDefaults.standardUserDefaults().valueForKey(key) != nil) {
        value = NSUserDefaults.standardUserDefaults().valueForKey(key) as! String
        return value
    }
    return value
}

func getUserDefaultDictionaryFromKey(key : String) -> NSMutableDictionary {
    var dic: NSMutableDictionary = NSMutableDictionary()
    
    if  (NSUserDefaults.standardUserDefaults().valueForKey(key) != nil) {
        dic = NSUserDefaults.standardUserDefaults().valueForKey(key)!.mutableCopy() as! NSMutableDictionary
        return dic
    }
    return dic
}

func getUserDefaultBoolFromKey(key : String) -> Bool {
    let value : Bool = false
    
    if  (NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA) != nil) {
        let dic: NSMutableDictionary = NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!.mutableCopy() as! NSMutableDictionary
        
        if(dic.isKindOfClass(NSDictionary)) {
            if (dic.valueForKey(key) != nil) {
                return dic.valueForKey(key) as! Bool
            }
        }
    }
    return value
}

func setUserDefaultDataFromKey(key : String ,dic : NSMutableDictionary) {
    if dic.isKindOfClass(NSMutableDictionary) {
        NSUserDefaults.standardUserDefaults().setObject(dic, forKey:USER_DEFAULT_LOGIN_USER_DATA)
        NSUserDefaults.standardUserDefaults().synchronize()
        DLog("\(getUserDefaultDataFromKey(USER_DEFAULT_LOGIN_USER_DATA))")
    }
}

func setUserDefaultIntergerFromKey(key : String ,value : Int) {
    NSUserDefaults.standardUserDefaults().setObject(value, forKey:key)
    NSUserDefaults.standardUserDefaults().synchronize()
}

func setUserDefaultStringFromKey(key : String ,value : String) {
    if value.isKindOfClass(NSString) {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey:key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

func setUserDefaultDictionaryFromKey(key : String ,value : NSDictionary) {
    if value.isKindOfClass(NSDictionary) {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey:key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

func setUserDefaultIntergerObjectFromKey(key : String ,object : Int) {
    if  (NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA) != nil) {
        let dic: NSMutableDictionary = NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!.mutableCopy() as! NSMutableDictionary
        
        if(dic.isKindOfClass(NSDictionary)) {
            if (dic.valueForKey(key) != nil) {
                dic.setObject(object, forKey: key)
            } else {
                dic.setObject(object, forKey: key)
            }
        }
        NSUserDefaults.standardUserDefaults().setObject(dic, forKey: USER_DEFAULT_LOGIN_USER_DATA)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        DLog(NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!)
    }
}

func setUserDefaultStringObjectFromKey(key : String ,object : String) {
    if  (NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA) != nil) {
        let dic: NSMutableDictionary = NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!.mutableCopy() as! NSMutableDictionary
        
        if(dic.isKindOfClass(NSDictionary)) {
            if (dic.valueForKey(key) != nil) {
                dic.setObject(object, forKey: key)
                
            } else {
                dic.setObject(object, forKey: key)
            }
        }
        NSUserDefaults.standardUserDefaults().setObject(dic, forKey: USER_DEFAULT_LOGIN_USER_DATA)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        DLog(NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!)
    }
}

func setUserDefaultBOOLObjectFromKey(key : String ,object : Bool) {
    if (NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA) != nil) {
        let dic: NSMutableDictionary = NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!.mutableCopy() as! NSMutableDictionary
        
        if(dic.isKindOfClass(NSDictionary)) {
            if (dic.valueForKey(key) != nil) {
                dic.setObject(object, forKey: key)
            } else {
                dic.setObject(object, forKey: key)
            }
        }
        NSUserDefaults.standardUserDefaults().setObject(dic, forKey: USER_DEFAULT_LOGIN_USER_DATA)
        NSUserDefaults.standardUserDefaults().synchronize()
        DLog(NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULT_LOGIN_USER_DATA)!)
    }
    
}
