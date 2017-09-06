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
    case userDictionaryDoesNotExist
    case cannotGetNameFromUser
}

extension FirebaseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .snapshotValueIsEmpty:
            return "The snapshot value is empty."
        case .failedToTransformStringToData:
            return "Faild to transform string into data."
        case .userHasNoProfilePicture:
            return "This user has no profile picture."
        case .emptyURL:
            return "The imageURL passed is empty."
        case .emptyUser:
            return "User is not signed in."
        case .failedToAddDataToExistingEvent:
            return "We couldn't add this event, try again later :("
        case .userDictionaryDoesNotExist:
            return "We couldn't get any user's data, please sign in again."
        case .cannotGetNameFromUser:
            return "We couldn't get user's name, please sign in again."
        }
    }
}
