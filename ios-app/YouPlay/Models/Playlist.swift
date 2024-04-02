//
//  Playlist.swift
//  YouPlay
//
//  Created by Sebastian on 4/1/24.
//

import Foundation

struct Playlist: Identifiable, Codable, Hashable {
    let id: String
    var title: String
    var imageUrl: String
    var songs: [Song]
}

extension Playlist {
    static let mock = Playlist(
        id: "1",
        title: "Liked Songs",
        imageUrl: Album.mock.images.first!.url,
        songs: Song.mocks
    )

    static let mocks = [
        Playlist(
            id: "1",
            title: "Liked Songs",
            imageUrl: Album.mock.images.first!.url,
            songs: Song.mocks
        ),
        Playlist(
            id: "2",
            title: "Favorite Songs",
            imageUrl: Album.mock.images.first!.url,
            songs: Song.mocks
        ), Playlist(
            id: "3",
            title: "2019 Songs",
            imageUrl: Album.mock.images.first!.url,
            songs: Song.mocks
        ),
    ]
}
