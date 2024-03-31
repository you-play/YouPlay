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

extension SongResponse {
    static let mock = SongResponse(
        id: "1",
        name: "Blank Space",
        artists: [
            ArtistResponse.mock,
        ],
        album: AlbumResponse.mock,
        explicit: false,
        popularity: 90,
        previewURL: nil)
}

extension ArtistResponse {
    static let mock = ArtistResponse(id: "1", name: "Taylor Swift")
}

extension AlbumResponse {
    static let mock = AlbumResponse(
        id: "1",
        name: "1989",
        artists: [ArtistResponse.mock],
        images: [SpotifyImage.mock],
        releaseDate: "2020",
        totalTracks: 30)
}

extension SpotifyImage {
    static let mock = SpotifyImage(
        url: "https://i.scdn.co/image/ab67616d0000b273904445d70d04eb24d6bb79ac",
        height: 640,
        width: 640)
}
