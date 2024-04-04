//
//  PlaylistsViewModel.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import Foundation
import Combine
import FirebaseAuth

class PlaylistsViewModel: ObservableObject {
    @Published var playlists: [Playlist] = [] // Holds playlists and notifies views of changes
    private var cancellables = Set<AnyCancellable>()
    private let playlistService: PlaylistService // Handles playlist operations
    
    // Computed property to get the current user's ID
    private var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }
    
    // Dependency injection for the playlist service
    init(playlistService: PlaylistService = PlaylistServiceImpl.shared) {
        self.playlistService = playlistService
        fetchPlaylists()
    }
    
    // Fetches playlists for the current user
    func fetchPlaylists() {
        guard let userID = currentUserID else {
            print("DEBUG: No user is currently logged in.")
            return
        }
        Task {
            let fetchedPlaylists = await playlistService.getPlaylists(uid: userID)
            DispatchQueue.main.async {
                // Updates playlists on the main thread
                self.playlists = fetchedPlaylists
            }
        }
    }
    
    // Creates a new playlist with a given name
    func createPlaylist(withName name: String) {
        guard let userID = Auth.auth().currentUser?.uid else {
            // Debug message if no user is logged in
            print("DEBUG: No user is currently logged in.")
            return
        }
    
        Task {
            await playlistService.createPlaylist(uid: userID, name: name)
            // Fetch playlists after creating a new one
            fetchPlaylists()
        }
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
        fetchPlaylists()
    }
}
