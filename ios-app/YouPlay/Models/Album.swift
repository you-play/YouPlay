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

struct Album: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let artists: [Artist]
    let images: [SpotifyImage]
    let releaseDate: String
    let totalTracks: Int

    enum CodingKeys: String, CodingKey {
        case artists
        case id, images, name
        case releaseDate = "release_date"
        case totalTracks = "total_tracks"
    }
}

extension Album {
    static let mock = Album(
        id: "1",
        name: "1989",
        artists: [Artist.mock],
        images: [SpotifyImage.mock],
        releaseDate: "2020",
        totalTracks: 30)
}
