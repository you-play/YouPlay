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
    let imageUrl: String?

    var id: String {
        return UUID ?? NSUUID().uuidString
    }
}

extension Song {
    static let mock = Song(
        title: "Blank Space",
        artists: ["Taylor Swift"],
        imageName: "testSpotifyImage",
        imageUrl: "https://i.scdn.co/image/ab67616d0000b273904445d70d04eb24d6bb79ac"
    )
}
