//
//  FirebaseError.swift
//  HoodCity
//
//  Created by Iván Martínez on 13/07/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation

enum FirebaseError: Error {
    case snapshotValueIsEmpty
    case failedToTransformStringToData
    case userHasNoProfilePicture
    case emptyURL
    case emptyUser
    case failedToAddDataToExistingEvent
}

extension FirebaseError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .snapshotValueIsEmpty:
            return "The snapshot value is empty."
        case .failedToTransformStringToData:
            return "Faild to transform string into data."
        case .userHasNoProfilePicture:
            return "The user passed has no profile picture."
        case .emptyURL:
            return "The imageURL passed is empty."
        case .emptyUser:
            return "User is not signed in."
        case .failedToAddDataToExistingEvent:
            return "We couldn't add this event, try again later :("
        }
    }
}
