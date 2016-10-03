//
//  APIManager.swift
//  MIXR
//
//  Created by Michael Ciesielka on 9/26/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIRequest: NSObject {
    
    var type: Alamofire.Method
    var action: APIAction
    var params: [String: AnyObject]
    var success: MIXRResponseSuccessClosure?
    var failure: MIXRResponseFailureClosure?
    
    init(type: Alamofire.Method, action: APIAction, params: [String: AnyObject]?, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        self.type = type
        self.action = action
        self.params = params ?? [:]
        self.success = success
        self.failure = failure
        
        super.init()
    }
}

class APIManager: NSObject {
    static let sharedInstance = APIManager()
    
    var connection = APIConnection()
    
    func fireRequest(request: APIRequest) {
        do {
            try connection.API(request.type, action: request.action, params: request.params, success: request.success, failure: request.failure)
        } catch APIError.NoAuthToken {
            request.failure?(error: APIError.NoAuthToken)
        } catch APIError.Failure(let response) {
            request.failure?(error: APIError.Failure(response: response))
        } catch {
            request.failure?(error: APIError.UnknownError)
        }
    }
    
}

// MARK: - -- Core API Functions --
// MARK: Auth
extension APIManager {
    func signUp(firstName firstName: String, lastName: String, password: String, email: String, birthdate: String, phoneNumber: String, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        
        var params = [String: AnyObject]()
        params["first_name"] = firstName
        params["last_name"] = lastName
        params["password"] = password
        params["email"] = email
        params["birthdate"] = birthdate
        params["phone_number"] = phoneNumber
        
        signUp(withParams: params, success: success, failure: failure)
    }
    
    func signUp(withParams params: [String: AnyObject], success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        if let email = params["email"] as? String, password = params["password"] as? String {
            let request = APIRequest(type: Alamofire.Method.POST,
                                     action: .Signup,
                                     params: params,
                                     success: { [weak self] response in
                                        self?.updateUserData(SignUpModel(response: response))
                                        self?.loginWithEmail(email, password: password, success: success, failure: failure)
                }, failure: failure)
            
            fireRequest(request)
        }
    }
    
    func loginWithEmail(email: String, password: String, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        var params = [String: AnyObject]()
        params["email"] = email
        params["password"] = password
        
        login(params, success: success, failure: failure)
    }
    
    func loginWithPhoneNumber(phoneNumber: String, password: String, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        var params = [String: AnyObject]()
        params["phone_number"] = phoneNumber
        params["password"] = password
        
        login(params, success: success, failure: failure)
    }
    
    func recoverPassword(phoneNumber: String, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let params = ["phone_number": phoneNumber]
        
        let request = APIRequest(type: Alamofire.Method.POST,
                                 action: .PasswordRecover,
                                 params: params,
                                 success: success,
                                 failure: failure)
        
        fireRequest(request)
    }
    
