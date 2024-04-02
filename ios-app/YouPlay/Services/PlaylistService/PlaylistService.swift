//
//  PlaylistService.swift
//  YouPlay
//
//  Created by Sebastian on 4/1/24.
//

import Foundation

/// The `PlaylistService` manages all playlist manipulation and publishes any playlist changes using combine.
protocol PlaylistService {
    func setupDefaultPlaylists(uid: String) async -> Void
    func getPlaylists(uid: String) async -> [Playlist]
    func getPlaylist(uid: String, playlistId: String) async -> Playlist?
    func getTopPlaylists(uid: String, limit: Int) async -> [Playlist]
}
