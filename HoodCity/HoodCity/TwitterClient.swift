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
    
    func getUserEmail(completionHandler: @escaping(String?, Error?) -> Void) {
        client.requestEmail { (email, error) in
            if let email = email {
                completionHandler(email, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    func getUserData(completionHandler: @escaping(User?, Error?) -> Void) {
        guard let currentUserID = client.userID else {
            completionHandler(nil, TwitterError.currentUserDoesNotExist)
            return
        }
        
        client.loadUser(withID: currentUserID) { (user, error) in
            if let user = user {
                
                let name = user.name
                
                guard let profilePictureURL = URL(string: user.profileImageURL) else {
                    completionHandler(nil, TwitterError.invalidProfileImageURL)
                    return
                }
                
                URLSession.shared.dataTask(with: profilePictureURL, completionHandler: { (data, response, error) in
                    guard error == nil else {
                        completionHandler(nil, error)
                        return
                    }
                    
                    guard let profilePicture = UIImage(data: data!) else {
                        completionHandler(nil, TwitterError.cannotConvertDataToImage)
                        return
                    }
                    
                    let user = User(name: name, email: nil, profilePicture: profilePicture)
                    
                    completionHandler(user, nil)
                }).resume()
            } else {
                completionHandler(nil, error)
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
