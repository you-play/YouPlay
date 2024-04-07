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

/// This is internal workings on the controller.
@MainActor
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
    
    // playback controls
    @Published var isPaused: Bool = false
    @Published var song: Song? = nil

    private var playbackRestoreURI = ""
    private var playbackRestoreSeekPosition: Int = 0
    private var songId: String? = nil
    
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
}

/// This is the main functionality/API to interact with Spotify Player
@MainActor
extension SpotifyController {
    func connect() {
        if appRemote.isConnected {
            return
        }
        
        guard let _ = appRemote.connectionParameters.accessToken else {
            appRemote.authorizeAndPlayURI(SILENT_TRACK_URI) // don't play audio on first "login"
            return
        }
        
        appRemote.connect()
    }
    
    func disconnect() {
        if appRemote.isConnected {
            appRemote.disconnect()
        }

        // reset
        isPaused = false
        song = nil

        playbackRestoreURI = ""
        playbackRestoreSeekPosition = 0
        songId = nil
        appRemote.playerAPI?.pause(nil)
    }
    
    /// Pauses/Plays the currently playing track.
    ///
    /// The Spotify SDK does NOT allow us to pause a song and then later continue interacting with the
    /// APIs without re-authorizing.
    ///
    /// So, to get around this, we basically have a "silent track" that plays on an infinite loop
    /// while "paused" and we save the state (track and position) before the
    /// pause occurred so we can later restore it once the user "plays".
    func pauseOrPlay() {
        // save state of the player
        appRemote.playerAPI?.getPlayerState { [weak self] state, _ in
            let state = state as! SPTAppRemotePlayerState?
            
            if let state = state {
                self?.playbackRestoreURI = state.track.uri
                self?.playbackRestoreSeekPosition = state.playbackPosition
                print("DEBUG: saved playback seek position as \(state.playbackPosition) ms for uri \(state.track.uri)")
            }
        }
        
        if isPaused { // paused -> play
            play(uri: playbackRestoreURI)
            
            // restore play position
            appRemote.playerAPI?.seek(toPosition: playbackRestoreSeekPosition)
            appRemote.playerAPI?.setRepeatMode(.context) // keep playing "recommended" songs
            print("DEBUG: Resuming song with uri \(playbackRestoreURI) at \(playbackRestoreSeekPosition) ms")
            isPaused = false
        } else { // play -> paused
            play(uri: SILENT_TRACK_URI)
            appRemote.playerAPI?.setRepeatMode(.track) // keep playing silent audio in a loop
            print("DEBUG: Pausing song with uri \(playbackRestoreURI) with silent track with uri \(SILENT_TRACK_URI)")
            isPaused = true
        }
    }
    
    /// Plays a song (or similar) given a Spotify URI.
    func play(uri: String) {
        // as long as the "silent song" is not playing, we are not paused
        if uri != SILENT_TRACK_URI {
            isPaused = false
        }
       
        appRemote.playerAPI?.play(uri, asRadio: false) { result, error in
            if let error = error {
                print("DEBUG: Error playing song with uri \(uri):" + error.localizedDescription)
            } else {
                print("DEBUG: Successfully playing track with URI \(uri)", result ?? "")
            }
        }
    }
}

/// Intercepts connection state.
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

/// Intercepts player state.
extension SpotifyController: SPTAppRemotePlayerStateDelegate {
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        let currentURI = playerState.track.uri
        let currentSongId = currentURI.replacingOccurrences(of: "spotify:track:", with: "")
        
        // Updates song metadata
        if currentURI != SILENT_TRACK_URI && currentSongId != songId {
            Task {
                self.song = await SpotifyServiceImpl.shared.getSongDetails(id: currentSongId)
                self.songId = currentSongId
            }
        }
        
        debugPrint("Track name: \(playerState.track.name)")
    }
}
