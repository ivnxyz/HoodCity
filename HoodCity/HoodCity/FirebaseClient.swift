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
    let eventsDataReference = Database.database().reference().child("eventsData")
    let usersReference = Database.database().reference().child("users")

    //MARK: - Add new event
  
    func addDataToExistingEvent(event: String, data: [String: Any], completionHandler: @escaping(Error?, DatabaseReference?) -> Void) {
        eventsDataReference.child(event).updateChildValues(data) { (error, reference) in
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
        eventsDataReference.child(eventId).removeValue()
        usersReference.child(userId).child("events").child(eventId).removeValue()
    }

    //MARK: - Event data
    
    func getEvent(for eventId: String, completionHandler: @escaping (Event?) -> Void) {
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
    
    func getEventData(for event: Event, completionHandler: @escaping (EventData?) -> Void) {
        self.eventsDataReference.child(event.id).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let eventDataDictionary = snapshot.value as? [String: AnyObject] else {
                completionHandler(nil)
                return
            }
            
            let eventData = EventData(eventDict: eventDataDictionary)
            
            completionHandler(eventData)
        })
    }
    
    //MARK: - User
    
    func updateUserProfile(with userData: User, completionHandler: @escaping(Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completionHandler(FirebaseError.emptyUser)
            return
        }
        
        let userInfo = [
            "name": userData.name!
        ]
        
        usersReference.child(user.uid).updateChildValues(userInfo) { (error, reference) in
            guard error == nil else {
                completionHandler(error)
                return
            }
            
            guard let profilePicture = userData.profilePicture else {
                completionHandler(FirebaseError.userHasNoProfilePicture)
                return
            }
            
            self.addProfilePictureToUser(user, image: profilePicture, completionHandler: { (error) in
                completionHandler(error)
            })
        }
    }
    
    func addProfilePictureToUser(_ userInfo: UserInfo, image: UIImage, completionHandler: @escaping(Error?) -> Void) {

        let data = UIImageJPEGRepresentation(image, 0.8)
        let photoName = "profilePicture"
        
        storage.child("users").child(userInfo.uid).child("\(photoName).jpg").putData(data!, metadata: nil) { (metadata, error) in
            guard error == nil else {
                completionHandler(error)
                return
            }
            
            guard let downloadURL = metadata?.downloadURL() else {
                completionHandler(FirebaseError.emptyURL)
                return
            }
            
            self.savePhotoInfoToUserPath(userInfo: userInfo, photoName: photoName, downloadURL: downloadURL, completionHandler: { (error) in
                completionHandler(error)
            })
        }
    }
    
    func savePhotoInfoToUserPath(userInfo: UserInfo, photoName: String, downloadURL: URL, completionHandler: @escaping(Error?) -> Void) {
        
        let data = [
            "name": photoName,
            "downloadUrl": downloadURL.absoluteString
        ]
        
        print("Saving photo...")
        
        usersReference.child(userInfo.uid).child(photoName).setValue(data) { (error, reference) in
            completionHandler(error)
        }
    }
    
    //Get user data
    
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
                print("There are no events")
                completionHandler(nil)
                return
            }
            
            for eventId in eventsData.keys {
                self.getEvent(for: eventId, completionHandler: { (event) in
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








