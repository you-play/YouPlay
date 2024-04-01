//
//  Song.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/22/24.
//

import FirebaseFirestoreSwift
import Foundation

struct Song: Identifiable, Codable, Hashable {
    // Firebase
    @DocumentID var UUID: String?

    let id: String
    let name: String
    let artists: [Artist]
    let album: Album
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

extension Song {
    static let mock = Song(
        id: "1",
        name: "Blank Space",
        artists: [
            Artist.mock,
        ],
        album: Album.mock,
        explicit: false,
        popularity: 90,
        previewURL: nil)

    static let mocks = [
        Song(
            id: "1",
            name: "Blank Space 1",
            artists: [
                Artist.mock,
            ],
            album: Album.mock,
            explicit: false,
            popularity: 90,
            previewURL: nil),
        Song(
            id: "2",
            name: "Blank Space 2",
            artists: [
                Artist.mock,
            ],
            album: Album.mock,
            explicit: false,
            popularity: 90,
            previewURL: nil),
        Song(
            id: "3",
            name: "Blank Space 3",
            artists: [
                Artist.mock,
            ],
            album: Album.mock,
            explicit: false,
            popularity: 90,
            previewURL: nil),
        Song(
            id: "4",
            name: "Blank Space 4",
            artists: [
                Artist.mock,
            ],
            album: Album.mock,
            explicit: false,
            popularity: 90,
            previewURL: nil),
        Song(
            id: "5",
            name: "Blank Space 5",
            artists: [
                Artist.mock,
            ],
            album: Album.mock,
            explicit: false,
            popularity: 90,
            previewURL: nil),
    ]
}
