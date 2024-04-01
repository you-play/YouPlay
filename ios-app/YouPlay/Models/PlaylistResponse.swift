//
//  PlaylistResponse.swift
//  YouPlay
//
//  Created by 趙藝鑫 on 3/27/24.
//

import Foundation
struct MoodPlaylistResponse: Codable {
    let playlist: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let item: [Playlist]
}

struct Playlist: Codable {
    let description: String
    
}
