//
//  APIModel.swift
//  MIXR
//
//  Created by Michael Ciesielka on 9/26/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit
import SwiftyJSON

class APIModel {
    let response: JSON
    
    init(response: JSON) {
        self.response = response
    }
}

class SignUpModel: APIModel {
    var firstName: String? {
        return response["first_name"].rawString() ?? nil
    }
    
    var lastName: String? {
        return response["last_name"].rawString() ?? nil
    }
    
    var email: String? {
        return response["email"].rawString() ?? nil
    }
    
    var phoneNumber: String? {
        return response["phone_number"].rawString() ?? nil
    }
}

class LoginModel: APIModel {
    var token: String? {
        return response["token"].rawString() ?? nil
    }
}

class SearchResponseModel: APIModel {
    var results: [SearchItemModel] {
        return response.arrayValue.map({ (result) -> SearchItemModel in
            return SearchItemModel(response: result)
        })
    }
}

class SearchItemModel: APIModel {
    
    var isUser: Bool {
        if let _ = userId {
            return true
        }
        
        return false
    }
    
    var isVenue: Bool {
        if let _ = venueId {
            return true
        }
        
        return false
    }
    
    var id: String? {
        return response["id"].rawString() ?? nil
    }
    
    var userId: String? {
        return response["user_id"].rawString() ?? nil
    }
    
    var firstName: String? {
        return response["first_name"].rawString() ?? nil
    }
    
    var lastName: String? {
        return response["last_name"].rawString() ?? nil
    }
    
    var imageURLString: String? {
        return response["image_url"].rawString() ?? nil
    }
    
    var venueId: String? {
        return response["venue_id"].rawString() ?? nil
    }
    
    var venueName: String? {
        return response["name"].rawString() ?? nil
    }
}
