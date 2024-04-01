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
    let items: [Song]
    let limit: Int
    let offset: Int
    let total: Int
}
