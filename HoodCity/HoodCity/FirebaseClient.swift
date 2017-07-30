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
    
    // Get information from event id
    
    func getDate(from eventId: String, completionHandler: @escaping (Date?, FirebaseError?) -> Void) {
        eventsReference.child(eventId).child("date").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dateStringValue = snapshot.value as? String else {
                completionHandler(nil, FirebaseError.snapshotValueIsEmpty)
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/M/yyyy, H:mm"
            
            guard let date = formatter.date(from: dateStringValue) else {
                completionHandler(nil, FirebaseError.failedToTransformStringToData)
                return
            }
            
            completionHandler(date, nil)
        })
    }
    
    func getType(from eventId: String, completionHandler: @escaping (EventType) -> Void) {
        eventsReference.child(eventId).child("type").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let eventType = snapshot.value as? String else { return }
            
            guard let event = EventType(type: eventType) else { return }
            
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
