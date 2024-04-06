//
//  SpotifyController.swift
//  YouPlay
//
//  Created by Sebastian on 4/5/24.
//

import Foundation

import Combine
import SpotifyiOS
import SwiftUI

class SpotifyController: NSObject, ObservableObject {
    /// Your own Spotify client ID. Otherwise, it won't be able to authorize you.
    var spotifyClientID: String {
        do {
            let credentials = try SpotifyServiceImpl.shared.loadSpotifyCredentials()
            return credentials.clientId
        } catch {
            print("ERROR: Unable to load spotify client id from plist")
        }
        
        return ""
    }

    /// You can set this ID directly in your Spotify API dashboard: https://developer.spotify.com/dashboard
    let spotifyRedirectURL = URL(string: "spotify-ios-you-play://spotify-login-callback")!
    
    var accessToken: String? = nil
    var playURI = ""
    
    private var connectCancellable: AnyCancellable?
    private var disconnectCancellable: AnyCancellable?
    
    override init() {
        super.init()
        
        connectCancellable = NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.connect()
            }
        
        disconnectCancellable = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.disconnect()
            }
    }
        
    lazy var configuration = SPTConfiguration(
        clientID: spotifyClientID,
        redirectURL: spotifyRedirectURL
    )

    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
    func setAccessToken(from url: URL) {
        let parameters = appRemote.authorizationParameters(from: url)
        
        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = accessToken
            self.accessToken = accessToken
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print(errorDescription)
        }
    }
    
    func connect() {
        guard let _ = appRemote.connectionParameters.accessToken else {
            appRemote.authorizeAndPlayURI("")
            return
        }
        
        appRemote.connect()
    }
    
    func disconnect() {
        if appRemote.isConnected {
            appRemote.disconnect()
        }
    }
}

extension SpotifyController: SPTAppRemoteDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote = appRemote
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { _, error in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            
        })
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("DEBUG: failed to connect to Spotify")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("DEBUG: disconnected from Spotify")
    }
}

extension SpotifyController: SPTAppRemotePlayerStateDelegate {
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        debugPrint("Track name: %@", playerState.track.name)
    }
}
