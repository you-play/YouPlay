//
//  Song.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/22/24.
//

import FirebaseFirestoreSwift
import Foundation

struct Song: Identifiable, Hashable {
    @DocumentID var UUID: String?

    let title: String
    let artists: [String]
    let imageName: String // will probable need to change to imageURL

    var id: String {
        return UUID ?? NSUUID().uuidString
    }
}

extension Song {
    static let mock = Song(
        title: "Title",
        artists: ["Artist"],
        imageName: "testSpotifyImage"
    )
}
