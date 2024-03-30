//  Models of "Album", "AlbumImage", "Tracks"
//  Album.swift
//  YouPlay
//
//  Created by 趙藝鑫 on 3/27/24.
//
import FirebaseFirestoreSwift
import Foundation

// To parse the JSON, add this file to your project and do:
//
//   let album = try? JSONDecoder().decode(Album.self, from: jsonData)

//
// Hashable or Equatable:

import Foundation

struct Album: Hashable {
    let albumType: String
    let totalTracks: Int
    let href, id: String
    let images: [AlbumImage]
    let name, uri: String
    let artists: [Artist]
    let tracks: Tracks
    let popularity: Int
}


struct AlbumImage: Codable, Hashable {
    let url: String
    let height, width: Int
}


struct Tracks: Codable, Hashable {
    let href, next, previous: String?
}




extension Album {
    static let mock = Album (
        albumType: "album",
        totalTracks: 2,
        href: "https://api.spotify.com/v1/albums/0011223344556677",
        id: "0011223344556677",
        images: [
            AlbumImage(
                url: "https://i.scdn.co/image/ab67616d0000b273000000003e2e89844c1e6e1b9d8bf5180a30bf5e",
                height: 640,
                width: 640
            ),
            AlbumImage(
                url: "https://i.scdn.co/image/ab67616d0000b273000000003e2e89844c1e6e1b9d8bf5180a30bf5e",
                height: 300,
                width: 300
            ),
            AlbumImage(
                url: "https://i.scdn.co/image/ab67616d0000b273000000003e2e89844c1e6e1b9d8bf5180a30bf5e",
                height: 64,
                width: 64
            ),
        ],
        name: "Mock album",
        uri: "spotify:album:0011223344556677",
        artists: [Artist.mock],
        tracks: Tracks.mock,
        popularity: 1000
    )
}

extension Tracks {
    static let mock = Tracks(
        href:"https://www.youtube.com/watch?v=VuNIsY6JdUw",
        next: "Crul Summer",
        previous: "Lover"
    )
}

extension AlbumImage {
    static let mock = AlbumImage(
        url: "https://i.scdn.co/image/ab67616d0000b273000000003e2e89844c1e6e1b9d8bf5180a30bf5e",
        height: 640,
        width: 640
    )
}