    func recoverPasswordWithConfirmationCode(code: String, phoneNumber: String, password: String, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let params = [
            "code": code,
            "phone_number": phoneNumber,
            "password": password
        ]
        
        let request = APIRequest(type: Alamofire.Method.POST,
                                 action: .PasswordRecoverChange,
                                 params: params,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
    
    func changePassword(old old: String, new: String, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let params = [
            "password_old": old,
            "password_new": new
        ]
        
        let request = APIRequest(type: Alamofire.Method.POST,
                                 action: .PasswordChange,
                                 params: params,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
    
    func getVerificationCode(phoneNumber phoneNumber: String, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let params = [
            "phone_number": phoneNumber
        ]
        
        let request = APIRequest(type: Alamofire.Method.POST,
                                 action: .GetVerificationCode,
                                 params: params,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
    
    func confirmVerificationCode(phoneNumber phoneNumber: String, code: String, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let params = [
            "phone_number": phoneNumber,
            "code": code
        ]
        
        let request = APIRequest(type: .POST,
                                 action: .ConfirmVerificationCode,
                                 params: params,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
}

// MARK: Search
extension APIManager {
    func search(withQuery query: String, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let params = [
            "query": query
        ]
        
        let request = APIRequest(type: Alamofire.Method.POST,
                                 action: .Search,
                                 params: params,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
}

// MARK: Notifications (may not work)
extension APIManager {
    func getNotifications(success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let params = [
            "userID": AppPersistedStore.sharedInstance.userId ?? ""
        ]
        
        let request = APIRequest(type: Alamofire.Method.POST,
                                 action: .Notifications,
                                 params: params,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
}

// MARK: Newsfeed
extension APIManager {
    func getNewsfeed(forType type: APIAction, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        // only deal with valid types
        switch type {
        case .MyNewsfeed, .NewsfeedUser, .NewsfeedAll:
            break
        default:
            failure?(error: NSError(domain: "MIXR Local", code: -1, userInfo: nil))
        }
        
        let request = APIRequest(type: Alamofire.Method.GET,
                                 action: type,
                                 params: nil,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
    
    func getVenues(success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let request = APIRequest(type: Alamofire.Method.GET,
                                 action: .Venues,
                                 params: nil,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
    
    func getNewsfeed(forVenueId venueId: String, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let params = [
            "venue_id": venueId
        ]
        
        let request = APIRequest(type: Alamofire.Method.POST,
                                 action: .NewsfeedVenue,
                                 params: params,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
}

// MARK: Profile
extension APIManager {
    func getVenueProfile(venueId id: String, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let params = [
            "venue_id": id
        ]
        
        let request = APIRequest(type: Alamofire.Method.POST,
                                 action: .ProfileVenue,
                                 params: params,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
    
    func getUserProfile(forUserId userId: String, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let params = [
            "user_id": userId
        ]
        
        let request = APIRequest(type: Alamofire.Method.POST,
                                 action: .ProfileOther,
                                 params: params,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
}

// MARK: Specials & Events
extension APIManager {
    func getVenueSpecials(venueId id: String, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let params = [
            "venue_id": id
        ]
        
        let request = APIRequest(type: Alamofire.Method.POST,
                                 action: .ProfileVenueSpecial,
                                 params: params,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
    
    func getVenueEvents(venueId id: String, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let params = [
            "venue_id": id
        ]
        
        let request = APIRequest(type: Alamofire.Method.POST,
                                 action: .ProfileVenueEvent,
                                 params: params,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
}

// MARK: Social Following
extension APIManager {
    func followVenue(withVenueId venueId: String, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let params = [
            "follower_venue_id": venueId
        ]
        
        let request = APIRequest(type: Alamofire.Method.POST,
                                 action: .FollowRequestForVenue,
                                 params: params,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
    
    func getFollowStatus(forVenueId venueId: String, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let params = [
            "venue_id": venueId
        ]
        
        let request = APIRequest(type: Alamofire.Method.POST,
                                 action: .FollowStatusForVenue,
                                 params: params,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
    
    func getFollowing(success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let request = APIRequest(type: Alamofire.Method.GET,
                                 action: .Following,
                                 params: nil,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
    
    func getFollowers(success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let request = APIRequest(type: Alamofire.Method.GET,
                                 action: .Followers,
                                 params: nil,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
    
    func updateFollowRequest(ownerId ownerId: String, followStatus: String, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let params = [
            "owner_id": ownerId,
            "follow_status": followStatus
        ]
        
        let request = APIRequest(type: Alamofire.Method.POST,
                                 action: .FollowRequestUpdate,
                                 params: params,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
    
    func likePost(withPostId postId: String, activeLike: Bool, success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let params = [
            "post_id": postId,
            "like": activeLike ? "true" : "false"
        ]
        
        let request = APIRequest(type: Alamofire.Method.POST,
                                 action: .LikePost,
                                 params: params,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
}

// MARK: Misc.
extension APIManager {
    func getAllVenueCoordinates(success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let request = APIRequest(type: Alamofire.Method.GET,
                                 action: .VenueCoordinates,
                                 params: nil,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
    
    func fetchProfilePrivacy(success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let request = APIRequest(type: Alamofire.Method.GET,
                                 action: .ProfilePrivacy,
                                 params: nil,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
    
    func updateProfilePrivacy(success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let request = APIRequest(type: Alamofire.Method.POST,
                                 action: .ProfilePrivacy,
                                 params: nil,
                                 success: success,
                                 failure: failure)
        fireRequest(request)
    }
}

// MARK: - Utility Functions
private extension APIManager {
    func updateUserData(response: SignUpModel) {
        // TODO: stub
    }
    
    func login(params: [String: AnyObject], success: MIXRResponseSuccessClosure?, failure: MIXRResponseFailureClosure?) {
        let request = APIRequest(type: Alamofire.Method.POST,
                                 action: .Login,
                                 params: params,
                                 success: { response in
                                    AppPersistedStore.sharedInstance.authToken = LoginModel(response: response).token
                                    success?(response: response)
            }, failure: failure)
        
        fireRequest(request)
    }
}
