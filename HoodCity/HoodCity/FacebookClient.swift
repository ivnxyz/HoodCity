//
//  FacebookClient.swift
//  HoodCity
//
//  Created by Iván Martínez on 30/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class FacebookClient {

    typealias FacebookUserData = [String: Any]
    
    func getUserProfileData(completionHandler: @escaping(Error?, FacebookUserData?) -> Void) {
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, picture.type(large)"])
        
        _ = request?.start(completionHandler: { (connection, result, error) in
            guard error == nil else {
                print("Error trying to get user's data from Facebook: \(error!.localizedDescription)")
                completionHandler(FacebookError.cannotGetUsersData, nil)
                return
            }
            
            guard let result = result as? [String: AnyObject] else {
                print("Error: Cannot convert result to dictionary")
                completionHandler(FacebookError.cannotGetUsersData, nil)
                return
            }
            
            guard let name = result["name"] as? String else {
                print("Error: We couldn't get the name of the user.")
                completionHandler(FacebookError.cannotGetUsersData, nil)
                return
            }
            
            guard let pictureData = result["picture"]?["data"] as? [String: AnyObject] else {
                print("Error: Cannot picture data")
                completionHandler(FacebookError.cannotGetProfilePicture, nil)
                return
            }
            
            guard let pictureUrlString = pictureData["url"] as? String else {
                print("Error: Cannot find profile picture url")
                completionHandler(FacebookError.cannotGetProfilePicture, nil)
                return
            }
            
            let userData = ["name": name,
                            "profilePicture": [
                            "downloadUrl": pictureUrlString
                           ]] as [String : Any]
            
            completionHandler(nil, userData)
        })
    }
}




