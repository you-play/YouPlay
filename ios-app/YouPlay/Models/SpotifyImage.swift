//
//  SpotifyImage.swift
//  YouPlay
//
//  Created by Sebastian on 3/31/24.
//

import Foundation

struct SpotifyImage: Hashable, Codable {
    let url: String
    let height: Int
    let width: Int
}

extension SpotifyImage {
    static let mock = SpotifyImage(
        url: "https://i.scdn.co/image/ab67616d0000b273904445d70d04eb24d6bb79ac",
        height: 640,
        width: 640)
}
