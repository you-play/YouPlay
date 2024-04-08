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

    static func PlaylistsCollection(uid: String) -> CollectionReference {
        FirestoreConstants.UsersCollection.document(uid).collection("playlists")
    }
}

/// Storage bucket names for Firebase Storage.
///
/// Important: make sure to use `.rawValue` when using these cases
enum StorageBuckets: String {
    case ProfileImages = "profile-images"
}

let MIN_PASSWORD_LENGTH = 6
let EMAIL_REGEX = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#

let SPOTIFY_TOKEN_URL = "https://accounts.spotify.com/api/token"
let SPOTIFY_BASE_API_URL = "https://api.spotify.com/v1"
let SILENT_TRACK_URI = "spotify:track:7p5bQJB4XsZJEEn6Tb7EaL"
let MAX_ALLOWED_RECENT_SONGS = 20

let TOP_PLAYLISTS_LIMIT = 6
let DEFAULT_PLAYLISTS: [Playlist] = [
    .init(
        title: "Liked Songs",
        songs: [],
        imageUrl: "https://preview.redd.it/rnqa7yhv4il71.jpg?width=640&crop=smart&auto=webp&s=819eb2bda1b35c7729065035a16e81824132e2f1",
        lastModified: FirebaseFirestore.Timestamp()
    ),
]
