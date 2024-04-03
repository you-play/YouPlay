//
//  Playlist.swift
//  YouPlay
//
//  Created by Sebastian on 4/1/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct Playlist: Identifiable, Codable, Hashable {
    @DocumentID var docId: String?
    var id: String {
        return docId ?? NSUUID().uuidString
    }

    var title: String
    /// A list of Spotify Song IDs
    var songs: [String]
    /// Optional image URL for the playlist TODO: we should prioritize: image URL -> first song's image -> default image
    var imageUrl: String?
    var lastModified: Timestamp?
}

extension Playlist {
    static let mock = Playlist(
        title: "Liked Songs",
        songs: [],
        imageUrl: Album.mock.images.first!.url
    )

    static let mocks = [
        Playlist(
            title: "Liked Songs",
            songs: ["1"],
            imageUrl: Album.mock.images.first!.url
        ),
        Playlist(
            title: "Favorite Songs",
            songs: [],
            imageUrl: Album.mock.images.first!.url
        ), Playlist(
            title: "2019 Songs",
            songs: [],
            imageUrl: Album.mock.images.first!.url
        ),
    ]
}
