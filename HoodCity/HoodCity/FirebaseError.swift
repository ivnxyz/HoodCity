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
}
