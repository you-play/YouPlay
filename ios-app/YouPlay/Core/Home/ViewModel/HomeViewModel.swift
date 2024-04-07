//
//  HomeViewModel.swift
//  YouPlay
//
//  Created by Sebastian on 3/13/24.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var topPlaylists: [Playlist] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupSubscribers()
    }

    @MainActor
    func fetchTopPlaylists() async {
        guard let uid = currentUser?.uid else {
            print("DEBUG: unable to fetch top 6 playlists without a uid")
            return
        }

        topPlaylists = await PlaylistServiceImpl.shared.getTopPlaylists(uid: uid, limit: TOP_PLAYLISTS_LIMIT)
    }

    // TODO: add impl
    func fetchSongsForPlaylist(playlistId: String) -> [Song] {
        return Song.mocks
    }

    private func setupSubscribers() {
        UserServiceImpl.shared.$currentUser.sink { [weak self] currentUser in
            self?.currentUser = currentUser
        }
        .store(in: &cancellables)
    }
}
