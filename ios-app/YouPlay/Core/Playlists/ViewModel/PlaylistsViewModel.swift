//
//  PlaylistsViewModel.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import Combine
import FirebaseAuth
import Foundation

@MainActor
class PlaylistsViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var playlists: [Playlist] = []
    @Published var playlistIdToSongs: [String: [Song]] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    private let playlistService: PlaylistService
    
    init(playlistService: PlaylistService = PlaylistServiceImpl.shared) {
        self.playlistService = playlistService
        setupSubscribers()

        Task {
            await fetchPlaylists()
            await fetchSongs(playlists: playlists)
        }
    }
    
    func fetchPlaylists() async {
        guard let uid = currentUser?.uid else {
            print("DEBUG: No user is currently logged in.")
            return
        }
        
        playlists = await playlistService.getPlaylists(uid: uid)
        print("DEBUG: playlists retrieved \(playlists)")
    }
    
    func fetchSongs(playlists: [Playlist]) async {
        playlistIdToSongs = await PlaylistServiceImpl.shared.getPlaylistIdToSongsMap(for: playlists)
    }
    
    func createPlaylist(withName name: String) async {
        guard let uid = currentUser?.uid else {
            print("DEBUG: No user is currently logged in unable to create playlist")
            return
        }
    
        _ = await playlistService.createPlaylist(uid: uid, name: name, imageUrl: nil)
        // Fetch playlists after creating a new one
        await fetchPlaylists()
    }
    
    // Deletes a playlist with a given ID
    func deletePlaylist(playlistId: String) async {
        guard let userID = Auth.auth().currentUser?.uid else {
            // Debug message if no user is logged in
            print("DEBUG: No user is currently logged in.")
            return
        }
        await playlistService.deletePlaylist(uid: userID, playlistId: playlistId)
        // Refreshes the list after deletion
        await fetchPlaylists()
    }
    
    private func setupSubscribers() {
        UserServiceImpl.shared.$currentUser.sink { [weak self] currentUser in
            self?.currentUser = currentUser
        }
        .store(in: &cancellables)
    }
}
