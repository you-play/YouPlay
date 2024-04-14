//
//  HomeViewModel.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import Combine
import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var topPlaylists: [Playlist] = []
    @Published var playlistIdToSongs: [String: [Song]] = [:]

    /// Initial loading state
    @Published var isLoading: Bool = false
    @Published var isLoadingSongMetadata: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupSubscribers()

        Task {
            isLoading = true
            await fetchTopPlaylists(inBackground: false)
            isLoading = false
        }
    }

    // Fetches the top playlists. If `inBackground` is enabled, it won't activate any loading skeletons/state.
    @MainActor
    func fetchTopPlaylists(inBackground: Bool) async {
        guard let uid = currentUser?.uid else {
            print("DEBUG: unable to fetch top 6 playlists without a uid")
            return
        }

        topPlaylists = await PlaylistServiceImpl.shared.getTopPlaylists(uid: uid, limit: TOP_PLAYLISTS_LIMIT)
        playlistIdToSongs = await PlaylistServiceImpl.shared.getPlaylistIdToSongsMap( // can be slow!
            for: topPlaylists,
            inBackground: inBackground
        )
    }

    private func setupSubscribers() {
        UserServiceImpl.shared.$currentUser.sink { [weak self] currentUser in
            self?.currentUser = currentUser
        }
        .store(in: &cancellables)

        PlaylistServiceImpl.shared.$isLoadingSongMetadata.sink { [weak self] isLoadingSongMetadata in
            self?.isLoadingSongMetadata = isLoadingSongMetadata
        }
        .store(in: &cancellables)
    }
}
