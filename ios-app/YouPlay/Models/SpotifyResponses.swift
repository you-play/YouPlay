//
//  Artist.swift
//  YouPlay
//
//  Created by Sebastian on 3/24/24.
//

import Foundation

struct SpotifySearchResponse: Codable {
    let tracks: TracksResponse?
}

struct TracksResponse: Codable {
    let items: [SongResponse]
    let limit: Int
    let offset: Int
    let total: Int
}

struct SongResponse: Codable {
    let id: String
    let name: String
    let artists: [ArtistResponse]
    let album: AlbumResponse
    let explicit: Bool
    let popularity: Int
    let previewURL: String?

    enum CodingKeys: String, CodingKey {
        case album, artists
        case explicit
        case id
        case name, popularity
        case previewURL = "preview_url"
    }
}

struct ArtistResponse: Codable {
    let id, name: String

    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

struct AlbumResponse: Codable {
    let id: String
    let name: String
    let artists: [ArtistResponse]
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

struct SpotifyImage: Codable {
    let url: String
    let height: Int
    let width: Int
}
