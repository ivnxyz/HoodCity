//
//  TwitterClient.swift
//  HoodCity
//
//  Created by Iván Martínez on 05/08/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation
import TwitterKit

class TwitterClient {
    
    let client = TWTRAPIClient.withCurrentUser()
    
    typealias UserData = [String: Any]
    
    func getUserProfileData(completionHandler: @escaping(Error?, UserData?) -> Void) {
        guard let currentUserID = client.userID else {
            completionHandler(TwitterError.currentUserDoesNotExist, nil)
            return
        }
        
        client.loadUser(withID: currentUserID) { (user, error) in
            if let user = user {
                
                let name = user.name
                let pictureUrlString = user.profileImageURL
                
                let userData = ["name": name,
                                "profilePicture": [
                                    "downloadUrl": pictureUrlString
                               ]] as [String : Any]
                
                completionHandler(nil, userData)
            } else {
                completionHandler(error, nil)
            }
        }
    }
    
}

enum TwitterError: Error {
    case currentUserDoesNotExist
    case cannotConvertDataToImage
    case invalidProfileImageURL
}

extension TwitterError: LocalizedError {
    
    var localizedDescription: String {
        switch self {
        case .currentUserDoesNotExist:
            return "The current user desn't exist."
        case .cannotConvertDataToImage:
            return "Unable to convert url session data to UIImage."
        case .invalidProfileImageURL:
            return "The URL for Twitter profile image is invalid."
            
        }
    }
}
