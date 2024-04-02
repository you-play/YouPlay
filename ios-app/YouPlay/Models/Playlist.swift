//
//  Playlist.swift
//  YouPlay
//
//  Created by Sebastian on 4/1/24.
//

import Foundation

struct Playlist: Identifiable, Codable, Hashable {
    var id: String {
        UUID().uuidString
    }

    var title: String
    var imageUrl: String
    var songs: [Song]
}

extension Playlist {
    static let mock = Playlist(
        title: "Liked Songs",
        imageUrl: Album.mock.images.first!.url,
        songs: Song.mocks
    )

    static let mocks = [
        Playlist(
            title: "Liked Songs",
            imageUrl: Album.mock.images.first!.url,
            songs: Song.mocks
        ),
        Playlist(
            title: "Favorite Songs",
            imageUrl: Album.mock.images.first!.url,
            songs: Song.mocks
        ), Playlist(
            title: "2019 Songs",
            imageUrl: Album.mock.images.first!.url,
            songs: Song.mocks
        ),
    ]
}
