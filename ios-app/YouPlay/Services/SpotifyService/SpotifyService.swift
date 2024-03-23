//
//  SpotifyService.swift
//  YouPlay
//
//  Created by Joshua lopes on 3/22/24.
//

import Foundation
protocol SpotifyService{
    func loadSpotifyCredentials() -> (clientId: String?, clientSecret: String?)
    func authenticateWithSpotify(clientId: String, clientSecret: String)
}
