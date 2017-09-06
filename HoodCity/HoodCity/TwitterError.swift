//
//  TwitterError.swift
//  HoodCity
//
//  Created by Iván Martínez on 06/09/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation

enum TwitterError: Error {
    case currentUserDoesNotExist
    case cannotConvertDataToImage
    case invalidProfileImageURL
}

extension TwitterError: LocalizedError {
    public var errorDescription: String? {
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
