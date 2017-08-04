//
//  FirebaseClient.swift
//  HoodCity
//
//  Created by Iván Martínez on 12/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseClient {
    
    let storage = Storage.storage().reference()
    let eventsReference = Database.database().reference().child("events")
    let usersReference = Database.database().reference().child("users")

    //MARK: - Add new event
  
    func addDataToExistingEvent(event: String, data: [String: Any], completionHandler: @escaping(Error?, DatabaseReference?) -> Void) {
        eventsReference.child(event).updateChildValues(data) { (error, reference) in
            completionHandler(error, reference)
        }
    }
    
    func addEventToCurrentUser(eventId: String) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        let eventInfo = ["\(eventId)" : true]
        
        usersReference.child(user.uid).child("events").updateChildValues(eventInfo)
    }
    
    //MARK: - Remove event
    
    func removeEventFrom(userId: String, eventId: String) {
        usersReference.child(userId).child("events").child(eventId).removeValue()
    }

    //MARK: - Event data
    
    func getEventData(for eventId: String, completionHandler: @escaping (Event?) -> Void) {
        eventsReference.child(eventId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let eventId = snapshot.key
            
            guard let eventDictionary = snapshot.value as? [String: AnyObject] else {
                completionHandler(nil)
                return
            }
            
            let event = Event(eventDict: eventDictionary, id: eventId)
            
            completionHandler(event)
        })
    }
    
    //MARK: - User
    
    func addProfilePictureToCurrentUser(_ image: UIImage) {
        guard let user = Auth.auth().currentUser else { return }
        
        let data = UIImageJPEGRepresentation(image, 0.8)
        let photoName = "profilePicture"
        
        storage.child("users").child(user.uid).child("\(photoName).jpg").putData(data!, metadata: nil) { (metadata, error) in
            guard error == nil else {
                print("Error trying to put image to user: ", error!)
                return
            }
            
            guard let downloadUrl = metadata?.downloadURL() else {
                print("Empty url")
                return
            }
            
            self.savePhotoInfoToUserPath(name: photoName, downloadUrl: downloadUrl)
        }
    }
    
    func savePhotoInfoToUserPath(name: String, downloadUrl: URL) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        let data = [
            "name": name,
            "downloadUrl": downloadUrl.absoluteString
        ]
        
        print("Saving photo...")
        usersReference.child(user.uid).child(name).setValue(data)
    }
    
    func updateUserProfile(with userData: User) {
        guard let user = Auth.auth().currentUser else { return }
        
        let userInfo = [
            "name": userData.name!
        ]
        
        usersReference.child(user.uid).updateChildValues(userInfo) { (error, reference) in
            guard error == nil else {
                print(error!)
                return
            }
            
            self.addProfilePictureToCurrentUser(userData.profilePicture!)
        }
    }
    
    struct FirebaseUser {
        let profilePictureUrl: String
        let name: String
    }
    
    func getProfileFor(userId: String, completionHandler: @escaping(FirebaseUser?) -> Void) {
        usersReference.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userData = snapshot.value as? [String: AnyObject] else {
                completionHandler(nil)
                return
            }
            
            guard let profilePictureData = userData["profilePicture"] as? [String: AnyObject] else {
                completionHandler(nil)
                return
            }
            
            guard let profilePictureUrl = profilePictureData["downloadUrl"] as? String else {
                completionHandler(nil)
                return
            }
            
            guard let name = userData["name"] as? String else {
                completionHandler(nil)
                return
            }
            
            let firebaseUser = FirebaseUser(profilePictureUrl: profilePictureUrl, name: name)
            
            completionHandler(firebaseUser)
        })
    }
    
    func getEventsFor(_ userId: String, completionHandler: @escaping(Event?) -> Void) {
        usersReference.child(userId).child("events").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let eventsData = snapshot.value as? [String: AnyObject] else {
                print("Cannot get events from user")
                completionHandler(nil)
                return
            }
            
            for eventId in eventsData.keys {
                self.getEventData(for: eventId, completionHandler: { (event) in
                    guard let event = event else {
                        print("Cannot get event")
                        return
                    }
                    
                    completionHandler(event)
                })
            }
        })
    }
}







