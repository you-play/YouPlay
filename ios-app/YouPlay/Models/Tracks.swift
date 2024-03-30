//
//  Tracks.swift
//  YouPlay
//
//  Created by 趙藝鑫 on 3/30/24.
//

import Foundation

struct Tracks: Hashable {
    let album: Album
    let artists: [TracksArtist]
    let name: String
    let trackNumber: Int
    let type, uri: String
}
