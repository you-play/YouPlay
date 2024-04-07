//
//  SpotifyService.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/22/24.
//

import Foundation

/// The `SpotifyService` is in charge of all communication with the Spotify API.
protocol SpotifyService {
    func getAccessToken() async -> String?
    func loadSpotifyCredentials() throws -> (clientId: String, clientSecret: String)
    func search(text: String) async -> SpotifySearchResponse?
    func getSongDetails(id: String) async -> Song?
}
