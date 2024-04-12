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

    @Published var song: Song? = nil
    @Published var isPaused: Bool = true
    @Published var isLiked: Bool = false
    @Published var playlists: [Playlist] = []

    private var cancellables = Set<AnyCancellable>()
    var spotifyController: SpotifyController

    init(spotifyController: SpotifyController) {
        self.spotifyController = spotifyController
        setupSubscribers()

        Task {
            if let songId = song?.id {
                // load initial liked state
                isLiked = await isLikedSong(songId: songId)
            }
        }
    }

    func toggleLike(song: Song) async {
        guard let uid = currentUser?.uid else {
            print("DEBUG: unable to update liked status for song with id \(song.id) without a uid")
            return
        }

        // optismitically update isLiked for instant feedback
        let snapshotIsLiked = isLiked
        isLiked.toggle()

        await PlaylistServiceImpl.shared.toggleLikedStatus(
            uid: uid,
            song: song,
            isLiked: snapshotIsLiked)

        isLiked = await isLikedSong(songId: song.id) // fetch the "thruth"
        print("DEBUG: toggling liked status for song '\(song.name)' for uid \(uid)")
    }

    func isLikedSong(songId: String) async -> Bool {
        guard let uid = currentUser?.uid else {
            print("DEBUG: unable to find if the song has been liked without uid")
            return false
        }

        return await PlaylistServiceImpl.shared.isLikedSong(uid: uid, songId: songId)
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
