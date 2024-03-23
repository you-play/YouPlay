//
//  Constants.swift
//  YouPlay
//
//  Created by Sebastian on 3/15/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

/// Firestore collection names and paths.
enum FirestoreConstants {
    static let UsersCollection = Firestore.firestore().collection("users")
}

/// Storage bucket names for Firebase Storage.
///
/// Important: make sure to use `.rawValue` when using these cases
enum StorageBuckets: String {
    case ProfileImages = "profile-images"
}

let MIN_PASSWORD_LENGTH = 6
let EMAIL_REGEX = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#

let spotifyTokenURL = "https://accounts.spotify.com/api/token"

