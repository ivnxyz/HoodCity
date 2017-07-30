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
    
    func getUserData(completionHandler: @escaping(FacebookUser) -> Void) {
        let request = FBSDKGraphRequest(graphPath: "me", parameters:  ["fields": "id, name, email, picture.type(large)"])
        
        _ = request?.start(completionHandler: { (connection, result, error) in
            guard error == nil else {
                print("Error at getting users's data:", error!)
                return
            }
            
            guard let result = result as? [String: AnyObject] else {
                print("Error: Cannot convert result to dictionary")
                return
            }
            
            guard let pictureData = result["picture"]?["data"] as? [String: AnyObject] else {
                print("Error: Cannot picture data")
                return
            }
            
            guard let pictureUrlString = pictureData["url"] as? String else {
                print("Error: Cannot find profile picture url")
                return
            }
            
            let pictureUrl = URL(string: pictureUrlString)!
            
            URLSession.shared.dataTask(with: pictureUrl, completionHandler: { (data, response, error) in
                guard error == nil else {
                    print("Error: ", error!)
                    return
                }
                
                guard let profilePicture = UIImage(data: data!) else {
                    print("Error: Cannot convert to image")
                    return
                }
                
                let name = result["name"] as! String
                let email = result["email"] as! String
                
                let user = FacebookUser(name: name, email: email, profilePicture: profilePicture)
                
                completionHandler(user)
            }).resume()
        })
    }
}
