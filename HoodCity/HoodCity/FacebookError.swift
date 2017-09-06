//
//  FacebookError.swift
//  HoodCity
//
//  Created by Iván Martínez on 06/09/17.
//  Copyright © 2017 Iván Martínez. All rights reserved.
//

import Foundation

enum FacebookError: Error {
    case cannotGetUsersData
    case cannotGetProfilePicture
}

extension FacebookError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .cannotGetUsersData:
            return "We couldn't get any data from Facebook."
        case .cannotGetProfilePicture:
            return "We couldn't get your profile picture."
        }
    }
}
