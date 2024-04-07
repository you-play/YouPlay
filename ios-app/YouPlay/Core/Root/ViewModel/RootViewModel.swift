//
//  RootViewModel.swift
//  YouPlay
//
//  Created by Sebastian on 3/16/24.
//

import Combine
import Firebase
import FirebaseAuth
import Foundation

@MainActor
class RootViewModel: ObservableObject {
    @Published var currentUser: User?

    // TODO: we will need to manage liking and pause/play functionality
    @Published var song: Song? = nil
    @Published var isPaused: Bool = true
    @Published var isLiked: Bool = true
    @Published var playlists: [Playlist] = []

    private var cancellables = Set<AnyCancellable>()
    var spotifyController: SpotifyController

    init(spotifyController: SpotifyController) {
        self.spotifyController = spotifyController
        setupSubscribers()
    }
    func addLikedSongToPlaylist(user : User , song: Song) async{
        guard let uid = user.uid else{
            print("DEBUG: unable to add song \(song.name) to Liked Songs Playlist without a UID")
            return
        }
        print("DEBUG: adding song '\(song.name)' to Liked Songs Playlist for username '\(user.username)'")
        await PlaylistServiceImpl.shared.addSongToLikedSongs(uid: uid, song: song)
    }

    func addSongToPlaylist(user: User, playlist: Playlist, song: Song) async {
        guard let uid = user.uid else {
            print("DEBUG: unable to add song \(song.name) to playlist \(playlist.title) without a UID")
            return
        }

        print("DEBUG: adding song '\(song.name)' to playlist '\(playlist.title)' for username '\(user.username)'")
        await PlaylistServiceImpl.shared.addSongToPlaylist(uid: uid, playlistId: playlist.id, song: song)
    }

    func fetchPlaylists() async {
        guard let uid = currentUser?.uid else {
            print("DEBUG: unable to fetch playlists without a uid")
            return
        }

        print("DEBUG: fetching playlists for uid \(uid)...")
        playlists = await PlaylistServiceImpl.shared.getPlaylists(uid: uid)
    }

    private func setupSubscribers() {
        UserServiceImpl.shared.$currentUser.sink { [weak self] currentUser in
            self?.currentUser = currentUser
        }
        .store(in: &cancellables)

        spotifyController.$isPaused.sink { [weak self] isPaused in
            self?.isPaused = isPaused
        }
        .store(in: &cancellables)

        spotifyController.$song.sink { [weak self] song in
            self?.song = song
        }
        .store(in: &cancellables)
    }
}
