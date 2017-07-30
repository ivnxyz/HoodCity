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
    
    func addDateToExistingEvent(_ eventId: String) {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/M/yyyy, H:mm"
        
        let dateStringRepresentation = formatter.string(from: currentDate)
        
        eventsReference.child(eventId).updateChildValues(["date": dateStringRepresentation])
    }
    
    func addEventType(_ eventType: EventType, to eventId: String) {
        let eventType = eventType.type
        
        eventsReference.child(eventId).updateChildValues(["type": eventType])
    }

    //MARK: - Event data
    
    func getEventData(for eventId: String, completionHandler: @escaping (Event?) -> Void) {
        eventsReference.child(eventId).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let eventDictionary = snapshot.value as? [String: AnyObject] else {
                
                completionHandler(nil)
                
                return
            }
            
            let event = Event(eventDict: eventDictionary)
            
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
    
    func updateUserProfile(with userData: FacebookUser) {
        guard let user = Auth.auth().currentUser else { return }
        
        let userInfo = [
            "name": userData.name
        ]
        
        usersReference.child(user.uid).updateChildValues(userInfo) { (error, reference) in
            guard error == nil else {
                print(error!)
                return
            }
            
            self.addProfilePictureToCurrentUser(userData.profilePicture)
        }
    }
}
